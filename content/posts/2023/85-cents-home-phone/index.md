---
author: Major Hayden
date: '2023-04-18'
summary: |
  After trying several services for home phones, I found a solution that costs me about $0.85 per month. ️️☎️
tags:
  - android
  - phone
  - voip
title: My home phone costs 85 cents a month
---

I [aired my grievances](https://tootchute.com/@major/110196965372403816) about Ooma's
phone service recently on my [Mastodon account](https://tootchute.com/@major). They
require you to call them to cancel and then their convoluted cancellation process spins
you in circles. Luckily I had a prepaid credit card with a dollar or two left on it and
I used that as my primary billing card. Problem solved. 👏

Later in the Mastodon thread, I mentioned how my replacement solution costs 85 cents a
month and someone asked me how I do it. It's not the easiest process. However, once you
get it working, it doesn't require much upkeep.

But before we start...

# Who the heck needs a home phone in 2023?

Yes, this is a common question I get. Mobile phones, tablets, and laptops all have so
much communication connectivity now that home phones aren't really relevant.

I like having one around for my kids to use and it's nice to have a backup in case there
are issues with the mobile phone networks. One of my kids has a mobile phone and the
other does not. It also allows my neighbors' kids (who may or may not have phones of
their own) to call their parents at any time.

# 85 cents a month?

We're talking $0.85 USD per month. For real. That price covers a direct inbound dialing
(DID) number in various area codes throughout the USA. Some countries might have
different pricing, but this works in the USA.

You might be wondering if there are additional costs. Well, yes, there are.

Outbound calls are $0.01 per minute and inbound calls are $0.009 per minute. That would
leave you with a bill of about $10.85 for 1,000 minutes _(just under 17 hours of
calls)_.

# What's involved?

When you get a phone call on your mobile phone, this is what happens:

* Someone dials your number from their phone
* ✨ Magic ✨
* Your phone rings and you can pick it up

For this home phone solution, it goes something like this:

* You buy a DID number from a VOIP provider
* You connect a SIP phone, an ATA device, or your phone/computer to a SIP endpoint
* Someone calls your DID number
* **Something** on your end rings and you can answer the call

I say **something** here because it can be anything. An old telephone with a cradle,
wireless DECT phones, fancy SIP phones, or a computer.

[SIP phones](https://en.wikipedia.org/wiki/VoIP_phone) are phones that connect directly
to a network via ethernet or wi-fi. You configure a SIP account on the device itself and
it connects to your VOIP provider, registers itself, and waits for inbound or outbound
calls.

[ATA devices](https://en.wikipedia.org/wiki/Analog_telephone_adapter) are analog
telephone adapters that translate the modern world of VOIP for a regular old phone. This
allows you to take existing cordless phones (or corded phones) and connect them to a
VOIP account. For these devices, you normally access the ATA via a web interface and
configure them.

# SIP phone vs. ATA

I chose ATA devices because they're cheaper to buy, easy to maintain, and you can use
anything with them that has a phone jack. Got Grandma's old red phone with a cradle? It
works. Got a cordless DECT multi-phone system with an answering machine? It works.

As long as it does tone dialing, you're set. _(Let's not bring pulse dialing into this,
please.)_

The challenge with these is that they're not being manufactured that often lately.
Mobile phones have really pushed these devices to the corners of the market. Most VOIP
equipment is aimed at big businesses and these small devices can be hard to find.

My current favorite is the [Grandstream
HT801](https://www.grandstream.com/products/gateways-and-atas/analog-telephone-adaptors/product/ht801).
It supports only phone phone line, so get the
[HT802](https://www.grandstream.com/products/gateways-and-atas/analog-telephone-adaptors/product/ht802)
if you need two lines at home.

The device has a port for power, an ethernet port, and phone line port. That's all you
need. Plug the phone into the phone line port, connect the ethernet port to your router
or switch, and you're set!

# Getting a phone number

My favorite VOIP service is [voip.ms](https://voip.ms). Their prices are reasonable,
their control panel is easy to use, and they have lots of business functions that you
can use for free (such as an IVR, which is a "press 1 for sales" menu system).

After you set up an account on voip.ms and deposit some money, go to **DID Numbers** and
click **Order DID**. You get lots of options of numbers to buy including international
numbers. _(If you have family overseas who would like to call you as a local call from
their phone, this could be a great option!)_

For US numbers, you'll then get a menu asking you to pick a state and then pick numbers.
You can also look for numbers that contain a set of numbers (including the area code).
These are helpful if you want to spell something with your number (young kids have no
idea what fun this used to be) or get something that's easy to remember.

You'll get two options for paying for the number:

* One option is a flat rate all-you-can-eat plan, usually for $3-$10 monthly. This might
  be a good option if you plan to use your home phone a lot.
* Another option will be the $0.85/month option where you pay extra for all calls. This
  is my favorite option.

Complete the remaining steps you'll have your number!

# Create a sub account

The voip.ms system has a concept of "sub-accounts" where you have individual SIP logins
for each device. **This is highly recommended for security reasons.**

Click the **Sub Accounts** menu and then **Create Sub Account**. Set up your password
and choose from the options around allowing international calls and how you want your
calls routed. Most of the defaults are fine here.

The username/password combination is the one you'll use for your ATA later, so be sure
to remember those.

# Connecting the DID and sub account

Go back to the **DID Numbers** menu and click **Manage DIDs**. Find the number you
bought and look for the orange pencil underneath the **Actions** heading. When the page
loads, make a few changes:

1. First, look for the **SIP/IAX** option in the **Main** section. Choose the sub
   account you created earlier from the drop down list. It should be something like
   `SIP/123456_yourusername`. This routes the DID number to the devices connected to
   that sub account.

2. Under the **DID Point of Presence** section, choose a server that is close to you.
   The voip.ms team puts green check marks next to the ones it recommends for your
   location but you can choose any location you wish.

3. Under **CallerID Name Lookup**, you can enable it for $0.008 per lookup. That means
   that 100 inbound calls will cost you about $0.80 for lookups total.

4. You have an option for enabling SMS/MMS for an additional fee, but it's not terribly
   easy to use.

Apply the changes at the bottom of the page. Now you're all set to connect your phones
or ATA device!

# Adding an ATA

voip.ms has a [massive page](https://wiki.voip.ms/article/ATA_Devices) full of
information about nearly every ATA they support. There are configuration instructions in
a link under each device that give you tips on how to best configure your device.

If you picked up an HT801/HT802 like I recommended, you can go straight to the
[HT802](https://wiki.voip.ms/article/Grandstream_HandyTone_802_-_HT802) configuration
guide. The instructions there work just fine for the HT801, too.

Make sure your ATA device is powered on and plugged into your home ethernet network (or
wi-fi if it is so equipped). You can get the IP address for your ATA device by checking
DHCP leases on your router or you can pick up your phone connected to the ATA and press
asterisk/star (*) three times. A friendly computer voice will tell you the IP address of
the ATA device.

**Follow the configuration instructions to the letter!** Some of these settings,
especially for audio codecs, are critical for getting high quality, reliable phone
calls.

It's time to make phone calls once you've configured your device! You should be able to
dial out from your home phone and receive calls on the same number. If you can make
calls but can't receive calls, double check that your sub account shows **Registered**
on the voip.ms [portal home page](https://voip.ms/m/index.php). If it doesn't appear as
**Registered** in green, then voip.ms has no way to tell your device there's a phone
call coming.

Go back and double check your account username and password. Also verify that your ATA
configuration matches *exactly* to the recommended configuration provided by voip.ms.

# Extra credit

Although I get a *very* small number of spam calls and robocalls on my voip.ms DID,
there's a chance your experience might be different.

voip.ms offers quite a few services to help here, especially [CallerID
Filtering](https://voip.ms/m/callerid_filtering.php). You can block anonymous calls or
callers who have their CallerID marked as unavailable.

It's also pretty easy to set up a [Digital Receiptionist
(IVR)](https://voip.ms/m/ivr.php) where you can make callers press a number or jump
through a hoop or two before your phone rings. Once you create your IVR, run back to
**DID Numbers** and then **Manage DIDs** to change your routing settings to use the new
IVR. (Look for **IVR** just under **SIP/IAX** on the DID settings page.)

Before you celebrate, be sure to turn on [automatic
billing](https://voip.ms/m/payment.php)! You can tell voip.ms to fill your account with
some money when it crosses a certain threshold. I have mine set to add $25 each time I
drop under $10. They will send you nag emails as soon as your balance gets low but you
don't want to forget about it.

_Cover photo by [Patrick Ho](https://unsplash.com/photos/8P3Ivyi59aI)_