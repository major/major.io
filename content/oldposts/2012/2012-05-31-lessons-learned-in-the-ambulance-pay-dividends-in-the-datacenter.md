---
title: Lessons learned in the ambulance pay dividends in the datacenter
author: Major Hayden
date: 2012-05-31T15:00:47+00:00
url: /2012/05/31/lessons-learned-in-the-ambulance-pay-dividends-in-the-datacenter/
dsq_thread_id:
  - 3642806959
tags:
  - emergency
  - general advice
  - operations
  - sysadmin

---
While cleaning up a room at home in preparation for some new flooring, I found my original documents from when I first became certified as an Emergency Medical Technician (EMT) in Texas. That was way back in May of 2000 and I received it just before I graduated from high school later in the month. After renewing it twice, I decided to let my certification go this year. It expires today and although I'm sad to see it go, I know that sometimes you have to let one thing go so that you can excel in something else.

I [mentioned this][1] yesterday on Twitter and [Jesse Newland from GitHub][2] came back with a good reply:

<div id="attachment_3345" style="width: 459px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2012/05/emtopstweet.jpg"><img src="/wp-content/uploads/2012/05/emtopstweet.jpg" alt="EMT, ops, oncall, incident management tweet" title="EMT, ops, oncall, incident management tweet" width="449" height="286" class="size-full wp-image-3345" srcset="/wp-content/uploads/2012/05/emtopstweet.jpg 449w, /wp-content/uploads/2012/05/emtopstweet-300x191.jpg 300w" sizes="(max-width: 449px) 100vw, 449px" /></a>

  <p class="wp-caption-text">
    The tweet that inspired this post
  </p>
</div>

