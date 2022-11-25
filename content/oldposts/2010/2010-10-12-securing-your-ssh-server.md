---
title: Securing your ssh server
author: Major Hayden
date: 2010-10-12T22:39:15+00:00
url: /2010/10/12/securing-your-ssh-server/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806250
tags:
  - advice
  - command line
  - firewall
  - iptables
  - linux
  - network
  - security
  - ssh
  - sysadmin

---
One of the most common questions that I see in [my favorite IRC channel][1] is: &#8220;How can I secure sshd on my server?&#8221; There's no single right answer, but most systems administrators combine multiple techniques to provide as much security as possible with the least inconvenience to the end user.

Here are my favorite techniques listed from most effective to least effective:

**SSH key pairs**

By disabling password-based authentication and requiring ssh key pairs, you reduce the chances of compromise via a brute force attack. This can also help you protect against weak account passwords since a valid private key is required to gain access to the server. However, a weak account password is still a big problem if you allow your users to use sudo.

If you're new to using ssh keys, there are [many][2] [great][3] [guides][4] that can walk you through the process.

**Firewall**

Limiting the source IP addresses that can access your server on port 22 is simple and effective. However, if you travel on vacation often or your home IP address changes frequently, this may not be a convenient way to limit access. Acquiring a server with trusted access through your firewall would make this method easier to use, but you'd need to [consider the security of that server as well][5].

The iptables rules would look something like this:

```
iptables -A INPUT -j ACCEPT -p tcp --dport 22 -s 10.0.0.20
iptables -A INPUT -j ACCEPT -p tcp --dport 22 -s 10.0.0.25
iptables -A INPUT -j DROP -p tcp --dport 22
```

**Use a non-standard port**

I'm not a big fan of [security through obscurity][6] and it doesn't work well for ssh. If someone is simply scanning a subnet to find ssh daemons, you might not be seen the first time. However, if someone is targeting you specifically, changing the ssh port doesn't help at all. They'll find your ssh banner quickly and begin their attack.

If you prefer this method, simply adjust the `Port` configuration parameter in your sshd_config file.

**Limit users and groups**

If you have only certain users and groups who need ssh access to your server, setting user or group limits can help increase security. Consider a server which needs ssh access for developers and a manager. Adding this to to your sshd_config would allow only those users and groups to access your ssh daemon:

```
AllowGroups developers
AllowUsers jsmith pjohnson asamuels
```

Keep in mind that any users or groups not included in the sshd_config won't be able to access your ssh server.

**TCP wrappers**

While [TCP wrappers][7] are tried and true, I consider them to be a bit old-fashioned. I've found that many new systems administrators may not think of TCP wrappers when they diagnose server issues and this could possibly cause delays when adjustments need to be made later.

If you're ready to use TCP wrappers to limit ssh connections, check out [Red Hat's extensive documentation][8].

**fail2ban and denyhosts**

For those systems administrators who want to take a bit more active stance on blocking brute force attacks, there's always [fail2ban][9] or [denyhosts][10]. Both fail2ban and denyhosts monitor your authentication logs for repeated failures, but denyhosts can only work with your ssh daemon. You can use fail2ban with other applications like web servers and FTP servers.

The only downside of using these applications is that if a valid user accidentally tries to authenticate unsuccessfully multiple times, they may be locked out for a period of time. This could be a big problem if you're in the middle of a server emergency.

A quick search on Google will give you instructions on [fail2ban configuration][11] as well as [denyhosts configuration][12].

**Port knocking**

Although [port knocking][13] is another tried and true method to prevent unauthorized access, it can be annoying to use unless you have users who are willing to jump through additional hoops. Port knocking involves a &#8220;knock&#8221; on an arbitrary port that then allows the ssh daemon to be exposed to the user who sent the original knock.

[Linux Journal][14] has a great article explaining how port knocking works and it provides some sample configurations as well.

**Conclusion**

The best way to secure your ssh daemon is to apply more than one of these methods to your servers. Weighing security versus convenience of access isn't an easy task and it will be different for every environment. Regardless of the method or methods you choose, ensure that the rest of your team is comfortable with the changes and capable of adapting to them efficiently.

 [1]: irc://irc.freenode.net/slicehost
 [2]: http://sial.org/howto/openssh/publickey-auth/
 [3]: http://www.debian-administration.org/articles/530
 [4]: http://www.linuxquestions.org/linux/answers/Networking/Public_key_authentication_with_ssh
 [5]: http://en.wikipedia.org/wiki/Recursion
 [6]: http://en.wikipedia.org/wiki/Security_through_obscurity
 [7]: http://en.wikipedia.org/wiki/TCP_Wrapper
 [8]: http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Deployment_Guide/s1-tcpwrappers-access.html
 [9]: http://en.wikipedia.org/wiki/Fail2ban
 [10]: http://en.wikipedia.org/wiki/DenyHosts
 [11]: http://www.fail2ban.org/wiki/index.php/HOWTOs
 [12]: http://denyhosts.sourceforge.net/faq.html#2_0
 [13]: http://en.wikipedia.org/wiki/Port_knocking
 [14]: http://www.linuxjournal.com/article/6811
