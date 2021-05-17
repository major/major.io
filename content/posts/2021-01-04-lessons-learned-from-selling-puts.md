---
author: Major Hayden
categories:
- Blog Posts
date: '2021-01-04'
description: Learn from my successes and mistakes while selling puts in the stock
  market in 2020.
images:
- images/2021-01-04-dark-road-mountains.jpg
slug: lessons-learned-from-selling-puts
tags:
- investing
- options
title: Lessons learned from selling puts
type: post
---

🤔 *This is another post in a set of posts on [options trading] on the blog.
If you are confused on terminology, go back and start with the first post and
the series and work your way to this one.*

{{< figure src="/images/2021-01-04-dark-road-mountains.jpg" alt="Dark Road with Mountains" position="center" >}}

My options trading journey started back in September 2020 and I learned a lot
in a short amount of time. This post covers some of the lessons I've learned
along the way.

Edwin Lefèvre says it best as Larry Livingston in [Reminiscences of a Stock
Operator]:

> Whenever I have lost money in the stock market I have always considered that
> I have learned something; that if I have lost money I have gained
> experience, so that the money really went for a tuition fee.

[options trading]: /tags/options/
[Reminiscences of a Stock Operator]: https://en.wikipedia.org/wiki/Reminiscences_of_a_Stock_Operator

## Make a set of rules and stick to them

This was one I learned early on from [Joonie], the leader of the Theta Gang.
[His podcasts] covered this topic frequently and the importance of this step
cannot be understated. Everyone needs a strong set of rules when making trades
so that emotion can be removed from trades.

Emotion easily sneaks in and clouds your judgement whether your investments
are green or red. When emotion takes over full control, you become "tilted"
(as Joonie says), and you make poor choices. You can quickly over-leverage
yourself and ruin a winning position. You can also throw good money after bad
and make your losing positions worse.

Start by building a set of rules that you can follow, or better yet, add to a
screener (more on that next). Here is my rule list as of today for selling
puts:

* The underlying stock must be a stock I would enjoy holding for an extended
  period (potentially weeks or months).

* The underlying stock must be priced higher than $10.

* Choose a trade between -.20 to -.30 delta on a monthly expiration date (no
  weeklies). This is roughly 70-80% chance of profit.

* Make trades on an underlying that is moving sideways or has a long upward
  trend above the 50 day exponential moving average (EMA), but avoid any
  underlying stock with spikes or gaps up that aren't explained by solid news.
  *(This avoid pump and dumps or other manipulative patterns.)*

* The monthly expiration should be between 21-60 days away from the current
  date.

* A trade should have an annualized return over 20%.

* No earnings reports or other news should be scheduled before expiration.
  *(Earnings are dangerous and unpredictable, even if you somehow get an
  advanced copy of the filing.)*

By following your rules closely, you avoid making trades that you regret.
However, market conditions could lead you to bend one of these rules. For
example, if the market is fairly steady and the underlying has been moving
sideways for a while, I may move closer to -.30 to -.40 delta (about 60-70%
chance of profit).

[Joonie]: https://twitter.com/realthetagang
[His podcasts]: https://rss.com/podcasts/thetagang/

## Know exactly when you will exit the trade

This one is separate from the rules list above because it is important all by
itself. When you enter any trade in the market, have an *exact* exit strategy
in mind.

For my trades, I always exit when I have reached a 50% profit. If I sell a $90
put on AMD and get $2.50 in premium, I immediately enter an order to buy it
back at $1.25. This takes all emotion out of the trade and it ensures that I
won't miss out on profits if I am away from the computer. It's a great feeling
to suddenly get a notification from your broker that you made money when you
least expect it. 🤗

Always remember: profit is profit. I may make $1.25 on that trade while
someone else makes $2.50, but my capital is freed up earlier for other trades
and my profit is secured. I'd take a 50% gain over a loss of any size.

## Wait on trade ideas to come to you

Sometimes the best trade is not to trade at all. My trading rules are fairly
easy to pack into a scanner and that's usually how I research my trades. I
scan for options on [Barchart] and I will occasionally use [finviz] to find
new stocks that should be on my radar.

I get an email from Barchart about an hour after the market opens with my list
of options that meet my criteria. From there, I decide on which ones to trade
and which ones to skip. If there's something good in the list, I'll make a
trade. Otherwise I'll wait for the conditions to line up with my investment
goals and rules.

[Barchart]: https://barchart.com/
[finviz]: https://finviz.com/

## Trade outside the crazy market hours

I avoid trading during the first hour the market is open (9:30-10:30AM
Eastern) and the last hour (3:00-4:00PM Eastern). The trading volume is really
high around these times and it can be difficult to figure out what a stock is
doing during those times. Day traders and swing traders are extremely active
during this time.

## Be patient with limit orders

Always use a limit order when selling options and be patient with them. For
example, if the bid/ask spread is $1.00 to $1.10 and you decide to set your
limit order to $1.05, be patient. Many people will rush to lower the limit
when the trade does not execute immediately, but you should stick with your
order.

Selling puts on volatile stocks allows you to collect premium, but volatile
stocks have volatile options, too. I usually set my limit orders right in the
middle of the bid/ask spread and wait. About 90% of the time, the order
executes within a few minutes because the stock price is volatile.

## Trade where other people are trading