It began to make more sense the more I thought about it (and once [Mark Imbriaco][3] and [Jerry Chen][4] asked for it as well). Working in Operations in a large server environment has a lot of similarities to working on an ambulance:

  * both involve fixing things (whether it's technology or an illness/injury)
  * there are plenty of highly stressful situations in both occupations
  * lots of money is riding on the decisions made at a keyboard or at a stretcher
  * if you can't work as a team, you can't do either job effectively
  * there is always room for improvement (and I do mean always)
  * not having all the facts can lead to perilous situations

Without further ado, here are some lessons I learned on the ambulance which have really helped me as a member of an operations team. I've broken them up into separate chunks (more on that lesson shortly) to make it a little easier to read:

**Whatever happens, keep your cool**

One of the worst situations you can have on an ambulance is when an EMT or paramedic feels overwhelmed to the point that they can't function. Imagine rolling up with your partner on a multi-car collision with several injured drivers and passengers. It's just the two of you at the scene and you need to start working. You're obviously outnumbered and you won't be able to treat everyone at once. Now, imagine that your partner hasn't seen this type of situation and is actively buckling under the pressure. The quality of care you're trained to deliver and the efficiency at which you can deliver it has now been slashed in half. Even worse, getting your partner back on track might take some work and this may slow you down even more.

The same can be said about working on large incidents affecting your customers. You're probably going to be outnumbered by the amount of servers having a problem and you won't get them back online any sooner if you're beginning to freak out. Just remember, as with servers and as with people (most of the time), they were running fine at one time and they'll be running fine again soon. Your job is to bridge the gap between those times and try to get to the end goal as soon as possible.

You might miss some things or not complete certain tasks as well as you'd like to. You might slip and make things worse than they were before. One step backward and two steps forward is painful, but it's still progress. Keep your mind clear and focused so that you can use your knowledge, skills, and experience to pave a path out.

**Triage, triage, triage**

Going back to the multi-car collision scenario, you're well aware that you won't be able to take care of everyone at once. This is where skillful triaging is key. Find the people who are in the most dire situations and treat them first. Although it seems counterproductive, you may have to pass over the people who are hurt so badly that they have little chance of survival. Spending additional time with those people may cause patients with treatable conditions to deteriorate further unnecessarily. It may sound callous, but I'd rather have a few people with serious injuries get treated than lose all of them while I'm treating someone who is essentially near death.

Lots of this can be carried over into maintaining servers. When a big problem occurs, you can spend all of your time wrestling with servers that are beyond repair only to watch the remainder of your environment crash around you. Find ways to stop the bleeding first and then figure out some solid fixes.

For example, if your database cluster gets out of sync, think of the things you can do to reduce the amount of bad data coming in. Could you have your load balancer send traffic elsewhere? Could you disable your application until the database problem is solved? If you lose sight of what's causing you immediate pain, you may spend all day trying to fix the broken database cluster only to find that you have many multitudes more data to sort out due to your application running throughout the whole process.

<div id="attachment_3366" style="width: 250px" class="wp-caption alignright">
  <a href="/wp-content/uploads/2012/05/head_in_hands.jpg"><img src="/wp-content/uploads/2012/05/head_in_hands.jpg" alt="Head in hands" title="Head in hands" width="240" height="240" class="size-full wp-image-3366" srcset="/wp-content/uploads/2012/05/head_in_hands.jpg 240w, /wp-content/uploads/2012/05/head_in_hands-150x150.jpg 150w" sizes="(max-width: 240px) 100vw, 240px" /></a>

  <p class="wp-caption-text">
    Flickr via jar0d
  </p>
</div>

**Learn from your mistakes and don't dwell on them**

Medical mistakes can range anywhere from unnoticeable to career-endingly serious. One missed tidbit of a patient's medical history, one small math error when administering drugs, or one slip of the hand can make a bad situation much worse. I've made mistakes on the ambulance and I've been very fortunate that almost all of them were very small and inconsequential. If I made one that went unnoticed, I made an effort to notify my supervisor and whoever would be taking over care of my patient. For the mistakes I didn't even notice on my own, my partners would often be quick to point out the error.

Getting called out on a mistake (even if you call yourself out on it) hurts. Funnel the frustration from it into a plan to fix it. Do some reading to understand the right solution. Learn mnemonics to remember in stressful situations. Make notes for yourself. Practice. Those small steps will reduce your mistakes through increasing your confidence.

Although most Ops engineers should survive big incidents with their lives intact, mistakes are still made and they can be costly. Mistakes can turn into a positive learning experience for everyone on the team. There's a [great post][5] on Etsy's "Code as Craft" blog about this topic.

John Allspaw wrote:

> A funny thing happens when engineers make mistakes and feel safe when giving details about it: they are not only willing to be held accountable, they are also enthusiastic in helping the rest of the company avoid the same error in the future. They are, after all, the most expert in their own error.

The only true mistake is the one which is made but never learned from. Accept it, learn from it, teach others to avoid it and move forward.

**Get all the facts to avoid assumptions**

My mother (an Engish teacher) always told me to put the most important things at the beginning and and the end when I write. If there's anything more important than keeping your cool under duress, it's that you should have as many facts as you can before you get started.

On the ambulance, you're always looking for the very small clues to ensure that your patient is getting the proper treatment. You may walk up to a patient with slurred speech who can't walk straight. You may think he's drunk until you see a small bottle of insulin and a blood glucose meter. Wait, did his blood sugar bottom out? Did he take his insulin at the wrong time? Did he take the wrong amount? Missing that small bit of information may lead you to put your "drunk" patient onto a stretcher without the proper treatment only to find that you're dealing with a diabetic coma as you get to the hospital. That incorrect assumption could have turned a serious situation into a possibly fatal one.

Responding to incidents with servers is much the same. Skipping over a server with data corruption or not realizing that a change was made (and documented) earlier in the day could lead to serious damage. Forgetting to check log files, streams of exceptions, or reports from customers can lead to bad assumptions which could extend your downtime or cause the loss of data.

* * *In summary, here's my internal runbook from when I was working full time as an EMT:</p>

  1. Stop the bleeding
  2. Find the root cause of the problem
  3. Make a plan (or plans) to fix it
  4. Vet out your best plan with your partner if it seems risky
  5. Execute the plan
  6. Monitor the results
  7. Review the plan's success or failure with a trusted expert

When I'm fighting outages at work, I reach back into this runbook and try my best to follow the steps. It helps me keep my cool, reduce mistakes, and proceed with better plans. I'd be curious to hear your feedback about how this runbook could work for your Operations team or if you have ideas for edits.

 [1]: http://twitter.com/#!/rackerhacker/status/207854697434976256
 [2]: https://twitter.com/jnewland
 [3]: http://twitter.com/#!/markimbriaco/status/207894151788888067
 [4]: http://twitter.com/#!/jcsalterego/status/207893999716016130
 [5]: http://codeascraft.etsy.com/2012/05/22/blameless-postmortems/
