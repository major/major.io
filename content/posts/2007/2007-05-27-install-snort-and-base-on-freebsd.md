---
title: Install snort and BASE on FreeBSD
author: Major Hayden
date: 2007-05-27T22:23:17+00:00
url: /2007/05/27/install-snort-and-base-on-freebsd/
dsq_thread_id:
  - 3642767609
tags:
  - command line
  - security
  - web

---
Installing snort from ports on FreeBSD is pretty straightforward, but there are some 'gotchas' that you need to be aware of. Here's a step by step:

Compile snort form the ports tree:

```
# portinstall snort
-- OR --
# make -C /usr/ports/security/snort install all
```

You will be asked about which support you want to add to snort, so be sure to choose MySQL (unless you're not going to use MySQL). When the build is complete, you'll need oinkmaster as well to update your snort rules:

```
# portinstall oinkmaster
-- OR --
# make -C /usr/ports/security/oinkmaster install all
```

Oinkmaster needs a snort download code/hash to be able to get your rules for you. Go to <http://snort.org> and register for an account. You'll be given a hash (looks SHA-1-ish) at the bottom of your main account page. Copy /usr/local/etc/oinkmaster.conf.sample to /usr/local/etc/oinkmaster.conf:

```
# cp /usr/local/etc/oinkmaster.conf.sample /usr/local/etc/oinkmaster.conf
```

Replace **<oinkcode>** with the hash you received from snort.org in /usr/local/etc/oinkmaster.conf and uncomment the line:

```
# Example for Snort-current ("current" means cvs snapshots).
url = http://www.snort.org/pub-bin/oinkmaster.cgi/<oinkcode>/snortrules-snapshot-CURRENT.tar.gz
```

Now that oinkmaster is set up, you can update your snort rules using this command:

```
# oinkmaster -o /usr/local/etc/snort/rules/
Loading /usr/local/etc/oinkmaster.conf
Downloading file from http://www.snort.org/pub-bin/oinkmaster.cgi/*oinkcode*/snortrules-snapshot-CURRENT.tar.gz... done.
Archive successfully downloaded, unpacking... done.
Setting up rules structures... done.
Processing downloaded rules... disabled 0, enabled 0, modified 0, total=9942
Setting up rules structures... done.
Comparing new files to the old ones... done.
Updating local rules files... done.
```

Create the snort database and user:

```
# mysql -u root -ppassword
mysql> CREATE DATABASE `snort`;
mysql> GRANT ALL PRIVILEGES ON snort.* TO 'snort'@'localhost' IDENTIFIED BY 'snortpassword';`
```

There's a script that is pre-packaged with snort to set up the tables for you:

```
# mysql -u snort -psnortpassword snort < /usr/local/share/examples/snort/create_mysql
```

Now it's time to make changes in the snort.conf:

```
# nano -w /usr/local/etc/snort/snort.conf
```

Uncomment and configure these lines:

```
# config detection: search-method lowmem
# output alert_syslog: LOG_AUTH LOG_ALERT
# output database: log, mysql, user=root password=test dbname=db host=localhost
```

Uncomment all of the `include $RULE_PATH/*.rules` lines except for this one:

```
# include $RULE_PATH/local.rules [comment this line out]
```

Now, enable snort in the /etc/rc.conf and start it up:

```
# echo "snort_enable=\"YES\"" >> /etc/rc.conf
# /usr/local/etc/rc.d/snort start
Starting snort.
```

If you run `tail /var/log/messages`, you should get some output like this:

```
snort[12558]: Initializing daemon mode
kernel: fxp0: promiscuous mode enabled
snort[12559]: PID path stat checked out ok, PID path set to /var/run/
snort[12559]: Writing PID "12559" to file "/var/run//snort_fxp0.pid"
snort[12559]: Daemon initialized, signaled parent pid: 12558
snort[12558]: Daemon parent exiting
snort[12559]: Snort initialization completed successfully (pid=12559)
```

If you see an error like this, don't worry, nothing's wrong:

```
snort[12559]: Not Using PCAP_FRAMES
```

To test snort, run a ping against your server from an outside source, and you should see something in your syslog like this:

```
snort[12559]: [1:368:6] ICMP PING BSDtype [Classification: Misc activity] [Priority: 3]: {ICMP} xxx.xxx.xxx.xxx -> xxx.xxx.xxx.xxx
snort[12559]: [1:366:7] ICMP PING *NIX [Classification: Misc activity] [Priority: 3]: {ICMP} xxx.xxx.xxx.xxx -> xxx.xxx.xxx.xxx
snort[12559]: [1:384:5] ICMP PING [Classification: Misc activity] [Priority: 3]: {ICMP} xxx.xxx.xxx.xxx -> xxx.xxx.xxx.xxx
```

Installing BASE is pretty simple. You'll need the adodb port plus the BASE tarball from SourceForge:

```
# portinstall adodb
-- OR --
# make -C /usr/ports/databases/adodb install clean
```

After you expand the tarball, go to your BASE install's URL in a browser. It will ask for the path to adodb, which is /usr/local/share/adodb. Provide the snort database information on the third screen and then just finish out the wizard. You will then be all set!
