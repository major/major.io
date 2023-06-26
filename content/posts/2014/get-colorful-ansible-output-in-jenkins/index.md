---
aliases:
- /2014/06/25/get-colorful-ansible-output-in-jenkins/
author: Major Hayden
date: 2014-06-25 21:32:18
tags:
- ansible
- jenkins
- sudo
title: Get colorful ansible output in Jenkins
---

Working with ansible is enjoyable, but it's a little bland when you use it with Jenkins. Jenkins doesn't spawn a TTY and that causes ansible to skip over the code that outputs status lines with colors. The fix is relatively straightforward.

First, install the [AnsiColor Plugin][1] on your Jenkins node.

Once that's done, edit your Jenkins job so that you export _ANSIBLE\_FORCE\_COLOR=true_ before running ansible:

```
export ANSIBLE_FORCE_COLOR=true
ansible-playbook -i hosts site.yml
```


If your ansible playbook requires sudo to run properly on your local host, be sure to use the _-E_ option with sudo so that your environment variables are preserved when your job runs. For example:

```
export ANSIBLE_FORCE_COLOR=true
sudo -E ansible-playbook -i hosts site.yml
```


**HOLD UP:** As [Sam Sharpe][2] reminded me, the better way to handle environment variables with sudo is to add them to _env_keep_ in your sudoers file (use `visudo` to edit it):

```
Defaults        env_reset
Defaults        env_keep += "ANSIBLE_FORCE_COLOR"
```


Adding it to _env_keep_ is a more secure method and you won't need the _-E_ any longer on the command line.

While you're on the configuration page for your Jenkins job, look for _Color ANSI Console Output_ under the _Build Environment_ section. Enable it and ensure _xterm_ is selected in the drop-down box.

Save your new configuration and run your job again. You should have some awesome colors in your console output when your ansible job runs.

 [1]: https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin
 [2]: http://twitter.com/SamJSharpe/status/481921454263787520