---
author: Major Hayden
categories:
- Blog Posts
date: '2020-12-06'
summary: Trading options contracts feels incredibly daunting, but you can learn
  the terminology and make good choices in the market.
images:
- images/2020-12-06-snow-mountain.jpg
slug: options-trading-introduction
tags:
- investing
- options
title: Options trading introduction
type: post
---

{{< figure src="/images/2020-12-06-snow-mountain.jpg" alt="Snowy Mountain" position="center" >}}

I'm always on the hunt for new things to learn and one of my newer interests
is around trading options on the stock market. Much like technology, it
becomes much easier to understand when you peel back the layers of archaic
terminology, snake oil salespeople, and debunked data.

Stay tuned for additional posts that go into greater detail. This post covers
the basics about what an option is (and is not) and how you can compare it to
other investment vehicles, like stocks.

## Investing in stocks

Most of us are likely familiar with how investing in stocks works to some
extent. The process goes something like this:

* Deposit money into a brokerage account
* Find a company that has good qualities for value and growth
* Buy shares
* Wait

If the company performs well **and** other investors also see value in the
company, your investment should gain value. For example, If you buy 10 shares
of a company for $100 each ($1,000 total investment), and the stock value goes
up by 10%, you will have 10 shares at $110 each ($1,100 total investment).

Stocks go up very often, but they go down, too. If the stock lost 10% of its
value, you would own 10 shares of a $90 stock and your total investment would
fall to $900.

Sometimes the stock market does downright silly things and companies with
great fundamentals go down, while others with horrible numbers keep going up.

A. Gary Shilling once said:

> Markets can remain irrational a lot longer than you and I can remain
> solvent.

Nothing could be more true.

## How are stocks traded?

This could be an entire post in itself, but I'll keep things simple. When you
buy a stock, you're buying it from someone else. That could be another
investor, a hedge fund,a mutual fund maintainer, or a massive company.

The other entity will set the price they are willing to sell some stock. This
is called the *ask*. Buyers in the market set the price at which they want to
buy, called the *bid*. When you look at the highest bid and the lowest ask for
a stock at one time, that's called the *bid/ask spread* or often just *the
spread*.

If nobody sets a bid at or equal to anyone's ask price, no stock changes
hands. Either the buyer needs to raise the price that they are willing to pay
or the sellers need to come down on their asking price.

Look for stocks with a narrow bid/ask spread under $0.05-$0.10. This means the
stock is liquid (easily bought and sold) and you'll avoid a weird situation
called *slippage*, where the bid/ask spread is really wide and your trade may
not execute as a good price. (Limit orders help here. More on that later.)

## What is similar about options?

Options have bid/ask spreads, just like stock. Options are called derivatives
because they are derived from a certain stock. That stock is called the
*underlying*, since the options depend heavily on the stock's performance.
(Not every stock on the market has options, though.)

## What is different about options?

Options are contracts. Every options contract has rights, obligations, and an
expiration date.

Buyers of options contracts have rights (things they can choose to do) and
sellers have obligations (things they must do). Everything starts with a buyer
or seller who wants to open a contract. Once it's open, it can be closed via
different methods.

It revolves around two main types of contracts: calls and puts.

## Buying calls