Be sure to find out where the [most active options] are being traded in the
market. Options volume helps you enter trades quickly at good prices. It also
helps you exit when it's time to take a profit. Stocks with low volume options
trading can provide good premiums, but it can be challenging to exit the trade
when you're ready to capture profit or limit your loss.

Use care when you follow [unusual options activity] reports. It can be
exciting to jump in on trades when you see lots of money pouring into puts and
calls.

However, many of these big options trades are hedges from larger firms who
want to avoid losses or capture extra gains for their clients. There's also
some market manipulations strategies here where people buy tons of calls on a
stock in the hopes that market makers will buy lots of shares.

[most active options]: https://www.barchart.com/options/most-active/stocks?viewName=main
[unusual options activity]: https://www.barchart.com/options/unusual-activity/stocks

## Scrutinize skyrocketing stocks

Sometimes you'll see a stock that has traded sideways or posted small gains
day after day and then it suddenly shoots straight up (often called
"mooning"). These look like great targets for selling puts at first, but you
should be cautious.

Stocks sometimes do this when big news comes out about a company. For example,
if a small semiconductor company makes a deal with Apple to put chips in new
laptops, there's a good chance that the small semiconductor stock will moon
wildly. The market does this because the company's valuation is now in flux.
Is this company's valuation now 50% more? Double? Quadruple? Be careful until
the market decides on the new valuation.

You may also see situations where stocks go through the roof and there is no
news, no big insider trading, and no significant industry news. This is where
you should be **extremely cautious**. Prices often do this when the stock is
being manipulated or when activist investors are at work.

The worst case is that the stock is headed into a "pump and dump" scheme where
shares are rapidly being bought in the hopes that other investors will buy it
up thinking that some news is about to come out (the "pump"). Once a lot of
new investors pile on, the group buying the shares stops and sells all their
shares (the "dump").

The dump side often involves investors called "shorts" who short the stock and
cause the price to go down further. This is a dangerous move for shorts if the
buyers keep buying as this could lead the price to skyrocket again and force
shorts out of their shares.

## Avoid trading around earnings

Earnings are some of the wildest times in the market and they're incredibly
hard to predict. I've seen companies post excellent earnings reports with
glowing numbers, great sales, and excellent predictions. As soon as the
earnings come out, the stock falls 20%. 🤯

Keep in mind that valuation is a tricky thing and that many investors won't
agree on a valuation for a particular stock. A great example is that one of
the analysts following Tesla raised the price target from $90 to $105. Tesla
is trading at over $700 today. Again, valuation is in the eye of the beholder.

I've also seen companies post terrible earnings reports and their stock
remains flat or goes up. There's a chance that investors already predicted the
bad results and they're priced in already.

Something that may look good at the moment may turn out awful later. For
example, if a company releases earnings after the market close, they may only
release a PDF after the market closes that includes their SEC filing data.
That data may look fantastic and the stock moons immediately. Later, when the
company has their conference call, they announce they're acquiring another
company and they are revising future estimates down by 20%. The stock prices
falls through the floor.

Even if you had an advanced copy of a company's earnings filing, it would
still be incredibly difficult for you to make a trade that will make a profit
once the market is closed.

## Track your trades

Keep yourself honest by tracking your trades. I track mine on [thetagang.com]
and it's a free way to analyze your trading strategy. You can find other
people trading the same stocks and ask them questions. There is also a list of
trending stocks that is updated frequently and this can help you build your
own watchlist.

You can learn a lot from reading notes from other traders about their trades.
I encourage you to leave good notes as well since this tests your conviction
on the trade. If you're not confident enough to explain to other people why
you made the trade, then why make it in the first place?

There are a litany of spreadsheets out there for tracking trades as well, but
the best one I found is the [Options Tracker Spreadsheet from 2 Investing]. It
pulls stock quotes directly from Google Finance and it calculates helpful
metrics, including annual return metrics.

[thetagang.com]: https://thetagang.com/mhayden
[Options Tracker Spreadsheet from 2 Investing]: https://www.twoinvesting.com/2016/10/options-tracker-spreadsheet/

## Like water off a duck's back

When you win, take time to understand what worked in your favor so you can
repeat it.

When you lose, take time to understand what went wrong and what concrete
things you plan to change.

I was up almost $3,300 at the end of 2020 and I chased a skyrocketing stock,
FUBO, much longer than I should have. It mooned without much news and I kept
chasing it. That led to a loss of over $5,000 and my end of year finish was
negative.

My mistake was that I had so many winning trades back to back that I got
"tilted" and violated my rules. Initially, everything looked good, but once it
turned after hours, there was nothing I could do. I continued to hold and
hoped that the conditions would change, but nothing changed. The loss stopped
the bleeding and I would have easily lost $2,000 more if I had not exited when
I did.

After this failure, I went back to my list of rules and made them more strict.
I'm also working on a script that allows me to maintain a watchlist and let
quality trades filter through that match all of my rules. I plan to put the
script on GitHub soon once it works. I also shared my failure with other
people and told them what I thought I did wrong.

The loss still hurts, but I'm trading again to make up the loss. My goal is
still to donate a percentage of my gains to charity, so I keep that goal in
mind. The key is to stay in the game.

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Artem Kniaz on Unsplash](https://unsplash.com/@artem_kniaz)*