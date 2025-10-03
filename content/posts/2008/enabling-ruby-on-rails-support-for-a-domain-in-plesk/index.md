---
aliases:
- /2008/08/11/enabling-ruby-on-rails-support-for-a-domain-in-plesk/
author: Major Hayden
date: 2008-08-12 01:16:18
tags:
- mod_rewrite
- plesk
- ruby
title: Enabling Ruby on Rails support for a domain in Plesk
---

If you have Plesk 8.1 or later, you have support available for Ruby on Rails. Unfortunately, clicking the FastCGI checkbox in Plesk won't get you all of the support you need (and expect). The folks over at Parallels created a [relatively simple process][1] to get Ruby on Rails working properly on your site:

Go to your domain that you want to adjust, and click **Setup**. Make sure the **CGI** and **FastCGI** options are enabled. Pick a name for your application and make the directory for your application in the **httpdocs** directory. Upload your files to that directory.

Once you've done that, create an **.htaccess** file in the **httpdocs** directory with the following text inside:

```apache
RewriteEngine On
RewriteRule ^$ /public/index.html [L]
RewriteCond % !^/railsapp/public
RewriteRule ^(.*)$ /public/$1 [L]
RewriteCond % !-f
RewriteRule ^(.*)$ public/dispatch.fcgi/$1 [QSA,L]
```

Remove the **.htaccess** file within the **public** directory of your application and add a file called **dispatch.fcgi** to that directory which contains:

```
#!/usr/bin/ruby
```

You should be able to access your application at http://domain.com/railsapp/.

 [1]: http://kb.parallels.com/en/5489