If you buy a call option contract, you have the right to buy shares at the
price you specify, which is called the *strike price*. *(You can sell calls,
too, but let's keep this simple for now.)*

AMD is a popular stock for options traders and we can use it as an example.
Let's say that AMD is trading at $100 per share and you think their next chip
launch will be really successful. A call could help you catch some of the
*potential* upswing in the stock.

Let's say you buy a call at a strike price of $105 for $200 and the contract
expires December 13. What have you done here and what are your rights?

* You made a *buy to open* order for a call contract that cost you $200.
* You cannot trade this option after the market close on December 13.

What are the potential outcomes before expiration? Let's analyze what AMD
could do during that time:

* Best outcome: AMD rises to $110
  * You are *in the money*
  * Your options contract will increase in value and you can sell it before
    expiration.
  * You can choose to *exercise* the option, which means you are using your
    right to buy 100 shares of AMD at $105 each, even though the stock is
    trading at $110! Your profit would be `(100 * $110) - (100 * $105) = $500`
* Good outcome: AMD rises to $104.99
  * You are *at the money*
  * During this time, your call option goes up in value since the stock price
    has moved really close to your strike price of $105.
  * You can sell your option contract for a profit before expiration.
* Worst outcome: AMD falls below $100
  * You are *out of the money*
  * Your options contract will be worth a lot less since the stock price has
    moved away from your strike price.
  * If your options contract still has some value left, you could sell it to
    get back some of your losses.
  * If AMD falls *really* far below $100, you may find that your option has no
    value. This is called *max loss* and it hurts.

💣 Just in case you missed it: **you can easily lose all of your investment
with options**.

With stocks, a company can take a heavy loss, but you still have some value
left. With options, that same scenario means your original $200 investment is
completely gone.

## Buying puts

Buying a put, called a long put, is a different thing entirely. You are
choosing a price where you are willing to sell 100 shares of stock you own.
It's a great insurance policy for stock that you own.

Going back to the AMD example, let's say you own 100 shares of AMD at $100
each. If you buy a put at $90, you have the right to sell your stock at $90
even if AMD is trading lower than $90.

Let's go back to our $100 per share AMD example and you buy a $90 put for AMD
that costs $200 and expires December 13. There are some possible outcomes:

* AMD rises to $110
  * Your put option will lose lots of value, but it was your insurance policy
    anyway.
  * You can sell your put as the expiration gets closer, or you can let it
    expire on December 13th. It's worthless at that point, so nothing happens.
* AMD drops to $90.01
  * Your put will increase in value since the stock price has moved close to
    your strike price. You can choose to sell it before it expires to get a
    profit. (Keep in mind that the stock you own has lost value, too.)
* AMD drops to $80
  * You can exercise your put contract and sell your 100 shares of AMD for $90
    each, even though the current price is $80 per share! This will net you
    $10 per share, or $1,000 total. Your losses from the stock's fall are
    limited.

You might be asking: What happens if I think a stock will go down, I buy a
put, but I don't own the underlying stock?

If the stock drops, you can sell the put for a profit as the value goes up.
However, if you choose to exercise it, you will have a *short position* in
your brokerage account. This means you've borrowed stock from your broker and
they will likely charge fees and/or interest for this.

If AMD's price quickly rises afterwards, you will owe your brokerage the
difference. ***This is painful!*** Just imagine borrowing 100 shares at $80
each from your broker only to see the stock fly up to $120 per share. You will
owe your broker that $4,000 difference. 🥵

## Exercising

In your personal life, I usually recommend exercising regularly. When it comes
to options, exercising may not be your best bet. There are plenty of
situations where exercising an options contract is the worst idea.

Let's go back to our original example about buying a call on AMD for $105 when
the stock is at $100. As an example, the stock price climbs to $110 before
expiration and stays there on Friday afternoon. You are excited about your
profits and you tell your broker to exercise your contract.

Your broker submits the exercise request to CBOE, the options clearinghouse.
The CBOE has [some detailed rules about exercising] that I highly recommend
reading.

Let's say that something happens after hours at AMD that turns out to be
really bad. Maybe there's a delay on new chips, an accounting irregularity, or
something else. The stock crashes after hours after you have asked for the
exercise. The stock could be down to $80 by that point.

Since you asked for the exercise, the stock you expected to get (100 shares at
$105 each) will actually be **100 shares at $80** each by the time your
exercise is finished. This is an extreme example, but always consider what can
happen during the exercise process.

For a detailed explanation of potential outcomes here, and how to avoid them,
I highly recommend the [Options Expire Saturday] episode of the Theta Gang
Podcast. (The podcast is excellent overall.)

[some detailed rules about exercising]: https://markets.cboe.com/exchange_traded_stock/equity_options_spec/
[Options Expire Saturday]: https://rss.com/podcasts/thetagang/78866/

## What's next?

👶🏻 ***This introduction barely scratches the surface of options contracts,
so don't start trading yet.***

I'm planning future posts about selling options contracts, how to choose the
options to sell and buy, as well as many other ways you can gain (and lose)
money with options contracts.

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Dave Hoefler on Unsplash](https://unsplash.com/@johnwestrock)*
