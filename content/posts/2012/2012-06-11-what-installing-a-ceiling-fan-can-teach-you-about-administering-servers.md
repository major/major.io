---
title: What installing a ceiling fan can teach you about administering servers
author: Major Hayden
date: 2012-06-11T16:00:57+00:00
url: /2012/06/11/what-installing-a-ceiling-fan-can-teach-you-about-administering-servers/
dsq_thread_id:
  - 3678929611
tags:
  - general advice
  - sysadmin

---
The feedback from my last lengthy post (_[Lessons learned in the ambulance pay dividends in the datacenter][1]_) about analogies between EMS and server administration was mostly positive, so I decided to do it again!

Our ceiling fan in our living room died the night before we had all of our floors replaced and I knew that a portion of my weekend would be lost trying to replace it. The motor was totally dead but at least the lights still worked. However, in Texas, if the motor isn't running, no air is moving and the fan is worthless. Replacing the fan wouldn't be an easy task: our living room is 14 feet tall (that's about 4.3 meters) and our replacement fan was a pretty heavy one. Add in an almost-two-year-old running around the living room during the process and it gets a little tougher.

I took the old fan off pretty easily and was immediately stumped about the new one. The instructions had a method of installation that wasn't compatible with the outlet box in the ceiling and I didn't have the right bolts and washers for the job. A quick trip to Lowe's solved that and I was back in the game. The motor was soon hung, the wiring was connected, and I tested the wall switch. The motor didn't move.

At this point, I figured that the light assembly was required for the motor to run. I screwed everything in, connected the light assembly, and still no movement. I thought that the light switch had possibly gone bad since my wife saw the lights flicker last week when she turned off the fan. Another trip to Lowe's yielded a new switch. Installed that - still no movement. Double-checked the breaker. Re-did the wiring in the fan. Tried the switch again. No movement.

The confusion soon started. The fan was new, the motor was new, the switch was new, and the wiring was verified. I called my stepfather in the hopes that he could think of something I couldn't but he said I'd thought of everything. He came over with a voltage tester and verified that the switch had power and so did the fan. He re-did the wiring and tried again. Still no movement.

He tilted his head for a second, then looked down at me:

> You did try pulling the chain for the fan, right? Usually the factory sets them up so that the lights and fan are off when you hang it. You know, for safety.

After a quick tug of the chain the motor was flying. I felt like an idiot and he had a good chuckle at my expense.

**What's the point?**

We all do things like this when we administer servers. I touched on this back in [January 2010][2] and it's probably important enough to mention again. **Go for the simplest solutions first.** They're not only easier and faster to verify, but you'll be guaranteed to forget about them if you dive right into the more complicated stuff at first. Also, bear in mind that the same set of instructions won't fit all scenarios and situations. Trust your instincts when you know they're right.

Sometimes situations crop up where you really need a second set of eyes. We're all eager to find the solution ourselves and avoid bothering others, but when you find yourself flailing for a solution, the best remedy may be to share your troubles with someone you trust.

 [1]: /2012/05/31/lessons-learned-in-the-ambulance-pay-dividends-in-the-datacenter/
 [2]: /2010/01/03/a-new-year-system-administrator-inspiration/
