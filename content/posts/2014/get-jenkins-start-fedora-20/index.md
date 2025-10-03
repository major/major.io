---
aliases:
- /2014/08/13/get-jenkins-start-fedora-20/
author: Major Hayden
date: 2014-08-13 14:39:52
tags:
- fedora
- java
- jenkins
- red hat
- yum
title: Start Jenkins on Fedora 20
---

Installing Jenkins on Fedora 20 is quite easy thanks to the [available Red Hat packages][1], but I ran into problems when I tried to start Jenkins. Here are the installation steps I followed:

```
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum -y install jenkins
systemctl enable jenkins
systemctl start jenkins
```


Your first error will show up if Java isn't installed. You can fix that by installing Java:

```
yum -y install java-1.7.0-openjdk-headless
```


After installing Java, Jenkins still refused to start. Nothing showed up in the command line or via `journalctl -xn`, so I jumped into the Jenkins log file (found at `/var/log/jenkins/jenkins.log`):

```
Aug 13, 2014 2:21:44 PM org.eclipse.jetty.util.log.JavaUtilLog info
INFO: jetty-8.y.z-SNAPSHOT
Aug 13, 2014 2:21:46 PM org.eclipse.jetty.util.log.JavaUtilLog info
INFO: NO JSP Support for , did not find org.apache.jasper.servlet.JspServlet
```


My Java knowledge is relatively limited, so I tossed the JSP error message into Google. A [stackoverflow][2] thread was the first result and it talked about a possible misconfiguration with Jetty. I tried their trick of using the OPTIONS environment variable, but that didn't work.

Then I realized that there wasn't a Jetty package installed on my server. Ouch. The installation continues:

```
yum -y install jetty-jsp
```


Jenkins could now get off the ground and I saw the familiar log messages that I'm more accustomed to seeing:

```
Aug 13, 2014 2:24:26 PM hudson.WebAppMain$3 run
INFO: Jenkins is fully up and running
```


Much of these problems could stem from the fact that Jenkins RPM's are built to suit a wide array of system versions and the dependencies aren't configured correctly. My hope is that the [Jenkins project for Fedora 21][3] will alleviate some of these problems and give the user a better experience.

 [1]: http://pkg.jenkins-ci.org/redhat/
 [2]: https://stackoverflow.com/questions/3521654/missing-jsp-support-in-jetty-or-confusing-log-message
 [3]: https://fedoraproject.org/wiki/Changes/Jenkins