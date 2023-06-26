---
aliases:
- /2008/07/15/enabling-all-tests-with-nessus/
author: Major Hayden
date: 2008-07-15 17:00:03
tags:
- nessus
- security
title: Enabling all tests with Nessus
---

[Nessus][1] is one of those applications that makes me happy and drives me crazy at the same time. It does what I need it to, but it's often hard to get it rolling when it needs to do something for me. When I run it, I run it in batch mode, which requires me to have a .nessusrc file. However, there is almost no documentation on how to create one of these files.

Luckily, a smart fellow by the name of George Theall created [update-nessusrc][2]. It's a handy perl script that will take a basic .nessusrc file and do things with it based on the options you pass it. As I said before, I want every test enabled, so here's the steps I performed:

First, I ran a batch scan to make a basic .nessurc file:

```
# nessus -xqV -T txt localhost 1241 username password targets.txt results.txt
```

The **x** skips the SSL certificate warning, **q** enables batch mode, **V** prints verbose status messages to the screen and **-T txt** makes the report come out in a text format.

Once it started, I pressed CTRL-C to stop it, and then I had a .nessusrc file ready to go. I [downloaded update-nessusrc][2] and ran it to enable all plugins:

```
# ./update-nessusrc-2.37 -ds -c "_all_" .nessusrc
```

The **d** enables debug mode (and saves the new .nessusrc to a new file name), the **s** prints a summary, and **-c "\_all\_"** tells the script to enable all plugin categories. You now have a .nessurc file for use with batch scans that will utilize all of the available plugins.

If you're lazy, you can [download my pre-made .nessusrc][3] that I made today with Nessus 3.2.1.

 [1]: http://nessus.org
 [2]: http://www.tifaware.com/perl/update-nessusrc/
 [3]: /wp-content/nessusrc.txt