---
author: Major Hayden
date: '2021-03-17'
summary: Feedback from my original options selling post said that the concept
  was too difficult to follow. Let's use an analogy!
images:
- images/2021-03-crazy-air-conditioners.jpg
slug: selling-options-made-simpler
tags:
- investing
- options
title: Selling options made simpler
---

🤔 *This is another post in a set of posts on [options trading]. If you are
new to options trading, you may want to start with some of my earlier posts.*

[options trading]: /tags/options/

{{< figure src="/images/2021-03-crazy-air-conditioners.jpg" alt="Power plant with four towers" position="center" >}}

After writing my original blog post about [selling options contracts in the
stock market], I received some feedback saying that the post jumped over too
many steps and used too much terminology. I went back, re-read the post, and
found lots of room for improvement.

If you understood the original post, then this post probably won't give you
much additional insight. However, if the original post left you perplexed, I
hope this post helps.

[selling options contracts in the stock market]: /2020/12/07/the-dark-side-selling-options/

## Starting out with an asset

Let's say you love classic cars. Many older cars that are one of a kind or
very well maintained can keep their value for a long time. Sometimes they even
go up in value over time due to demand!

You find a great deal on a gorgeous car for $15,000. It's perfect! Also,
demand has gone up for the car recently because it was featured in a popular
movie, so it might be worth more after a while.

So you invested $15,000 in the car. But wait, what if the car is stolen or
involved in a collision. Would it be worth $15,000 then? Likely not. Let's
assume that the car would lose half its value if it was involved in a
collision.

How do you protect it? Insurance.

You call your insurance company and ask how much it costs for a six month auto
policy on the car valued at $15,000. They offer you a deal of $500 for six
months. You give them $500 and they insure your car.

Let's convert this to options terminology:

1. You bought the car (which is like buying stock).
2. You're worried about the value of the car going down, so you bought
   insurance (which is like buying a put option contract).
3. The insurance company sold you the policy (like selling a put).

## The movie is a hit!

The movie that featured the same kind of car as yours was a huge success and
now the demand for your classic car is way up. You can easily sell the car for
$30,000 now!

But what about that insurance policy when the car was worth $15,000? It's
worth less now because the value of the car has increased so much. If you got
in a wreck now and the price of the car was cut in half to $15,000, your
insurance policy would still be there, but the value of the car is insured at
$15,000.

So you call your insurance company and ask for a new policy. They agree to
make a new policy for six months for $1,250. But wait, the car doubled in
value and the insurance policy went up by 2.5x. Why is that?

The increase in price of the insurance policy is due to the value going up,
but now the value is volatile. It's more difficult for the insurance company
to gauge the value of the car, how much the parts cost, and how much the labor
would be to fix it.

You decide to sell your original $500 policy and buy the new one for $1,250
that protects your car valued at $30,000.

Back to options terminology:

1. The value of the car (stock) went up.
2. When you needed insurance for the higher value (a put with a higher strike
   price), the insurance company wanted more money to cover the cost and the
   volatility of the value of the car (similar to implied volatility for put
   options).
3. The insurance company bought back your old insurance plan (like buying a
   sold put).
4. You bought the new insurance plan (like buying a new put).

## Too fast, too furious

You're on the freeway in your classic car and you weren't paying attention to
the speed limit. A police officer saw you, pulled you over, and issued you a
big ticket which included reckless driving.

It's time to renew your insurance policy again. But now, the insurance company
wants $1,500 to insure your $30,000 car. Why are you paying more for the same
amount of insurance coverage?

The insurance company was notified about your massive speeding ticket and they
believe that increased the chances of your car being involved in an accident.
They want more money from you because there's a higher chance of the value of
your car going down drastically (due to an collision).

This happens with options trades, too. When there's a bigger chance of a swing
in the price of a stock, the implied volatility goes up. That means it's more
expensive to buy options and that selling options pays out more premium (just
like the car insurance company could charge extra). The insurance seller (put
seller) is taking more risk by selling insurance (puts) and demands to be paid
more for it.

## It wasn't my fault!

You learned from your speeding ticket, which is good, but you ran a red light
in town and collided with another car! Luckily everyone was okay, but your car
is in terrible shape. It will need a lot of repairs.

You call your insurance company to tell them about it and they send you to a
repair shop. The estimate to repair the car is $10,000. The insurance company
pays for the repairs, but they have lost money on your policy ($1,500 premium
minus $10k in repairs).

Once the repairs are finished, your insurance company says if you want to get
insured again, it's going to be $3,000 for six months. Again, volatility is in
play here. Your car went from $15k to $30k to $20k in the eyes of the
insurance company and that's plenty of volatility.

## Conclusion

Selling puts in the stock market allows you to act like an insurance agent for
traders and institutions that want to buy insurance for their stock. If you
choose high-quality companies that have good fundamentals and desirable
products, then the chances of that insurance getting a claim is relatively low.

Very risky stocks, including those that have not been trading long (think
IPOs) and those that have wild swings in value, pay out much more premium for
this insurance, but as a put seller, you are on the hook for that swing in
valuation.

Striking the right balance between the amount of premium received and the
amount of risk taken is a difficult one. Companies that have been around for a
hundred years with steady growth are not likely going down any time soon, but
there's not much premium for puts there. On the other hand, brand new
companies could swing up and down drastically and the premium is high for
those stocks.

----

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Linh Ha on Unsplash](https://unsplash.com/photos/KN8W0Q8H3gI)*
