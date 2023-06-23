---
aliases:
- /2018/12/13/getting-started-with-ham-radio-repeaters/
author: Major Hayden
date: '2018-12-13'
summary: 'Repeaters are a great way to get into ham radio, but they can be tricky
  to use for new amateur radio operators. This post explains how to get started.

  '
tags:
- radio
- ham radio
- amateur radio
title: Getting started with ham radio repeaters
---

[Amateur radio] is a fun way to mess around with technology, meet new people,
and communicate off the grid. Talking directly to another radio on a single
frequency (also called *simplex*) is the easiest way to get started. However,
it can be difficult to communicate over longer distances without amplifiers,
proper wiring, and antennas. This is where a radio repeater can help.

## What's in scope

This post is focused on fairly local communication on VHF/UHF bands. The most
common frequencies for local communication in these bands are:

  * 2 meters (~144-148MHz)*
  * 70 centimeters (~420-450MHz)*

*\* NOTE: Always consult the [band plan] for your area to see which part of the
frequency band you could and should use.*

Of course, you can do some amazing things with weak signal VHF (which can be
used to commuinicate over **great** distances), but we're not talking about
that here. The [HAMSter Amateur Radio Group] is a great place to get started
with that.

We're also not talking about radio bands longer than 2 meters (which includes
high frequency (HF) bands). Some of those bands require advanced FCC
licensing that takes additional studying and practice.

## Keeping it simple(x)

[Simplex radio] involves communication where radios are tuned to a single
frequency and only one radio can transmit at a time. This is like a simple
walkie-talkie. If one person is transmitting, everyone else listens. If
someone else tries to transmit at the same time, then the waves will be
garbled and nobody will be able to hear either person. This is often called
"doubling up".

This method works well when radios are in range of each other without a bunch
of objects in between. However, it's difficult to talk via simplex over great
distances or around big obstables, such as mountains or hills.

## Repeaters

[Repeaters] are a little more complex to use, but they provide some great
benefits. A repeater usually consists of one or two radios, one or two
antennas, duplexers, and some other basic equipment. They receive a signel on
one frequency and broadcast that same signal on another frequency. They often
are mounted high on towers and this gives them a much better reach than
antennas on your car or home.

I enjoy using a repeater here in San Antonio called [KE5HBB]. The repeater
has this configuration:

* Downlink: 145.370
* Uplink: 144.770
* Offset: -0.6 MHz
* Uplink Tone: 114.8
* Downlink Tone: 114.8

Let's make sense of this data:

* Downlink: This is the frequency that the repeater uses to *transmit*. In
  other words, when people talk on this repeater, this is the frequency you
  use to hear them.

* Uplink: The receiver *listens* on this frequency. If you want to talk to
  people who are listening to this repeater, you need to transmit on this
  frequency.

* Offset: This tells you how to calculate the uplink frequency if it is not
  shown. This repeater has a negative 0.6 offset, so we can calculate the
  uplink frequency if it was not provided:

```
145.370 - 0.600 = 144.770
```

* Uplink/Downlink Tones: Your radio must transmit this tone to *open the
  squelch* on the repeater (more on this in a moment). The repeater will use
  the same tone to transmit, so we can configure our radio to listen for that
  tone and only open our squelch when it is detected.

## Opening the squelch

Transmitting radio waves uses a lot of power and it creates a lot of heat.
There are parts of a radio that will wear out much more quickly if a radio is
transmitting constantly. This is why receivers have a *squelch*. This means
that a radio must transmit something strong enough on the frequency (or use a
tone) to let the repeater know that it needs to repeat something.

You may come across repeaters with no tones listed (sometimes shown as *PL*).
This means that you can just transmit on the uplin frequency and the repeater
will repeat your signal. These repeaters are easy to use, but they can create
problems.

Imagine if you're traveling through an area and you're using a frequency to
talk to a friend in another car. As you're driving, you move in range of a
repeater that is listening on that frequeny. Suddenly your conversation is
now being broadcasted through the repeater and everyone listening to that
repeater must listen to you. This isn't what you expected and it could be
annoying to other listeners.

Also, in crowded urban areas, there's always a chance that signals might end
up on the repeater's listening frequency unintentionally. That would cause
the repeater to start transmitting and it would increase wear.

Two repeaters might be relatively close (or just out of range) and the tone
helps each repeater identify its own valid radio traffic.

## Tuning the tones

Most repeaters have a *tone squelch*. That means you can blast them with 100
watts of radio waves and they won't repeat a thing until you transmit an
inaudible tone at the beginning of your transmission.

As an example, in the case of KE5HBB, this tone is 114.8. You must configure
a [CTCSS] tone on your radio so that the tone is transmitted as soon as you
begin transmitting. That signals the repeater that it's time to repeat. These
signals aren't audible to humans.

If you know you're tuned to the right frequency to transmit (the uplink
frequency), but the repeater won't repeat your traffic, then you are most
likely missing a tone. There's also a chance that you programmed the uplink
and downlink tones into your radio in reverse, so check that, too.

## Repeater transmit tone

Some receivers will transmit a tone when they broadcast back to you, but some
won't. If you can transmit but you can't hear anyone else when they talk,
double check your radio's settings for a tone squelch on the receiving side.
Your radio can also listen for these tones and only open its squelch when it
hears them.

I usually disable receiver squelch for tones on my radio since the repeater
operator could disable that feature at any time and I wouldn't be able to
hear any transmissions since my radio would be waiting for the tone.

## Testing a repeater

First off, please don't test a repeater unless you have a proper amateur
radio license in your jurisdiction. In the United States, that's the FCC.
Don't skip this step.

Once you get your repeater's frequencies programmed into your radio properly
and you've double checked the settings for sending tones, you can try
"breaking the squelch."

Press the transmit button on your radio briefly for about half second and
release. You should hear something when you do this. For some repeaters, you
may hear a *KERRRCHUNK* noise. That's the sound of the repeater squelch
closing the transmission now that you're done with your transmission. On
other repeaters, you may hear some audible tones or beeps as soon as you
release the transmit button.

Once you have it working properly, stop breakng the squelch and introduce
yourself! For example, when I'm in my car, I might say: *"W5WUT mobile and
monitoring."* That lets people on the repeater know that I'm there and that
I'm moving (so I might not be on for a very long time).

Good luck on the radio waves! 73's from W5WUT.

[Amateur radio]: https://en.wikipedia.org/wiki/Amateur_radio
[band plan]: http://www.arrl.org/band-plan
[HAMSter Amateur Radio Group]: http://www.144200.net/about.html
[Simplex radio]: https://en.wikipedia.org/wiki/Simplex_communication
[Repeaters]: https://en.wikipedia.org/wiki/Repeater
[KE5HBB]: https://repeaterbook.com/repeaters/details.php?state_id=48&ID=11397
[CTCSS]: https://en.wikipedia.org/wiki/Continuous_Tone-Coded_Squelch_System