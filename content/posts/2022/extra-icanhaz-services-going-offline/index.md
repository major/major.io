---
author: Major Hayden
date: '2022-07-28'
summary: >-
  The original icanhazip.com lives on, but the other services are going offline. 😢
tags:
  - icanhazip
  - linux
  - python
title: Extra icanhazip services going offline
showtableofcontents: false
---

{{< figure 
    src="cover.jpg" 
    alt="Dark stairway going up" 
    caption="Photo credit: [Atanas Teodosiev](https://unsplash.com/photos/EzoGykQmUYI)"
    >}}

Every great thing has its end, and the extra services I launched along with [icanhazip.com] are no exception.
I started [icanhazip.com] way back in 2009 and detailed much of the history when I [transferred ownership to Cloudflare].

The [extra services], such as `icanhazptr.com`, `icanhaztrace.com`, and `icanhaztraceroute.com`, came online in 2013 and they weren't part of the Cloudflare transfer.
These services add extra challenges since they need IPv6 connectivity and they don't play well with containers.
Relative to icanhazip.com, these services receive very little traffic.

As much as I'd like to keep running these sites, **the extra services will go offline on August 17, 2022**.

## And if you can't live without it

Still need PTR record lookups and traceroutes on your network?
All of the code is on GitHub in [major/icanhaz].
To run it, simply execute the `icanhaz.py` script on your machine.

You can also use [gunicorn] with a command like this one:

```bash
gunicorn icanhaz:app
```

You can also get very fancy with a systemd unit that exposes a UNIX socket:

```ini
[Unit]
Description=Gunicorn instance to serve icanhaz
After=network.target

[Service]
User=nginx
Group=nginx
WorkingDirectory=/opt/icanhaz
ExecStart=/usr/bin/gunicorn --workers 4 --bind unix:icanhaz.sock -m 007 icanhaz:app

[Install]
WantedBy=multi-user.target
```

And then configure [nginx] to serve traffic from the socket:

```nginx
server {
	listen       80;
	listen       [::]:80;
	server_name  _;
	root         /usr/share/nginx/html;


	location / {
		proxy_set_header Host $http_host;
		proxy_pass http://unix:/opt/icanhaz/icanhaz.sock;
	}
}
```

Thanks for all the support over the last 13 years! 🫂

[transferred ownership to Cloudflare]: /2021/06/06/a-new-future-for-icanhazip/
[extra services]: /2013/03/16/new-icanhaz-features-reverse-dns-and-traceroutes/
[icanhazip.com]: icanhazip.com
[major/icanhaz]: https://github.com/major/icanhaz
[gunicorn]: https://gunicorn.org/
[nginx]: https://www.nginx.com/
