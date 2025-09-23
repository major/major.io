---
author: Major Hayden
date: '2025-09-23'
summary: >
  After trying various performance monitoring tools over the years,
  I found that Performance Co-Pilot (PCP) provides tons of useful data.
tags:
  - fedora
  - linux
  - monitoring
  - gpu
  - performance
title: Monitor system and GPU performance with Performance Co-Pilot
coverAlt: Metal pieces and springs inside some kind of machine
coverCaption: |
  Photo by <a href="https://unsplash.com/@theotherworkspace?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">David Fintz</a> on <a href="https://unsplash.com/photos/a-close-up-of-some-pipes-ABboNaq5XXU?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
---

I've used so many performance monitoring tools and systems over the years.
When you need to know information right now, tools like [btop](https://github.com/aristocratos/btop) and [glances](https://nicolargo.github.io/glances/) are great for quick overviews.
Historical data is fairly easy to pick through with [sysstat](https://github.com/sysstat/sysstat).

However, when you want a comprehensive view of system performance over time, especially with GPU metrics for machine learning workloads, [Performance Co-Pilot (PCP)](https://pcp.io/) is an excellent choice.
It has some handy integrations with [Cockpit](https://cockpit-project.org/) for web-based monitoring, but I prefer using the command line tools directly.

This post explains how to set up PCP on Fedora and enable some very basic GPU monitoring for both NVIDIA and AMD GPUs.

## Installing Performance Co-Pilot

Install the core packages and command line tools:

```bash
sudo dnf install pcp pcp-system-tools
```

Enable and start the PCP services:

```bash
sudo systemctl enable --now pmcd pmlogger
sudo systemctl status pmcd
```

These two services work together like a team:

* `pmcd` (Performance Metrics Collection Daemon) gathers real-time metrics from various sources on your system.
* `pmlogger` records these metrics to log files for historical analysis.

You can verify that the services are working as expected:

```bash
# Check available metrics
pminfo | head -20

# View current CPU utilization
pmval kernel.all.cpu.user

# Show memory statistics
pmstat -s 5
```

## Adding GPU metrics collection

I do a lot of LLM work locally and I'd like to keep track of my GPU usage over time.
Fortunately, PCP supports popular GPUs through something called a PMDA (Performance Metrics Domain Agent).
These are packaged in Fedora, but they have an interesting installation process.

### NVIDIA GPUs

{{< alert >}}
**Unverified instructions:**
I only have an AMD GPU, but I pulled this NVIDIA information from various places on the internet.
Please let me know if you find any issues and I'll update the post!
{{< /alert >}}

For NVIDIA GPUs, ensure you have the NVIDIA drivers and `nvidia-ml` library:

```bash
# Check if nvidia-smi works
nvidia-smi

# Install the NVIDIA management library if needed
sudo dnf install nvidia-driver-cuda-libs
```

Now install the NVIDIA PMDA:

```bash
cd /var/lib/pcp/pmdas/nvidia
sudo ./Install
```

The installer will prompt you for configuration options.
Accept the defaults unless you have specific requirements.

After installation, verify GPU metrics are available:

```bash
# List all NVIDIA metrics
pminfo nvidia

# Check GPU utilization
pmval nvidia.gpuutil

# Monitor GPU memory usage
pmval nvidia.fb.used
```

### AMD GPUs

For AMD GPUs, PCP provides the `amdgpu` PMDA that works with the ROCm stack:

```bash
# Ensure rocm-smi is installed and working
rocm-smi

# Install the AMD GPU PMDA package
sudo dnf install pcp-pmda-amdgpu

# Install the PMDA
cd /var/lib/pcp/pmdas/amdgpu
sudo ./Install
```

After installation, verify AMD GPU metrics:

```bash
# List all AMD GPU metrics
pminfo amdgpu

# Check GPU utilization
pmval amdgpu.gpu.load

# Monitor GPU memory usage
pmval amdgpu.memory.used
```

## Querying performance data

There are lots of handy tools for querying PCP data depending on whether you need information about something happening now or want to analyze historical trends.

### Real-time monitoring with pmrep

The `pmrep` tool provides formatted output perfect for dashboards or scripts.
It's great for situations where you need to see what's happening right now.
It's much like `iostat` or `vmstat` from the sysstat package, but you get a lot more flexibility.

```bash
# System overview with 1-second updates
pmrep -t 1 kernel.all.load kernel.all.cpu.user mem.util.used

# GPU metrics for LLM monitoring (NVIDIA)
pmrep -t 1 nvidia.gpuutil nvidia.fb.used nvidia.temp

# GPU metrics for LLM monitoring (AMD)
pmrep -t 1 amdgpu.gpu.load amdgpu.memory.used amdgpu.gpu.temperature

# Custom format for specific metrics (NVIDIA)
pmrep -p -t 2 nvidia.power nvidia.clocks.sm nvidia.temp

# Custom format for specific metrics (AMD)
pmrep -p -t 2 amdgpu.gpu.load amdgpu.memory.used amdgpu.gpu.temperature
```

### Historical analysis with pmlogsummary

If you're used to to running `sar` commands from the sysstat package, you'll find `pmlogsummary` very familiar.
Again, you can do a lot more with `pmlogsummary` than with `sar`, but the basic concepts are similar.

```bash
# Summarize yesterday's GPU utilization (NVIDIA)
pmlogsummary -S @yesterday -T @today /var/log/pcp/pmlogger/$(hostname)/$(date -d yesterday +%Y%m%d) nvidia.gpuutil

# Summarize yesterday's GPU utilization (AMD)
pmlogsummary -S @yesterday -T @today /var/log/pcp/pmlogger/$(hostname)/$(date -d yesterday +%Y%m%d) amdgpu.gpu.load

# Find peak memory usage over the last hour
pmlogsummary -S -1hour /var/log/pcp/pmlogger/$(hostname)/$(date +%Y%m%d) mem.util.used
```

## Monitoring LLM workloads

You can create a custom configuration if you want to pull certain metrics frequently with a specific format.
This is great for monitoring scripts or dashboards.

```bash
cat > ~/.pcp/pmrep/llm-monitor.conf << 'EOF'
[llm-metrics]
timestamp = %%H:%%M:%%S
kernel.all.cpu.user = CPU,,,,8
mem.util.used = Memory,,,,8
# For NVIDIA GPUs:
#nvidia.gpuutil = GPU,,,,6
#nvidia.fb.used = VRAM,MB,,,8
#nvidia.temp = Temp,C,,,6
#nvidia.power = Power,W,,,7
# For AMD GPUs (comment out NVIDIA lines and uncomment these):
#amdgpu.gpu.load = GPU,,,,6
#amdgpu.memory.used = VRAM,MB,,,8
#amdgpu.gpu.temperature = Temp,C,,,6
#amdgpu.gpu.average_power = Power,W,,,7
EOF

# Use the custom configuration
pmrep -c ~/.pcp/pmrep/llm-monitor.conf -t 1 :llm-metrics
```

## Troubleshooting tips

If GPU metrics aren't showing up:

```bash
# Check if the PMDA is properly installed
pminfo -f pmcd.agent | grep -E "amdgpu|nvidia"

# Restart PMCD to reload PMDAs
sudo systemctl restart pmcd

# Check PMDA logs for errors
sudo journalctl -u pmcd -n 50

# Verify GPU drivers are working
rocm-smi  # for AMD
nvidia-smi  # for NVIDIA
```

## Further reading

* [Performance Co-Pilot documentation](https://pcp.io/documentation.html) - Official PCP documentation and quick reference guides
* [PCP GPU monitoring guide](https://pcp.io/docs/guides/howto-nvidia.html) - Detailed setup for NVIDIA GPU metrics
* [Red Hat's PCP guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/monitoring-performance-with-performance-co-pilot_monitoring-and-managing-system-status-and-performance) - Enterprise deployment patterns and best practices
* [PCP Python API](https://pcp.io/man/man3/python.3.html) - Building custom monitoring tools with Python
