---
aliases:
- /2020/12/09/know-your-max-loss/
author: Major Hayden
date: '2020-12-09'
summary: Knowing your maximum amount of loss on trade is the difference between taking
  a calculated risk and blowing up your account.
tags:
- investing
- options
title: Know your max loss
---

This is the third post in a [series of posts on options trading]. You can read
this one out of order since it applies to almost everything you do in the
stock market, including buying shares of stock.

[series of posts on options trading]: /tags/options/

## What is "max loss"

The maximum loss on a trade is the worst outcome possible. Knowing this number
helps you protect your account from huge losses and avoids terrible situations
such as margin calls. *(This is when your broker is forced to arbitrarily sell
off things in your account or demand money from you to get your account above
a zero balance.)*

When I first started learning about options trading, many people told me it
was too dangerous. They told me "just buy shares since it's safer." If you
begin analyzing maximum loss, you quickly realize that buying shares can be
more risky than certain types of options.

## Maximum loss when buying shares

As an example, let's say you own 100 shares of Wal-Mart (WMT). It's trading
around $148 today, so that means you have $14,800 in total equity. Your
maximum loss would occur if the stock fell to zero and your total loss would
be $14,800.

A major retailer losing 100% of its value in a very short period of time is
highly unlikely, but it's possible. There's nothing that prevents it from
happening (other than the stock being halted in the market), and there is a
chance that you could lose your entire investment.

It took Enron about a year to drop to nearly zero, but some other drops have
been much more abrupt. According to [Investopedia], some stocks have had some
rough days:

* Facebook lost $119B (2018-07-26)
* Intel lost $90B (2000-09-22)
* MSFT lost $80B (2000-04-03)
* AAPL lost $60B (2013-01-24)

Buying shares is a great way to start in investing for your future, but it's
important to know your maximum amount of loss and ensure you're prepared to
hold the stock through the down times.

[Investopedia]: https://www.investopedia.com/investing/biggest-singleday-market-cap-drops-us-stocks/

## Maximum loss when buying options

When you buy options, your maximum loss is the amount of premium you paid for
the option. If you pay $200 for a call on a stock, your max loss is $200. The
same goes for puts.

The maximum loss scenario for bought options is when the option expires *out
of the money*. For a call, this means the stock price was under your strike
price at the expiration time. For a put, the stock price would need to be
above your strike price.

## Maximum loss when selling a put

There are two types of puts:

* *cash secured puts* - You sell a put when you have cash to to cover the
  strike price.
* *naked puts* - You sell a put without having cash to cover the strike price.

Some of this was covered in the [The Dark Side: Selling Options] post, but
it's worth talking about it here again. When you sell a put, you are obligated
to purchase the stock at the strike price.

The max loss scenario here happens when the stock price falls to zero. Sure,
that is unlikely, but it is possible. You will keep your premium from selling
the put, however.

An important thing to remember is that your options are *capped*. If you sell
a put at a $100 strike price and collect $200 in premium, your losses are
capped at $9,800. The stock can't go below zero (thankfully).

With a cash secured put, you have cash on hand to deal with the loss and
purchase the stock. However, with a naked put, you don't have cash to cover
the loss. Your broker will issue a margin call and begin selling off other
equities in your account to cover the loss. If that fails, they will demand
that you deposit money to cover the loss.

💣 **Never sell naked puts. Ever. Seriously.**

## Maximum loss when selling a call

Here's where things can become horrifying. When you sell a call, there are two
main types:

* *covered call* - You own 100 shares of the stock and use them as collateral
  to sell a call option.
* *naked call* - You sell a call for a stock but you don't own any shares.

Let's work with the covered call example first. Let's say you own 100 shares
of XYZ and that stock is trading at $100 per share. You think the stock might
go up a little but not a lot, so you sell a call at the $105 strike price.

The best outcome would be for the stock to stay between $100-$105 so you don't
lose money on the shares you own and your call is not exercised. There's no
losses there.

What if the stock flew to $125? You get to keep the premium for selling your
call option, but you have to sell those shares for $105 (since that was your
strike price). Sure, you did lose $20 per share of profit ($2,000 total), but
you still made money. You received the premium and your stock gained $5 per
share ($500). You just missed out on some of the gains.

What if the stock falls to $50? You still keep your premium, but your $10,000
of equity (100 shares x $100) is now $5,000 of equity. You took a $5,000 loss.
It's the same loss you would have had if you bought shares and didn't sell any
options. However, you are getting the small benefit of the premium you
received when you sold the call option.

In all of these scenarios, your losses are *capped*. You know what you can
possibly lose, but you know the limit of the loss.

## Never sell naked calls

**This loss is potentially so bad that it needs its own section.** Covered
calls are nice because your collateral appreciates in value to cap your upside
losses. What if you didn't own the stock?

Let's say you sold a call on XYZ for $105 again and it was trading at $100 per
share. However, you don't own any shares this time.

If the stock climbs to $104.99, your option expires out of the money and you
keep your premium. Nice!

If the stock falls to $50, your option expires out of the money and you keep
your premium. Nice!

If the stock climbs to $125, you have a problem. You agreed to sell 100 shares
to the buyer for $105 per share. You now have to buy 100 shares at $125 each
(since that's the current stock price) and you have to sell them for $105
each. That's a $2,000 loss right there.

However, let's say that XYZ is a biotechnology firm and they report that they
have a treatment for almost any cancer in the human body with a 14 day home
treatment with almost no side effects. This is a life-altering change for
people suffering from cancer. The stock climbs to $450 and investors say it
will go higher. By the time the option expiration hits, the stock is worth
$600.

What now? You sold a call option for $105. That means you have to buy 100
shares of the stock at its current price ($600 each) and sell that stock for
$105 each. The math start to hurt:

* You purchase 100 shares at $600 each = $60,000.
* You sell 100 shares at $105 each = $10,500.
* You lose $49,500. 🤯

💣 **Never sell naked calls. Ever. Seriously.**

## Know your max loss

Before you enter a trade, know what the worst case scenario will bring and
ensure your account is prepared for it.

I entered a trade earlier this year where I had a 85% percent chance of profit
and the trade looked fantastic in my account. I had money to cover the loss
but I doubted I would need it.

The company suddenly dropped news within 48 hours of entering the trade. The
news said that one of their acquisitions was a little slower and more
expensive than they thought and their Q3 number would be revised down. The
numbers were revised down a lot. **My nice gain turned into a $660 loss
that I was forced to look at every day for a month until the expiration.** It
was a daily reminder of two things:

1. Anything can happen in the market.
2. I was fully prepared for maximum loss.

💸

[The Dark Side: Selling Options]: /2020/12/07/the-dark-side-selling-options/

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Andre Benz on Unsplash](https://unsplash.com/@trapnation)*