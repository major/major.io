---
author: Major Hayden
date: '2021-01-23'
summary: Taking the leap and selling your first options contract takes a lot of
  thought and preparation.
images:
- images/2020-01-23-paragliding-mountains.jpg
slug: choosing-options-to-sell
tags:
- investing
- options
title: Choosing options to sell
---

🤔 *This is another post in a set of posts on [options trading]. If you are
new to options trading, you may want to start with some of my earlier posts.*

[options trading]: /tags/options/

{{< figure src="/images/2020-01-23-paragliding-mountains.jpg" alt="Paragliding in the mountains" position="center" >}}

You know your terminology, you know your max loss, and you are ready to start.
Now you're faced with the difficult question all new options traders face:

> How do I choose which option to sell?

At first, you learn to look for the trades that are right for you. This post
explains some of the things I look for when I make a trade, and how I compare
different trades to see which one is right for me.

## Determine how much you want to risk

If you're starting the wheel strategy, then you are selling a put contract on
a stock at a particular strike price. Options contracts involve 100 shares of
the underlying stock, so you can multiply the strike price by 100 to know how
much money you are risking on the trade.

For example, if you sell a $90 put option on AMD, then you are risking $9,000
on the trade. The chances of AMD rocketing to $0 is extremely unlikely, but
anything is possible.

Compare the size of your trade to the size of your account. Risking $9,000 in
a $10,000 account may not be the best idea for new traders since you are
putting 90% of your capital at risk. The goal is to avoid "blowing up" -- when
you lose so much that you don't have enough capital left for good trades. 💣

If my conviction on a trade is very strong (I know the company, I know the
stock's personality, and I've done my homework), then risking 15-20% of my
account on the trade seems reasonable. For companies I know less about, I
won't go past about 5-10% of my account on the trade.

## Watch your stock's calendar

There a certain events in the lifetime of a stock that can cause wild swings
in price. Selling options around the time of these events creates increased
risk because you really don't know what happens during the event. Some of
these events include:

* **Dividends.** These are announced far in advance and stocks will often
  creep up just before the dividend date and then fall a bit after. If your
  option buyer wants the dividend badly, you may get assigned early.

* **Splits.** Stock splits are usually safe for options selling since your
  contract is automatically adjusted without you doing anything. However, if a
  stock does a significant split, like a 5:1, then a new influx of buyers with
  a new buying style may get into the stock. The stock's "personality" can
  change quickly.

* **Product events and announcements.** Launch events, such as Apple or
  Google's new phone launches, or Tesla's battery days, can have a huge impact
  on the stock price. The stock can fall even if the launch looks spectacular.

* **Earnings.** Definitely watch out for these. Stock prices do some idiotic
  things around earnings time. *I avoid these in almost all conditions unless I
  have a lot of conviction about the stock.*

I've written about earnings in previous [options trading] post, but it bears
repeating: earnings are unpredictable. Even if the earnings report is stellar,
you may see the price fall off drastically. Why? Perhaps investors want to
take profit. Perhaps investors were expecting more on earnings and the
expectations were already "priced in".

Don't sell options around earnings unless you know what you're doing. Even if
you think you know what you're doing, you probably don't. 😉

## Choosing a strike price

Once you know the stocks that fit your trading style, it's now time to choose
your strike price. IThere's a critical options calculation to know here:
delta.

Delta runs from 0 to 1 and some software represents it as a percentage. It
describes how much the option price moves as the underlying price moves. Here
are some examples:

* **1.00 delta (or 100%):** The option price moves at the same rate as the
  underlying price. If the stock price goes up $10, the option price goes up
  $10.
* **0.50 delta (or 50%):** The option price moves at half the rate of the
  underlying stock. If the stock goes up $10, the option price goes up $5.
* **0.25 delta (or 25%):** If the stock goes up $10, the option price goes up
  $2.50.

Most of my puts are sold near the 0.25 delta mark. This means that there is
roughly a 75% chance that my put will finish out of the money (I keep the
premium and there is no loss). There is a 25% chance that my put finishes in
the money and I will be assigned stock (possibly at a loss).

We could spend all afternoon talking about delta and theta, but a good start
is to sell your puts somewhere near 0.25 delta. I will sometimes move towards
0.30-0.35 delta if I feel very bullish about a stock or I will move towards
0.20 delta if my conviction is less strong.

## Calculate your return

We wouldn't sell options if we didn't expect a return! It's a good idea to
know your potential return for any trade you make. Let's take an example trade
and calculate our maximum loss and potential return.

* AMD is trading at $92.79.
* You choose to sell a put at the $85 strike (.26 delta) that gives $2.42
  premium and expires 2021-02-19.
