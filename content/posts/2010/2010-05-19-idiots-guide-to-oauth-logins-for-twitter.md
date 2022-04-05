---
title: Idiot’s guide to OAuth logins for Twitter
author: Major Hayden
type: post
date: 2010-05-20T01:26:07+00:00
url: /2010/05/19/idiots-guide-to-oauth-logins-for-twitter/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806163
categories:
  - Blog Posts
tags:
  - command line
  - oauth
  - ruby
  - script
  - twitter

---
It certainly shouldn't be difficult, but I always have a tough time with [OAuth][1]. Twitter is [dropping support for basic authentication][2] on [June 30th, 2010][3]. I have some automated Twitter bots that need an upgrade, so I've been working on a quick solution to generate tokens for my scripts.

I formulated a pretty simple script using [John Nunemaker's twitter gem][4] that will get it done manually for any scripts you have that read from or update Twitter:

```
#!/usr/bin/ruby
require 'rubygems'
require 'twitter'

# These credentials are specific to your *application* and not your *user*
# Get these credentials from Twitter directly: http://twitter.com/apps
application_token = '[this should be the shorter one]'
application_secret = '[this should be the longer one]'

oauth = Twitter::OAuth.new(application_token,application_secret)

request_token = oauth.request_token.token
request_secret = oauth.request_token.secret
puts "Request token => #{request_token}"
puts "Request secret => #{request_secret}"
puts "Authentication URL => #{oauth.request_token.authorize_url}"

print "Provide the PIN that Twitter gave you here: "
pin = gets.chomp

oauth.authorize_from_request(request_token,request_secret,pin)
access_token = oauth.access_token.token
access_secret = oauth.access_token.secret
puts "Access token => #{oauth.access_token.token}"
puts "Access secret => #{oauth.access_token.secret}"

oauth.authorize_from_access(access_token, access_secret)
twitter = Twitter::Base.new(oauth)
puts twitter.friends_timeline(:count => 1)
```


When you run the script, it will give you a request token, request secret and a URL to visit. When you access the URL, you'll be given a PIN. Type the PIN into the prompt and you'll get your access token and secret. This is what you can use to continue authenticating with Twitter, so be sure to save the access token and secret.

From then on, you should be able to login with a script like this:

```
#!/usr/bin/ruby
require 'rubygems'
require 'twitter'

application_token = '[this should be the shorter one]'
application_secret = '[this should be the longer one]'

oauth = Twitter::OAuth.new(application_token,application_secret)

oauth.authorize_from_access(access_token, access_secret)
twitter = Twitter::Base.new(oauth)
puts twitter.friends_timeline(:count => 1)
```


I hope this helps!

 [1]: http://en.wikipedia.org/wiki/OAuth
 [2]: http://apiwiki.twitter.com/OAuth-FAQ#WhenareyougoingtoturnoffBasicAuth
 [3]: http://countdowntooauth.com/
 [4]: http://twitter.rubyforge.org/
