---
aktt_notify_twitter:
- false
aliases:
- /2008/11/05/viewing-documentation-for-your-ruby-gems/
author: Major Hayden
date: 2008-11-06 00:14:57
dsq_thread_id:
- 3642805362
tags:
- ruby
title: Viewing documentation for your ruby gems
---

I stumbled into this four line ruby script that will serve up all of the rdoc documentation for your server's currently installed gems:

```
#!/usr/bin/env ruby
require "rubygems/server"
options = {:gemdir => Gem.dir, :port => 4242, :daemon => true}
Gem::Server::run(options)
```


_Thanks to Daniel for the ruby code!_