* Maximum loss is `strike price - premium received`. That's `8500 - 242 =
  $8,258` in the absolute worst case ***the world is ending*** scenario.
* Your breakeven point is $82.58. As long as AMD stays above that price, you
  make money.

You can calculate your return with: `bid / (strike - bid) * 100`. For our
trade, that's: `2.42 / (85 - 2.42) * 100 = 2.9%`. If AMD stays over $85
through the life of the contract, you get a 2.9% return.

There's another angle we can use to analyze the trade: an annualized return.
Annualized returns consider how long you had to tie up your capital on a trade
while you wait for your return. Would you rather make a 2.9% return in one
week or one year? I'd much rather make it in a week.

The annualized return calculation extends the calculation we've already done
above: `(potential return / days held) * 365`. We know we have a 2.9%
potential return and 28 days to expiration, so we can calculate the annualized
return: `(2.9 / 28) * 365 = 37.8%`

If you did this trade successfully over and over again all year long, you
could possibly get a 37.8% return at the end of the year on these trades.
Don't take this as a given, though. I usually use this to compare different
trades against each other to see which one is a better use of my money.

## Comparing trades

Let's say you like the AMD trade from the previous section, but you're also
looking at another stock that you really like. How do you choose which one to
sell? I usually consider the annualized return. If I can make more money with
the same amount of capital, I'll go for that trade.

FUBO is another stock I follow and I have strong conviction on it as well.
Here's a trade there:

* FUBO is trading at $37.72.
* You choose to sell three puts at the $30 strike (.22 delta) that gives $2.13
  premium each and expires 2021-02-19.
* Maximum loss is `strike price - premium received`. That's `3000 - 213 =
  $2,787` Since we are selling three contracts, max loss is $8,361.
* Your breakeven point is $27.87. As long as FUBO stays above that price, you
  make money.
* Return: `2.13 / (30 - 2.13) * 100 = 7.6%`
* Annualized return: `(7.6 / 28) * 365 = 99%`

The FUBO put has a much higher annualized return, which gets my attention.
However, FUBO is riskier for me since the stock has a much shorter history and
it is much more volatile. Sure, I can make more money with this trade, but the
risk is substantially higher.

After checking the calendars, I found that AMD has earnings in the next week!
That breaks my trading rules since I avoid earnings under almost all
conditions!

## Making the trade

Every stock and options trade has a bid/ask spread. Buyers say "I will pay
$1.00 for this trade" and that's the bid. Sellers say "I will only sell if
someone pays me $2.00" and that's the ask.

Under most situations, I sell at the midpoint of the bid/ask spread. This
means that on a spread of 1.00-1.10, I will sell at 1.05. The trade executes
within 30 seconds unless the stock price is moving quickly.

If the stock is moving fast or if you really want to be sure your trade gets
in, sell at the bid price. That almost always guarantees that a buyer is
waiting to buy your contract as soon as you write it.

You can sell at the ask or even higher if you really want to, but your
execution could be delayed or it may never execute.

Congratulations! You sold your first option. What do you do now? *(Keep
reading.)*

## After the trade

Your trade may turn red immediately after it executes: don't panic! Most
brokers show the midpoint price (or "mark") and if you sold at the bid price,
your trade will be red at first. Also, if the stock price dipped a little,
your trade will be red for a short while. Take a deep breath.

One of the first things I do (after [logging my trades on thetagang.com]), is
to put in a buy order at a 50% gain. Consider our AMD trade earlier ($85 put
with $2.42 premium). I would enter a buy order for $1.21 with "good til
canceled" (GTC). There's no more work to do! As soon as I can get a 50% gain,
the trade executes and I keep my $121 profit!

Why stop at 50%? I have several reasons:

* It reduces my chance of loss because my money is at risk for less time.
* Emotion is removed from the trade. My trade is closed the moment 50% gains
  are reached.
* I have work and kids. I don't have time to hover over my broker interface
  all day long.
* It almost always leads to a better annualized return.

A better return with a smaller profit? How can that be? 🤔

Let's [take an example from a PLTR trade I did last month]. I sold two $25
puts for $2.04 premium each that had a 128% annualized return. However, the
50% trigger closed the trade in two days when PLTR rocketed upward
unexpectedly.

If I held the trade from January 20 to February 12 and PLTR finished above
$25, I would have made $408 (128% annualized return). Instead, I made $204 in
two days (Jan 20-22). What's our annualized return here?

* Potential return: `2.04 / (25 - 2.04) * 100 = 8.9%`
* Annualized return: `8.9 / 2 * 365 = 1,624%`

Wow! 🤯

That's 1,624% versus our original 128% annualized return and my money was only
at risk for two days. What if PLTR suddenly drops next week? I avoid that risk
by collecting profit early and freeing up capital for another trade.

One big part of risk management in the market is to keep your capital at risk
for the shortest amount of time possible to make the returns you want.

Good luck! 🍀

[take an example from a PLTR trade I did last month]: https://thetagang.com/mhayden/4378b667-d325-4b82-92ca-138f340acacb

[logging my trades on thetagang.com]: https://thetagang.com/mhayden

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Tomas Sobek on Unsplash](https://unsplash.com/@tomas_nz)*
