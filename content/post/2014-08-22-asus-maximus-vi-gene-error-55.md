---
title: Asus Maximus VI Gene – Error 55
author: Major Hayden
type: post
date: 2014-08-22T14:20:23+00:00
url: /2014/08/22/asus-maximus-vi-gene-error-55/
dsq_thread_id:
  - 3642807732
categories:
  - Blog Posts
tags:
  - asus
  - fedora
  - hardware

---
It's been quite a while since I built a computer but I decided to give it a try for a new hypervisor/NAS box at home. I picked up an [Asus Maximus VI Gene][1] motherboard since it had some good parts installed and it seems to work well with Linux. This was my first time doing water cooling for the CPU and I picked up a [Seidon 240M][2] after getting some recommendations.

### Rubber hits the road

Once everything was in the box and the power was applied, I was stuck with an error code. There's a two-digit LCD display on the motherboard that rapidly flips between different codes during boot-up. If it stays on a code for a while and you don't get any display output, you have a problem. For me, this Asus Q code was 55.

The manual says it means that RAM isn't installed. I pulled out my four sticks of RAM and reseated all of them. I still got the same error. After reading a bunch of forum posts, I ran through a lot of troubleshooting steps:

  * Reseat the RAM
  * Try one stick of RAM and add more until the error comes back
  * Reseat the CPU cooler (at least three times)
  * Reseat the CPU (at least three times)
  * Upgrade the BIOS
  * Clear the CMOS
  * Curse loudly, [drink a beer][3], and come back

I still had error 55 and wasn't going anywhere fast. After some further testing, I found that if I left the two RAM slots next to the CPU empty, the system would boot. If I put any RAM in the two left RAM slots (A1 and A2), the system wouldn't boot. Here's an excerpt from the manual:



<div id="attachment_5170" style="width: 377px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/08/asus_mb.png"><img src="/wp-content/uploads/2014/08/asus_mb.png" alt="Asus Maximus VI Gene Motherboard CPU/memory layout" width="367" height="354" class="size-full wp-image-5170" srcset="/wp-content/uploads/2014/08/asus_mb.png 367w, /wp-content/uploads/2014/08/asus_mb-300x289.png 300w" sizes="(max-width: 367px) 100vw, 367px" /></a>

  <p class="wp-caption-text">
    CPU is on the left. RAM slots are A1, A2, B1, B2, left to right.
  </p>
</div>

### Fine-tuning the Google search

I adjusted my Google terms to include "A1 A2 slots" and found more posts talking about CPU coolers being installed incorrectly. Mine had to be correct - I installed it four times! I decided to try re-installing it one last time.

When I removed the CPU cooler from the CPU, I noticed something strange. There are four standoffs around the CPU that the cooler would attach to with screws. Those standoffs screwed into posts that connected to a bracket on the back of the motherboard.



<div id="attachment_5172" style="width: 1034px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/08/IMG_20140821_223505.jpg"><img src="/wp-content/uploads/2014/08/IMG_20140821_223505-1024x768.jpg" alt="Asus motherboard cpu cooler standoff" width="1024" height="768" class="size-large wp-image-5172" srcset="/wp-content/uploads/2014/08/IMG_20140821_223505-1024x768.jpg 1024w, /wp-content/uploads/2014/08/IMG_20140821_223505-300x225.jpg 300w" sizes="(max-width: 1024px) 100vw, 1024px" /></a>

  <p class="wp-caption-text">
    The lower two standoffs are highlighted.
  </p>
</div>

I removed the two standoffs that were closest to the A1/A2 RAM slots and noticed something peculiar. One side of the standoff had a black coating that seemed a bit tacky while the other side of the standoff was bare metal. Three of the standoffs had the black side down (against the board) while one had the black side up. I unscrewed that standoff and found that the bare metal side was wedged firmly onto some connections that run from the CPU to the A1/A2 RAM slots. _Could this be the issue?_

### Eureka

After double-checking all of the CPU cooler standoffs and attaching the cooler to the board, I crossed my fingers and hit the power button. The machine shot through POST and I was staring down a Fedora logo that quickly led to a GDM login.

<div id="attachment_5174" style="width: 1034px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/08/asus_mb_cooler_back.jpg"><img src="/wp-content/uploads/2014/08/asus_mb_cooler_back-1024x768.jpg" alt="Badly installed cpu cooler standoff" width="1024" height="768" class="size-large wp-image-5174" srcset="/wp-content/uploads/2014/08/asus_mb_cooler_back-1024x768.jpg 1024w, /wp-content/uploads/2014/08/asus_mb_cooler_back-300x225.jpg 300w" sizes="(max-width: 1024px) 100vw, 1024px" /></a>

  <p class="wp-caption-text">
    The culprit
  </p>
</div>

I don't talk about hardware too often on the blog, but I certainly hopes this helps someone else who is desperately trying to find a solution.

 [1]: http://www.asus.com/Motherboards/MAXIMUS_VI_GENE/
 [2]: http://www.coolermaster.com/cooling/cpu-liquid-cooler/seidon-240m/
 [3]: http://www.shiner.com/
