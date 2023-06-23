---
aliases:
- /2012/02/05/the-kerberos-haters-guide-to-installing-kerberos/
author: Major Hayden
date: 2012-02-05 21:03:52
dsq_thread_id:
- 3642806833
tags:
- centos
- command line
- fedora
- kerberos
- networking
- nis
- rackspace
- red hat
- rhca
- security
- ssh
- sysadmin
title: The Kerberos-hater’s guide to installing Kerberos
---

![1]

As promised in my earlier post entitled [Kerberos for haters][2], I've assembled the simplest possible guide to get Kerberos up an running on two CentOS 5 servers.

Also, I don't really _hate_ Kerberos. It's a bit of an inside joke with my coworkers who are studying for some of the [RHCA][3] exams at Rackspace. The additional security provided by Kerberos is quite good but the setup involves a lot of small steps. If you miss one of the steps or if you get something done out of order, you may have to scrap the whole setup and start over unless you can make sense of the errors in the log files. A lot of my dislikes for Kerberos comes from the number of steps required in the setup process and the difficulty in tracking down issues when they crop up.

To complete this guide, you'll need the following:

  * two CentOS, Red Hat Enterprise Linux or Scientific Linux 5 servers or VM's
  * some patience

Here's how I plan to name my servers:

  * **kdc.example.com** &#8211; the Kerberos KDC server at 192.168.250.2
  * **client.example.com** &#8211; the Kerberos client at 192.168.250.3

**CRITICAL STEP:** Before getting started, ensure that both systems have their hostnames properly set and both systems have the hostnames and IP addresses of both systems in `/etc/hosts`. Your server and client must be able to know the IP and hostname of the other system as well as themselves.

First off, we will need [NIS][4] working to serve up the user information for our client. Install the NIS server components on the KDC server:

<pre lang="html">[root@kdc ~]# yum install ypserv
</pre>

Set the NIS domain and set a static port for `ypserv` to make it easier to firewall off. Edit `/etc/sysconfig/network` on the KDC server:

<pre lang="html">NISDOMAINNAME=EXAMPLE.COM
YPSERV_ARGS="-p 808"
</pre>

Manually set the NIS domain on the KDC server and add it to `/etc/yp.conf`:

<pre lang="html">[root@kdc ~]# nisdomain EXAMPLE.COM
[root@kdc ~]# echo "domain EXAMPLE.COM server kdc.example.com" >> /etc/yp.conf
</pre>

Adjust `/var/yp/securenets` on the KDC server for additional security:

<pre lang="html">[root@kdc ~]# echo "255.0.0.0 127.0.0.0" >> /var/yp/securenets
[root@kdc ~]# echo "255.255.255.0 192.168.250.0" >> /var/yp/securenets
</pre>

Start the NIS server and generate the NIS maps:

<pre lang="html">[root@kdc ~]# /etc/init.d/ypserv start; chkconfig ypserv on
[root@kdc ~]# make -C /var/yp
</pre>

I usually like to prepare my iptables rules ahead of time so I ensure that it doesn't derail me later on. Paste this into the KDC's terminal:

<pre lang="html">iptables -N SERVICES
iptables -I INPUT -j SERVICES
iptables -A SERVICES -p tcp --dport 111 -j ACCEPT -m comment --comment "rpc"
iptables -A SERVICES -p udp --dport 111 -j ACCEPT -m comment --comment "rpc"
iptables -A SERVICES -p tcp --dport 808 -j ACCEPT -m comment --comment "nis"
iptables -A SERVICES -p udp --dport 808 -j ACCEPT -m comment --comment "nis"
iptables -A SERVICES -p tcp --dport 88 -j ACCEPT -m comment --comment "kerberos"
iptables -A SERVICES -p udp --dport 88 -j ACCEPT -m comment --comment "kerberos"
iptables -A SERVICES -p udp --dport 464 -j ACCEPT -m comment --comment "kerberos"
iptables -A SERVICES -p tcp --dport 749 -j ACCEPT -m comment --comment "kerberos"
/etc/init.d/iptables save
</pre>

We need our time in sync for Kerberos to work properly. Install NTP on both nodes, start it, and ensure it comes up at boot time:

