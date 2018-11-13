---
title: Preparing for Red Hat Exams
author: Major Hayden
type: post
date: 2012-02-28T21:35:28+00:00
url: /2012/02/28/preparing-for-red-hat-exams/
dsq_thread_id:
  - 3642806911
categories:
  - Blog Posts
tags:
  - fedora
  - general advice
  - linux
  - red hat
  - sysadmin
  - virtualization

---
<em style="color: grey;">I originally wrote this post for the <a href="http://www.rackspace.com/blog/preparing-for-red-hat-exams/">Rackspace Blog</a> but I've posted it here just in case anyone following my blog's feed finds it useful. Feel free to share your feedback!</em>

Getting yourself ready for any type of examination is usually a stressful experience that involves procrastination and some late nights leading up to the test. Every time I take one, I always say to myself, “I’m really going to get ahead of this next time and study early. This last minute stuff is terrible.” But I always forget all of this as the next exam rolls around.

Quick note: As you read through the remainder of the post, you may wonder why some of it is a bit vague. Every Red Hat test taker is under a NDA to prevent disclosure of test information that may reduce the security of the exam itself. Penalties start with losing credit for the exams previously taken and they can escalate up to legal action. I hope you’ll understand why I’m not able to go into details about certain portions of the Red Hat examinations.

I’ve taken seven Red Hat exams already: two for the RHCE and five for the RHCA. These tests certainly aren’t easy, but there are some good guidelines and tips you can use to make your studying efforts less stressful and more productive. Without further ado, here are my recommendations for prospective Red Hat examinees:

#### Build a flexible study environment

This is critical. You’ll need some spare servers or some available virtual machines to practice the objectives on each exam. However, don’t feel like you need to spend the money on a Red Hat subscription to get your studying done. Most of the test objectives on the majority of exams can be completed with very similar Linux distributions, like Scientific Linux or CentOS. Look for a version of the distribution that is closest to what you’ll be tested on at exam time. Your study environment should meet some basic criteria:

  * You should be able to quickly build and tear down servers or virtual machines
  * Keep the latency to your environment low to avoid getting frustrated
  * Use applications like VirtualBox, VMWare Fusion/Workstation to practice on your own computer
  * Consider using VMs from cloud providers if you’re under a time crunch

Some exams may require some bare-metal access to the server itself (especially [EX442][1]), so keep that in mind when you’re looking for a good practice environment. You may need some specific network or storage setups for some exams (as with [EX436][2]). If you’re not sure what you need, be sure to ask your instructor or someone else you know who has taken the exam already.

#### Prioritize doing over reading

The Red Hat exams are all hands-on, practical exams. You won’t find any essays or multiple-choice questions in these exams. Although the materials from Red Hat are full of good information, reading this information can only get you so far. You need to practice setting up the services on your own to be fully prepared for the test. If you’re not pressed for time, reading through the book can give you some details about the lab sequences, which you might miss by solely reading through labs themselves.

#### Research the why, not the what, to remember

This is especially important for the RHCA exam track. You may find that there is a ton of material to cover for the exam and that it’s difficult to remember each command to bring a certain service online or to repair a problem. Instead of thinking through the problem as “first, I do this, then I do this”, try to understand why each step is important in the first place.

Here’s a good example. I’ll be the first one to admit that Kerberos drives me crazy. I’ve even [written posts][3] about it. The commands seemed really archaic, the daemons didn’t make sense, and the lack of readline support in the Kerberos tools made me want to throw my computer out the window (come on, MIT!). I put my class materials aside, went to Google in a browser, and started researching Kerberos.

I read some of MIT’s documentation, ventured over to Wikipedia, and poked at some of the documentation within the Kerberos RPM packages. After a while, I began to realize how it all fit together. “Okay,” I thought to myself, “I need principals in a keytab to do these things, but I need to have a database for the admin stuff first.” Suddenly, the order of things in my head wasn’t just memorized any longer. The process of operations seemed to make logical sense because I fully understood how the pieces of a Kerberos infrastructure fit together.

If you start to get discouraged, take a break and learn more about why you’re doing what you’re doing. Once it becomes second nature, working through the problems on the exam becomes much easier.

#### Lean on your available resources

Don’t forget that there are other knowledgeable folks available to talk to when you get bogged down. Lean on other RHCE’s, RHCA’s, or experienced Linux users to get the answers or explanations you need. If you already have a Red Hat certification, head over to the [Red Hat Certification Forums][4] and meet up with other examinees that are discussing test preparation.

Also, you’ll find some knowledgeable (but sometimes snarky or quirky) people on IRC who are eager to point you in the right direction. Try the #rhel, #centos, or #fedora channels if you’re struggling through the configuration of a certain service. Many Linux users may roll their eyes about it, but Twitter is also a pretty good way to reach out to people who have a lot of Linux experience.

#### Summary

Remember to lean on the knowledge of others, get hands-on with the test objectives and do your research when you’re frustrated. The exams from Red Hat are generally difficult and cover a lot of material, but with the right amount of preparation and determination you can pass the exams and get the certifications you want.

 [1]: https://www.redhat.com/courses/ex442_red_hat_enterprise_system_monitoring_and_performance_tuning_expertise_exam/
 [2]: https://www.redhat.com/courses/ex436_red_hat_enterprise_clustering_and_storage_management_expertise_exam/
 [3]: http://rackerhacker.com/2012/02/02/kerberos-for-haters/
 [4]: https://certforums.redhat.com/login.php
