---
aliases:
- /2020/12/07/the-dark-side-selling-options/
author: Major Hayden
date: '2020-12-07'
summary: Selling options puts you on the other side of the options contract from buyers,
  but it comes with obligations.
tags:
- investing
- options
title: 'The Dark Side: Selling Options'
---

I've started a [series of posts on options trading] and if you haven't read
yesterdays post, [Options trading introduction], you should start there first.

[series of posts on options trading]: /tags/options/
[Options trading introduction]: /2020/12/06/options-trading-introduction/

## Recap: Buying calls and puts

Just to recap the introductory post:

* Buying a call gives you the *right* to buy a stock at a certain strike price
* Buying a put gives you the *right* to sell a stock at a certain strike price

Buying calls is a great way to capture gains from a stock that is trending
upwards an buying puts provides an insurance policy in case your stock drops.

You can make money in multiple ways:

* Exercising a call option to buy stock at a reduced price (without owning the
  stock first)
* Exercising a put option to sell your stock at a higher price (and reduce
  losses on your owned stock)
* The stock moves towards (and hopefully, past) your strike price and you can
  sell the option to someone else for a profit

But there's an entirely other world out there and it involves **selling options**.

## Rights versus Obligations

So far, we've only talked about rights. When you buy an options contract, you
have the right to do nothing, exercise the option, or sell it away to someone
else.

Selling options means you **must fulfill an obligation.** We aren't talking
about selling an option you purchased -- that's simply called *selling to
close*. What we're talking about here is a different concept: *selling to
open*. This is sometimes called *writing a put* or *writing a call*.

When you sell a contract, you are paid a sum of money called a *premium*. The
buyer is the one paying the premium to you. Let's dig into what's happening
here:

* You are going out into the market and saying "I'd like to get $200 to sell
  this put that expires on December 31"
* A buyer can choose to take you up on your offer, give you $200, and the
  contract is written
* **The contract is written in stone until the expiration date**

It's key to remember here that there are only two ways out of an options
contract that you sell:

1. You buy it back (hopefully at a profit). This is called *buying to close*.
2. The option expires.

There are three warnings we must cover before we go any further:

💣 **Never sell an options contract that you do not intend to fulfill.** Sure,
it may sound amazing to receive $4,000 in an instant to sell an option, but
eventually that option expires and that can sometimes be a disaster.

💣 **Never assume that you will be able to buy to close your sold contract
before expiration.** The market does weird things and you may be stuck with
holding your option through expiration or taking a loss before expiration.

💣 **Never sell options contracts if you don't have stock or cash to cover
them.** Getting stuck in a margin call (or worse) with your broker is not a
good place to be.

With that said, about 95% of my current trades involve selling options. More
on that later.

## Selling puts

We should talk about selling puts first because that concept is a little
easier. When you sell a put, you specify a few things:

* Underlying stock ticket (such as AMD, WMT, or TM)
* Expiration date
* How much premium you want (this is the *ask* portion of the bid/ask spread)
* The strike price

Selling puts can make money in a few different ways. The stock can go up, go
sideways (where it hovers around a certain price), or go down a little.

Let's go through an example. You think AMD is likely going to keep its same
price or go up over the next few weeks. If AMD is trading at $100 now, you
decide to sell a put for $90 and collect $200 in premium.

🛑 **Before entering this trade, ensure you have _at least_ $9,000 of cash in
your account.** 100 shares of AMD could potentially cost you $9,000 if you are
assigned -- more on that below.

Now what?

* AMD skyrockets up to $125
  * Your put loses value rapidly and you can buy it back for only $25 after a
    few days. You just made $175 in profit since you originally received $200
    for selling the contract and paid $25 to close it.
  * You can let your put expire and keep the $200 premium. (Risky!)
* AMD gets stuck at $100
  * Over time, your put loses value and you can buy it back at a
    cheaper rate before it expires (optional).
  * You can let your put expire and keep the $200 premium. (Risky!)
* AMD falls to $85
  * You're now in the money and that's not great for a sold option.
  * The buyer will likely exercise the option they bought from you and you
    will be *assigned* at a loss. (Keep reading)

## Assignment on puts

Some traders hear about *assignment* and they run off to hide. Assignment
means that the buyer of your contract wants to use their right to exercise.

