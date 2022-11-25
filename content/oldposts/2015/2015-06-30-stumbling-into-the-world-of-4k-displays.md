---
title: 'Stumbling into the world of 4K displays [UPDATED]'
author: Major Hayden
date: 2015-07-01T04:33:43+00:00
url: /2015/06/30/stumbling-into-the-world-of-4k-displays/
dsq_thread_id:
  - 3894070814
tags:
  - fedora
  - kernel

---
![1]

Woot [suckered me into buying a 4K display][2] at a fairly decent price and now I have a [Samsung U28D590D][3] sitting on my desk at home. I ordered a mini-DisplayPort to DisplayPort from Amazon and it arrived just before the monitor hit my doorstep. It's time to enter the world of 4K displays.

The unboxing of the monitor was fairly uneventful and it powered up after small amount of assembly. I plugged my mini-DP to DP cable into the monitor and then into my X1 Carbon 3rd gen. After a bunch of flickering, the display sprang to life but the image looked fuzzy. After some hunting, I found that the resolution wasn't at the monitor's maximum:

```
$ xrandr -q
DP1 connected 2560x1440+2560+0 (normal left inverted right x axis y axis) 607mm x 345mm
   2560x1440     59.95*+
   1920x1080     60.00    59.94
   1680x1050     59.95
   1600x900      59.98
```


I bought this thing because it does 3840&#215;2160. How confusing. After searching through the monitor settings, I found an option for "DisplayPort version". It was set to version 1.1 but version 1.2 was available. I selected version 1.2 (which appears to come with something called HBR2) and then the display flickered for 5-10 seconds. There was no image on the display.

I adjusted GNOME's Display settings back down to 2560&#215;1440. The display sprang back to life, but it was fuzzy again. I pushed the settings back up to 3840&#215;2160. The flickering came back and the monitor went to sleep.

My laptop has an HDMI port and I gave that a try. I had a 3840&#215;2160 display up immediately! Hooray! But wait - that resolution runs at 30Hz over [HDMI 1.4][4]. HDMI 2.0 promises faster refresh rates but neither my laptop or the display support it. After trying to use the display at max resolution with a 30Hz refresh rate, I realized that it wasn't going to work.

The adventure went on and I joined #intel-gfx on Freenode. This is apparently a common problem with many onboard graphics chips as many of them cannot support a 4K display at 60Hz. It turns out that the i5-5300U (that's a Broadwell) [can do it][5].

One of the knowledgeable folks in the channel [suggested a new modeline][6]. That had no effect. The monitor flickered and went back to sleep as it did before.

I picked up some education on the [difference between SST and MST displays][7]. MST displays essentially have two chips handling half of the display within the monitor. Both of those do the work to drive the entire display. SST monitors (the newer variety, like the one I bought) take a single stream and one single chip in the monitor figures out how to display the content.

At this point, I'm stuck with a non-working display at 4K resolution over DisplayPort. I can get lower resolutions working via DisplayPort, but that's not ideal. 4K works over HDMI, but only at 30Hz. Again, not ideal. I'll do my best to update this post as I come up with some other ideas.

**UPDATE 2015-07-01:** Thanks to Sandro Mathys for spotting a potential fix:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p lang="en" dir="ltr">
    <a href="https://twitter.com/majorhayden">@majorhayden</a> Uh, did you update your BIOS? "Supported the 60Hz refresh rate of 4K (3840 x 2160) resolution monitor." <a href="http://t.co/NbnktzZMgj">http://t.co/NbnktzZMgj</a>
  </p>

  <p>
    &mdash; Sandro Mathys (@red_trela) <a href="https://twitter.com/red_trela/status/616243412216496128">July 1, 2015</a>
  </p>
</blockquote>



I [found BIOS 1.08 waiting for me][8] on Lenovo's site. One of the last items fixed in the release notes was:

> (New) Supported the 60Hz refresh rate of 4K (3840 x 2160) resolution monitor.

After a quick flash of a USB stick and a reboot to update the BIOS, the monitor sprang to life after logging into GNOME. It looks amazing! The graphics performance is still not amazing (but hey, this is Broadwell graphics we're talking about) but it does 3840&#215;2160 at 60Hz without a hiccup. I tried unplugging and replugging the DisplayPort cable several times and it never flickered.

 [1]: /wp-content/uploads/2015/06/U28D590D_display.jpg
 [2]: http://www.woot.com/offers/samsung-28-4k-led-backlit-monitor-22
 [3]: http://www.samsung.com/us/computer/monitors/LU28D590DS/ZA
 [4]: https://en.wikipedia.org/wiki/HDMI#Version_1.4
 [5]: http://ark.intel.com/products/85213/Intel-Core-i5-5300U-Processor-3M-Cache-up-to-2_90-GHz
 [6]: https://gist.github.com/ValdikSS/175f0f89d40b8689c0eb
 [7]: https://community.amd.com/community/gaming/blog/2015/05/12/celebrating-a-new-generation-of-ultrahd-displays
 [8]: http://support.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-20bs-20bt/downloads/DS101953
