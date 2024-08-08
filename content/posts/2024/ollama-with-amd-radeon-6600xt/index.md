---
author: Major Hayden
date: '2024-08-08'
summary: |
  The local LLM easy button, ollama, won't work with the AMD Radeon 6600 XT out of the box.
  The fix is a quick one!
tags: 
  - amd
  - ollama
  - fedora
  - linux
title: Running ollama with an AMD Radeon 6600 XT
coverAlt: Lights hanging in a tree
coverCaption: |
  [Steve Wrzeszczynski](https://unsplash.com/photos/a-panda-in-a-barn-STkFxq9wWCc) via Unsplash
---

I'm splitting time between two roles at work now and one of the roles has a heavy focus on [LLMs](https://en.wikipedia.org/wiki/Large_language_model).
Much like many of you, I've given ChatGPT a try with questions from time to time.
I've also used GitHub Copilot within Visual Studio Code.

They're all great, but I was really hoping to run something locally on my machine at home.

Then I stumbled upon a great post on All Things Open titled "[Build a local AI co-pilot using IBM Granite Code, Ollama, and Continue](https://allthingsopen.org/articles/build-a-local-ai-co-pilot)" that started me down a path with [ollama](https://ollama.com/).
The ollama project gets you started with a local LLM and makes it easy to serve it for other applications to use.

## It's so slow 🐌

When I first began connecting vscode to ollama, I noticed that the responses were incredibly slow.
A quick check with [btop](https://github.com/aristocratos/btop) showed that my CPU was maxed out at 100% utilization and my GPU was entirely idle.
That's not good.

My first thought was to check the system journal with `sudo journalctl --boot -u ollama`.
That gets me all the messages from ollama since I last booted the machine.

```text
source=images.go:781 msg="total blobs: 0"
source=images.go:788 msg="total unused blobs removed: 0"
source=routes.go:1155 msg="Listening on 127.0.0.1:11434 (version 0.3.4)"
source=payload.go:30 msg="extracting embedded files" dir=/tmp/ollama1586759388/runners
source=payload.go:44 msg="Dynamic LLM libraries [cpu_avx cpu_avx2 cuda_v11 rocm_v60102 cpu]"
source=gpu.go:204 msg="looking for compatible GPUs"
source=amd_linux.go:59 msg="ollama recommends running the https://www.amd.com/en/support/linux-drivers" error="amdgpu version file missing: /sys/module/amdgpu/version stat /sys/module/amdgpu/version: no such file or directory"
source=amd_linux.go:340 msg="amdgpu is not supported" gpu=0 gpu_type=gfx1032 library=/usr/lib64 supported_types="[gfx1030 gfx1100 gfx1101 gfx1102]"
source=amd_linux.go:342 msg="See https://github.com/ollama/ollama/blob/main/docs/gpu.md#overrides for HSA_OVERRIDE_GFX_VERSION usage"
source=amd_linux.go:360 msg="no compatible amdgpu devices detected"
```

A couple of things in the output stood out to me:

* `stat /sys/module/amdgpu/version: no such file or directory`
* `msg="amdgpu is not supported" gpu=0 gpu_type=gfx1032 library=/usr/lib64 supported_types="[gfx1030 gfx1100 gfx1101 gfx1102]"`
* `"See https://github.com/ollama/ollama/blob/main/docs/gpu.md#overrides for HSA_OVERRIDE_GFX_VERSION usage"`

Sure enough, the version was missing:

```console
> stat /sys/module/amdgpu/version
stat: cannot statx '/sys/module/amdgpu/version': No such file or directory
```

And my AMD GPU is indeed an AMD Navi 23 chipset (gfx1032):

```console
> lspci | grep -i VGA
0f:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Navi 23 [Radeon RX 6600/6600 XT/6600M] (rev c7)
```

I went over to the [linked overrides documentation](https://github.com/ollama/ollama/blob/main/docs/gpu.md#overrides) to figure out what `HSA_OVERRIDE_GFX_VERSION` is all about:

> Ollama leverages the AMD ROCm library, which does not support all AMD GPUs. In some cases you can force the system to try to use a similar LLVM target that is close. For example The Radeon RX 5400 is gfx1034 (also known as 10.3.4) however, ROCm does not currently support this target. The closest support is gfx1030. You can use the environment variable HSA_OVERRIDE_GFX_VERSION with x.y.z syntax. So for example, to force the system to run on the RX 5400, you would set HSA_OVERRIDE_GFX_VERSION="10.3.0" as an environment variable for the server. If you have an unsupported AMD GPU you can experiment using the list of supported types below.

## The fix

The docs recommended setting `HSA_OVERRIDE_GFX_VERSION="10.3.0"` to see if my card will work.
Let's edit the systemd unit file for ollama to drop in some additional configuration:

```console
> sudo systemctl edit ollama.service
```

An editor appeared with text in it:

```ini
### Editing /etc/systemd/system/ollama.service.d/override.conf
### Anything between here and the comment below will become the contents of the drop-in file

### Edits below this comment will be discarded
```

So I added the suggested override along with the path to my AMD ROCm directory:

```ini
### Editing /etc/systemd/system/ollama.service.d/override.conf
### Anything between here and the comment below will become the contents of the drop-in file

[Service]
Environment="HSA_OVERRIDE_GFX_VERSION=10.3.0"
Environment="ROCM_PATH=/opt/rocm"

### Edits below this comment will be discarded
```

Then I can tell systemd to reload the unit and restart ollama:

```console
> sudo systemctl daemon-reload
> sudo systemctl stop ollama
> sudo systemctl start ollama
```

Back to the system journal for another look:

```text
source=amd_linux.go:348 msg="skipping rocm gfx compatibility check" HSA_OVERRIDE_GFX_VERSION=10.3.0
source=types.go:105 msg="inference compute" id=0 library=rocm compute=gfx1032 driver=0.0 name=1002:73ff total="8.0 GiB" available="5.9 GiB"
```

Success! 🎉

## Giving it another try

I went back to vscode and tried some code completions, but they were only slightly faster than using the CPU.
Each time I'd wait for completion, I'd watch btop and the GPU would spike, then the CPU, then the GPU spikes again, and so on.

After talking with a coworker, it looks like my Radeon 6600 XT is great for games, but it lacks the RAM needed to load the model into the GPU. 😭
From what I've read, 24GB is the suggested minimum and that's the largest amount of RAM you'll find in most GeForce/Radeon consumer graphics cards.