Let's go back to the very last example above where we sold a put for $90 and
AMD fell to $85. This situation feels scary until you break it down:

* You keep your $200 no matter what. You sold the contract and that's yours.
* You must buy 100 shares of AMD at $90 each.

But wait, you have to buy AMD at $90 even though AMD fell to $85! That's your
obligation for selling the contract. That means you will lose $500 on the
stock purchase. (You bought $8,500 of AMD stock but had to pay $9,000 for it.)

All together, you lost $300. You paid $500 extra for the AMD shares but you
kept your $200 premium for selling the contract. But, now you have 100 AMD
shares worth $8,500 in your account!

What do you do with those?

## Selling calls

Now you have 100 shares of AMD in your account worth $8,500 and you're still
down $300. It's time to talk about selling calls. Selling calls and puts
involve the same concepts of specifying a strike price, how much premium you
want, and an expiration date.

You take a look at the options chain and you see that you can sell an AMD call
for the $90 strike price for $250 and it expires in a few weeks. This is
called a *covered call* since you own 100 shares as collateral for the
contract.

You sell the call and now there are some potential outcomes:

* AMD falls to $80
  * Your call loses value rapidly and you can buy it back for a tiny amount.
    If you buy your call back at $25, then you made $225. ($250 premium
    originally received minus $25 you paid to close it)
  * Go back and sell another call, collect more premium, and increase your
    profit.
  * Allow the call to expire worthless and keep your full $250 premium. (Risky!)
* AMD gets stuck at $85
  * Your call gradually loses value and you can buy it back for a tiny amount.
  * Go back and sell another call, collect more premium, and increase your
    profit.
* AMD climbs to $95
  * You're now in the money here.
  * When the option expires, the buyer of your contract will likely want to
    exercise and they will buy your shares at $90 each (your strike price).
  * Your shares are gone. (But keep reading.)

## Assignment on calls

Getting assigned on puts means you have to buy the stock at your stike price.
Getting assigned on calls is a little different. You *sell* your stock at the
strike price to the person who bought your call option contract.

Let's go back to the previous example where you sold a $90 call option for
$250 and AMD went to $95 per share:

* You keep your $250 premium since you sold the contract.
* You sell your 100 AMD shares at $90 each (your strike price) even though AMD
  is trading at $95.

Technically, you lost out on $500 of profit that you could have received if
you had not sold the call. However, you keep the $250 of premium and you can
begin selling puts again.

## Why not just buy stock and hold it?

I have accounts where I buy stock and hold it for a long time. However,
selling options allows you to collect premium and get profits even in a market
that isn't moving much.

If a stock gets stuck in a sideways pattern where it doesn't move much for
weeks, buying and holding the stock might give you a very small gain. During
that time, you may have been able to get a better return selling options on
that stock and collecting the premium.

## What's the worst that can happen?

It's always important to know what your max loss is for any trade. Losses
begin when the stock price breaches your breakeven price:

* Put breakeven = strike price - premium received
* Call breakeven = strike price + premium received

If you sell a $90 put for $200 and the stock falls to $89, you are still up
$100. If you sell a $90 call for $200 and the stock goes up to $91.50, you are
still up $50.

However, if you are selling puts or calls, there is a chance that the stock
could completely crater and go to zero. The chances of that happening to a
well-known company that has been on the market for years is **very low**, but
it's important to know max loss.

Let's say you sold a put on company XYZ at the $100 strike and received $500
in premium. The stock somehow falls to $1 per share. Your max loss here is
`((100 x $100) - (100 * x $1)) - $500 = $9,400`. The buyer of your options
contract will **surely** want to exercise so they can sell their XYZ stock at
$100 instead of $1.

On the call side, let's say you sold a $110 call on XYZ for $500 and the stock
fell to $1. The 100 shares of XYZ you own would now be worth $1 per share, but
you do keep your $500 premium. If you had owned the shares without selling
that call at that time, you would have suffered the same fate (without getting
$500 in premium).

## The Wheel

The strategy shown here is called the wheel strategy. It involves these steps:

1. Sell puts and collect premium
2. If unassigned, go back to step 1
3. If assigned, sell calls and collect premium
4. If unassigned, go back to step 3
5. If assigned, go back to step 1

This strategy will be covered in the next post!

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Ricardo Gomez Angel on Unsplash](https://unsplash.com/@ripato)*