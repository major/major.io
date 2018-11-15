---
title: Create a local PyPi repository using only mod_rewrite
author: Major Hayden
type: post
date: 2012-02-01T04:02:49+00:00
url: /2012/01/31/create-a-local-pypi-repository-using-only-mod_rewrite/
dsq_thread_id:
  - 3642806824
categories:
  - Blog Posts
tags:
  - apache
  - command line
  - mod_rewrite
  - python
  - sysadmin

---
Regular users of Python's package tools like [pip][1] or [easy_install][2] are probably familiar with the [PyPi][3] repository. It's a one-stop-shop to learn more about available Python packages and get them installed on your server.

However, certain folks may find the need to host a local PyPi repository for their own packages. You may need it to store Python code which you don't plan to release publicly or you may need to add proprietary patches to upstream Python packages. Regardless of the reason to have it, a local PyPi repository is relatively easy to configure.

You'll need to start with a base directory for your PyPi repository. For this example, I chose `/var/pypi`. The directory structure should look something like this:

```
/var/pypi/simple/[package_name]/[package_tarball]
```

For a package like `pip`, you'd make a structure like this:

```
/var/pypi/simple/pip/pip-1.0.2.tar.gz
```

Once you have at least one package stored locally, it's time to configure apache. Here's a snippet from the virtual host I configured:

```
DocumentRoot /var/pypi/
ServerName pypi.example.com

Options +Indexes

RewriteEngine On
RewriteRule ^/robots.txt - [L]
RewriteRule ^/icons/.* - [L]
RewriteRule ^/index\..* - [L]

RewriteCond /var/pypi/$1 !-f
RewriteCond /var/pypi/$1 !-d
RewriteRule ^/(.*)/?$ http://pypi.python.org/$1 [R,L]
```

The last set of rewrite directives check to see if the request refers to an existing file or directory under your document root. If it does, your server will reply with a directory listing or with the actual file to download. If the directory or file doesn't exist, apache will send the client a redirection to the main PyPi site.

Reload your apache configuration to bring in your new changes. Let's try to download the `pip` tarball from our local server in the example I mentioned above:

```
$ curl -I http://pypi.example.com/simple/pip/
HTTP/1.1 200 OK

$ curl -I http://pypi.example.com/simple/pip/pip-1.0.2.tar.gz
HTTP/1.1 200 OK
```

I've obviously snipped a bit of the response above, but you can see that apache is responding with 200's since it has the directories and files that I was trying to retrieve via curl. Let's try to get something we don't have locally, like `kombu`:

```
$ curl -I http://pypi.example.com/simple/kombu/
HTTP/1.1 302 Found
Location: http://pypi.python.org/simple/kombu/
```

Our local PyPi repository doesn't have `kombu` so it will refer our Python tools over to the official PyPi repository to get the listing of available package versions for `kombu`.

Now we need to tell `pip` to use our local repository. Edit `~/.pip/pip.conf` and add:

```ini
[global]
index-url = http://pypi.example.com/simple/
```

If you'd rather use `easy_install`, edit `~/.pydistutils.cfg` and add:

```ini
[easy_install]
index_url = http://pypi.example.com/simple/
```

Once your tools are configured, try installing a package you have locally and try to install one that you know you won't have locally. You can add `-v` to `pip install` to watch it retrieve different URL's to get the packages it needs. If you spot any peculiar behavior or unexpected redirections, double-check your mod_rewrite rules in your apache configuration and check the spelling of your directories under your document root.

 [1]: http://pypi.python.org/pypi/pip
 [2]: http://pypi.python.org/pypi/setuptools
 [3]: http://pypi.python.org/pypi
