---
title: Low priority Plesk backups
author: Major Hayden
date: 2007-09-06T03:27:09+00:00
url: /2007/09/05/low-priority-plesk-backups/
dsq_thread_id:
  - 3642769978
tags:
  - command line
  - plesk

---
I hear a lot of complaints about Plesk's backup routines and how they can bring a server to its knees. You can reduce the load (except for mysqldumps) by renicing pleskbackup. If you want something really handy, use this Perl scriptlet that I wrote:

```
#!/usr/bin/perl
@domains = `ls /var/www/vhosts/ | egrep -v '^default\$|^chroot\$'`;
$today = `date +%m%d%y`;
foreach $domain (@domains) {
	chomp($domain);
	$cmd = "nice -n 19 /usr/local/psa/bin/pleskbackup -vv domains $domain --skip-logs - | ssh someuser\@somehost -i /home/username/.ssh/id_rsa \"dd of=/home/username/pleskbackups/$domain-$today.dump\"";
	`$cmd`;
}
```

It will transmit your backups to another server via SSH, and it will reduce the priority to the lowest available. This combination will reduce CPU usage and disk I/O throughout the backup.
