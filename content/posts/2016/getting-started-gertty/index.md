---
aliases:
- /2016/05/11/getting-started-gertty/
author: Major Hayden
date: 2016-05-11 13:45:53
dsq_thread_id:
- 4817918506
tags:
- development
- fedora
- openstack
- python
- sqlite
title: Getting started with gertty
---

![1]

When you're ready to commit code in an OpenStack project, your patch will eventually land in a [Gerrit][2] queue for review. The web interface works well for most users, but it can be challenging to use when you have a large amount of projects to monitor. I recently became a core developer on the OpenStack-Ansible project and I searched for a better solution to handle lots of active reviews.

This is where [gertty][3] can help. It's a console-based application that helps you navigate reviews efficiently. I'll walk you through the installation and configuration process in the remainder of this post.

## Installing gertty

The gertty package is available via [pip][4], [GitHub][3], and various package managers for certain Linux distributions. If you're on Fedora, just install `python-gertty` via `dnf`.

In this example, we will use pip:

```
pip install gertty
```


## Configuration

You will need a `.gertty.yaml` file in your home directory for gertty to run. I have an [example on GitHub][5] that gives you a good start:



Be sure to change the `username` and `password` parts to match your Gerrit username and password. For OpenStack's gerrit server, you can get these credentials in the [user settings area][6].

## Getting synchronized

Now that gertty is configured, start it up on the console:

```
$ gertty
```


Type a capital L (SHIFT + L) and wait for the list of projects to appear on the screen. You can choose projects to subscribe to (note that these are different than Gerrit's watched projects) by pressing your 's' key.

However, if you need to follow quite a few projects that match a certain pattern, there's an easier way. Quit gertty (CTRL - q) and adjust the sqlite database that gertty uses:

```
$ sqlite3 .gertty.db
SQLite version 3.8.6 2014-08-15 11:46:33
Enter ".help" for usage hints.
sqlite> SELECT count(*) FROM project WHERE name LIKE '%openstack-ansible%';
39
sqlite> UPDATE project SET subscribed=1 WHERE name LIKE '%openstack-ansible%';
sqlite>
```


In this example, I've subscribed to all projects that contain the string `openstack-ansible`.

I can start gertty once more and wait for it to sync my new projects down to my local workstation. Keep an eye on the `Sync:` status at the top right of the screen. It will count up as it enumerates reviews to retrieve and then count down as those reviews are downloaded.

You can also create custom dashboards for gertty based on custom queries. In my example configuration file above, I have a special dashboard that contains all OpenStack-Ansible reviews. That dashboard appears whenever I press F5. You can customize these dashboards to include any custom queries that you need for your projects.

_Photo credit: [Frank Taillandier][7]_

 [1]: /wp-content/uploads/2016/05/2191026054_2780871e26_b-e1462974197375.jpg
 [2]: https://www.gerritcodereview.com/
 [3]: https://github.com/openstack/gertty
 [4]: https://pypi.python.org/pypi/gertty
 [5]: https://gist.github.com/major/6449c2eb3b17a446c3a42e34b976f6df
 [6]: https://review.openstack.org/#/settings/http-password
 [7]: https://www.flickr.com/photos/dirtyf/2191026054