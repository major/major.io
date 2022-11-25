---
title: Lighttpd proxy to Tomcat
author: Major Hayden
date: 2007-04-06T04:41:05+00:00
url: /2007/04/05/lighttpd-proxy-to-tomcat/
dsq_thread_id:
  - 3642766399
tags:
  - web

---
It seems like lighttpd and Tomcat are at the forefront of what is &#8216;hot' these days. If you don't need the completeness of Apache on your server, you can use lighttpd to proxy to Tomcat, and it's pretty simple. This how-to will show you how to install lighttpd, Tomcat, and the Java JRE. Once they're installed it will also show you how to get lighttpd to use mod_proxy to connect to your Tomcat installation.

First, some downloading has to be done. Grab the latest lighttpd RPM from rpmfind.net for your distribution. You will also need to pick up the latest version of [Tomcat][1] and the [Java JRE][2].

Once all three of those are on the server, get them installed:

<pre lang="html"># rpm -Uvh lighttpd-1.3.16-1.2.el4.rf.i386.rpm
# tar xvzf apache-tomcat-6.0.10.tar.gz
# mv apache-tomcat-6.0.10 /usr/local/
# chmod +x jre-6u1-linux-i586.bin
# ./jre-6u1-linux-i586.bin
# mv jre1.6.0_01 /usr/local/</pre>

Before you can do much else, you will need to set up your JAVA\_HOME and add JAVA\_HOME/bin to your path. Open up /etc/profile and add the following before the `export` statement:

<pre lang="html">JAVA_HOME="/usr/local/jre1.6.0_01/"
export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH</pre>

To make this change actually take effect, you will need to log out and become root again. Now, check that your JAVA_HOME is set:

<pre lang="html"># echo $JAVA_HOME
/usr/local/jre1.6.0_01/</pre>

If the JAVA\_HOME is not set up, check your /etc/profile again. If it's set up, try starting Tomcat &#8211; there's no need to set the $CATALINA\_HOME, because Tomcat can figure it out on its own:

<pre lang="html"># /usr/local/apache-tomcat-6.0.10/bin/startup.sh
Using CATALINA_BASE:   /usr/local/apache-tomcat-6.0.10
Using CATALINA_HOME:   /usr/local/apache-tomcat-6.0.10
Using CATALINA_TMPDIR: /usr/local/apache-tomcat-6.0.10/temp
Using JRE_HOME:       /usr/local/jre1.6.0_01/</pre>

Try to connect to the server now on port 8080 and you should see a Tomcat default page. Now, go add a manager user to the $CATALINA_HOME/conf/tomcat-users.xml:

<pre lang="html">&lt;role rolename="manager"/>
&lt;user username="tomcat" password="password" roles="manager"/></pre>

Restart Tomcat for the changes to take effect:

<pre lang="html"># /usr/local/apache-tomcat-6.0.10/bin/startup.sh
# /usr/local/apache-tomcat-6.0.10/bin/shutdown.sh</pre>

Tomcat is ready to go, so it's time to configure lighttpd. Open the /etc/lighttpd/lighttpd.conf and activate mod_proxy by uncommenting it:

<pre lang="html">server.modules              = (
#                               "mod_rewrite",
#                               "mod_redirect",
#                               "mod_alias",
                                "mod_access",
#                               "mod_cml",
#                               "mod_trigger_b4_dl",
#                               "mod_auth",
#                               "mod_status",
#                               "mod_setenv",
#                               "mod_fastcgi",
                                "mod_proxy",
#                               "mod_simple_vhost",
#                               "mod_evhost",
#                               "mod_userdir",
#                               "mod_cgi",
#                               "mod_compress",
#                               "mod_ssi",
#                               "mod_usertrack",
#                               "mod_expire",
#                               "mod_secdownload",
#                               "mod_rrdtool",
                                "mod_accesslog" )</pre>

Drop to the bottom of the configuration file and add something like this, replacing your information as necessary:

<pre lang="html">$HTTP["host"] =~ "10.10.10.56" {
        proxy.server = (
                "" => (
                        "tomcat" => (
                                "host" => "127.0.0.1",
                                "port" => 8080,
                                "fix-redirects" => 1
                        )
                )
        )
}</pre>

Replace the IP address with a hostname or the correct IP for your server. This proxy directive makes lighttpd connect to Tomcat on the localhost on port 8080 whenever a request comes in on port 80 to lighttpd on the IP 10.10.10.56. Start lighttpd now and try it yourself!

<pre lang="html"># /etc/init.d/lighttpd start</pre>

 [1]: http://tomcat.apache.org/
 [2]: http://java.sun.com/j2se