<pre lang="html">[root@kdc ~]# yum -y install ntp && chkconfig ntpd on && /etc/init.d/ntpd start
[root@client ~]# yum -y install ntp && chkconfig ntpd on && /etc/init.d/ntpd start
</pre>

Now we're ready to set up Kerberos. Start by installing some packages on the KDC:

<pre lang="html">[root@kdc ~]# yum install krb5-server krb5-workstation
</pre>

We will need to make some edits to `/etc/krb5.conf` on the KDC to set up our KDC realm. Ensure that the `default_realm` is set:

<pre lang="html">default_realm = EXAMPLE.COM
</pre>

The `[realms]` section should look like this:

<pre lang="html">[realms]
EXAMPLE.COM = {
	kdc = 192.168.250.2:88
	admin_server = 192.168.250.2:749
}
</pre>

The `[domain_realm]` section should look like this:

<pre lang="html">[domain_realm]
kdc.example.com = EXAMPLE.COM
client.example.com = EXAMPLE.COM
</pre>

Add `validate = true` within the `pam { }` block of the `[appdefaults]` section:

<pre lang="html">[appdefaults]
 pam = {
   validate = true
</pre>

Adjust `/var/kerberos/krb5kdc/kdc.conf` on the KDC:

<pre lang="html">[realms]
EXAMPLE.COM = {
	master_key_type = des-hmac-sha1
	default_principal_flags = +preauth
}
</pre>

There's one last configuration file to edit on the KDC! Ensure that `/var/kerberos/krb5kdc/kadm5.acl` looks like this:

<pre lang="html">*/admin@EXAMPLE.COM	    *
</pre>

We're now ready to make a KDC database to hold our sensitive Kerberos data. Create the database and set a good password which you can remember. This command also stashes your password on the KDC so you don't have to enter it each time you start the KDC:

<pre lang="html">kdb5_util create -r EXAMPLE.COM -s
</pre>

On the KDC, create a principal for the admin user as well as user1 (which we'll create shortly). Also, export the admin details to the kadmind key tab. You'll get some extra output after each one of these commands but I've snipped it to reduce the length of the post.

<pre lang="html">[root@kdc ~]# kadmin.local
kadmin.local:  addprinc root/admin
kadmin.local:  addprinc user1
kadmin.local:  ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/admin
kadmin.local:  ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/changepw
kadmin.local:  exit
</pre>

Let's start the Kerberos KDC and kadmin daemons:

<pre lang="html">[root@kdc ~]# /etc/init.d/krb5kdc start; /etc/init.d/kadmin start
[root@kdc ~]# chkconfig krb5kdc on; chkconfig kadmin on
</pre>

Now that the administration work is done, let's create a principal for our KDC server and stick it in it's keytab:

<pre lang="html">[root@kdc ~]# kadmin.local
kadmin.local:  addprinc -randkey host/kdc.example.com
kadmin.local:  ktadd host/kdc.example.com
</pre>

Transfer your `/etc/krb5.conf` from the KDC server to the client. Hop onto the client server, install the Kerberos client package and add some host principals:

<pre lang="html">[root@client ~]# yum install krb5-workstation
[root@client ~]# kadmin.local
kadmin.local:  addpinc --randkey host/client.example.com
kadmin.local:  ktadd host/kdc.example.com
</pre>

There aren't any daemons on the client side, so the configuration is pretty much wrapped up there for Kerberos. However, we now need to tell both servers to use Kerberos for auth and your client servers needs to use NIS to get user data.

  * On the KDC:
      * run `authconfig-tui`
      * choose **Use Kerberos** from the second column
      * press **Next**
      * don't edit the configuration (authconfig got the data from `/etc/krb.conf`)
      * press **OK**
  * On the client:
      * run `authconfig-tui`
      * choose **Use NIS** and **Use Kerberos**
      * press **Next**
      * enter your NIS domain (EXAMPLE.COM) and NIS server (kdc.example.com or 192.168.250.2)
      * press **Next**
      * don't edit the Kerberos configuration (authconfig got the data from `/etc/krb.conf`)
      * press **OK**

**Got NIS problems?** If the NIS connection stalls on the client, ensure that you have the iptables rules present on the KDC that we added near the beginning of this guide. Also, if you forgot to add **both** hosts to **both** servers' `/etc/hosts`, go do that now.

Let's make our test user on the KDC. **Don't add this user to the client** &#8212; we'll get the user information via NIS and authenticate via Kerberos shortly. We'll also rebuild our NIS maps after adding the user:

<pre lang="html">[root@kdc ~]# useradd user1
[root@kdc ~]# passwd user1
[root@kdc ~]# make -C /var/yp/
</pre>

On the client, see if you can get the password hash for the user1 account via NIS:

<pre lang="html">[root@client ~]# ypcat -d EXAMPLE.COM -h kdc.example.com passwd | grep user1
user1:$1$sUlSTlCv$riK5El3z8N4y.mi5Fe3Q60:500:500::/home/user1:/bin/bash
</pre>

You can see why NIS isn't a good way to authenticate users. Someone could easily pull the hash for any account and brute force the hash on their own server. Go back to the KDC and lock out the user account:

<pre>[root@kdc ~]# usermod -p '!!' user1
</pre>

Go back to the client and try to pull the password hash now:

<pre lang="html">[root@client ~]# ypcat -d EXAMPLE.COM -h kdc.example.com passwd | grep user1
user1:!!:500:500::/home/user1:/bin/bash
</pre>

On the plus side, the user's password hash is now gone. On the negative side, you've just prevented this user from logging in locally or via NIS. Don't worry, the user can log in via Kerberos now. Let's prepare a home directory on the client for the user:

<pre lang="html">[root@client ~]# mkdir /home/user1
[root@client ~]# cp -av /etc/skel/.bash* /home/user1/
[root@client ~]# chown -R user1:user1 /home/user1/
</pre>

Note: In a real-world scenario, you'd probably want to export this user's home directory via NFS so they didn't get a different home directory on every server.

While you're still on the client, try to log into the client via the user. Use the password that you used when you created the user1 principal on the KDC.

<pre lang="html">[root@client ~]# ssh user1@localhost
user1@localhost's password:
[user1@client ~]$ whoami
user1
</pre>

List your Kerberos tickets and you should see one for your user principal:

<pre lang="html">[user1@client ~]$ klist
Ticket cache: FILE:/tmp/krb5cc_500_fCKPnZ
Default principal: user1@EXAMPLE.COM

Valid starting     Expires            Service principal
02/05/12 14:18:53  02/06/12 00:18:53  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 02/05/12 14:18:53
</pre>

Your KDC should have a couple of lines in its `/var/log/krb5kdc.log` showing the authentication:

<pre lang="html">Feb 05 14:18:53 kdc.example.com krb5kdc[4694](info): AS_REQ (12 etypes {18 17 16 23 1 3 2 11 10 15 12 13}) 192.168.250.3: ISSUE: authtime 1328473133, etypes {rep=16 tkt=16 ses=16}, user1@EXAMPLE.COM for krbtgt/EXAMPLE.COM@EXAMPLE.COM
Feb 05 14:18:53 kdc.example.com krb5kdc[4694](info): TGS_REQ (7 etypes {18 17 16 23 1 3 2}) 192.168.250.3: ISSUE: authtime 1328473133, etypes {rep=16 tkt=18 ses=18}, user1@EXAMPLE.COM for host/client.example.com@EXAMPLE.COM
</pre>

The first line shows that the client asked for a Authentication Server Request (AS\_REQ) and the second line shows that the client then asked for a Ticket Granting Server Request (TGS\_REQ). In layman's terms, the client first asked for a ticket-granting ticket (TGT) so it could authenticate to other services. When it actually tried to log in via `ssh` it asked for a ticket (and received it).

**YOU JUST CONFIGURED KERBEROS!**

From here, the sky's the limit. Another popular implementation of Kerberos is encrypted NFSv4. You can even go crazy and use [Kerberos with apache][5].

Let me know if you have any questions about this post or if you spot any errors. With this many steps, there's bound to be a typo or two in this guide. Keep in mind that there are some obvious spots for network-level and service-level security improvements. This guide was intended to give you the basics and it doesn't cover all of the security implications involved with a Kerberos implementation.

 [1]: /wp-content/uploads/2012/02/haters_gonna_hate_elephhant.jpg
 [2]: /2012/02/02/kerberos-for-haters/
 [3]: http://www.redhat.com/training/certifications/rhca/
 [4]: http://en.wikipedia.org/wiki/Network_Information_Service
 [5]: http://wiki.centos.org/HowTos/HttpKerberosAuth