---
title: 'Getting online with a CradlePoint PHS-300 and an AT&T USBConnect Mercury'
author: Major Hayden
date: 2011-12-16T07:07:08+00:00
url: /2011/12/16/getting-online-with-a-cradlepoint-phs-300-and-an-att-usbconnect-mercury/
featured_image: /wp-content/uploads/2011/12/phs300.jpg
dsq_thread_id:
  - 3642806733
tags:
  - linux
  - mac
  - network
  - wireless

---
Anyone who has used a 3G ExpressCard or USB stick knows how handy they can be when you need internet access away from home (and away from Wi-Fi). I've run into some situations recently where I needed to share my 3G connection with more than one device without using internet sharing on my MacBook Pro.

![1]

That led me to pick up a CradlePoint PHS-300 (discontinued by the manufacturer, but available from [Amazon][2] for about $35). It's compatible with my AT&T USBConnect Mercury (a.k.a. Sierra Wireless Compass 885/885U) USB stick.

Configuring the PHS-300 was extremely easy since I could just associate with the wireless network and enter the password printed on the bottom of the unit. However, getting the 3G stick to work was an immense pain. If you're trying to pair up these products, these steps should help:

* Access the PHS-300's web interface
* Click the **Modem** tab
* Click **Settings** on the left
* Click **Always on** under **Reconnect Mode**
* Uncheck **Aggressive Modem Reset**
* Put the following into the **AT Dial Script** text box:

```
ATE0V1&F&D2&C1S0=0
ATDT*99***1#
```

* Add `ISP.CINGULAR` to the **Access Point Name (APN)** box
* Flip the **Connect Mode** under **Dual WiMAX/3G Settings** to **3G Only**
* Scroll up and push **Save Settings** and then **Reboot Now**

Once the PHS-300 reboots, the USB stick may light up, then turn off, and the display on the PHS-300 might show a red light for the 3G card. Wait about 10-15 seconds for the light to turn green. The lights on the 3G stick should be glowing and blinking as well.

**So how did I figure this out?**

After scouring Google search results, Sierra Wireless FAQ's, CradlePoint's support pages, and trolling through minicom (yes, minicom), I thought I'd try connecting with my MacBook Pro using the 3G Watcher application provided by Sierra Wireless. Before connecting, I opened up Console.app and watched the `ppp.log` file. Sure enough, two lines popped up that were quite relevant to my interests:

```
Fri Dec 16 00:37:51 2011 : Initializing phone: ATE0V1&F&D2&C1S0=0
Fri Dec 16 00:37:51 2011 : Dialing: ATDT*99***1#
```

I didn't have the exact initialization string in the PHS-300 and that was the cause of the failure the entire time.

If you'd like to talk to your USBConnect Mercury stick with minicom, just install minicom from macports (`sudo port -v install minicom`) and start it up like so:

```
sudo minicom -D /dev/cu.sierra04
```

For other Sierra Wireless cards and adapters, there's a [helpful page][3] on Sierra Wireless' site for Eee PC users.

 [1]: /wp-content/uploads/2011/12/phs300.jpg
 [2]: http://www.amazon.com/CradlePoint-PHS300-Personal-Hotspot-Wireless/dp/B001212ELY
 [3]: http://mycusthelp.net/SIERRAWIRELESS/_cs/AnswerDetail.aspx?aid=7
