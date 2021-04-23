---
title: Free resources for the stock market
author: Major Hayden
type: post
date: "2021-04-22"
slug: free-resources-for-the-stock-market
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: free-resources-for-the-stock-market
  description: >-
    Investing in stock or trading options is complicated, but there are plenty
    of free resources available to make research easier.
  image: images/2021-04-22-free-stock-market-resources-vienna.jpg
categories:
  - Blog Posts
tags:
  - investing
  - options
---

{{< figure src="/images/2021-04-22-free-stock-market-resources-vienna.jpg" alt="Vienna, Austria skyline" position="center" >}}

Every new trader in the stock market must wade through a myriad of tools,
platforms, and websites that claim to have the best stock market research
around. Some are free, some are not, and some cost so much that they eat into
plenty of your profits.

This post rounds up all of the best research options out there that you can
have for free (or almost free). I'm sure I missed a few, but these are the
ones I rely on most often.

## Charting

It's difficult to beat the charting features on [Yahoo! Finance]. Load up a
particular stock, fund, or index and click on *Full screen* above the small
chart. Take a look at the [chart for SPY] and click *Indicators* at the top
left. You get tons of options for the basics, such as moving averages and
relative strength index (RSI), and you get plenty of more advanced indicators
as well. You can share the charts directly from the site.

My runner-ups in charting include:

* [StockCharts]: The [basic charts](https://stockcharts.com/h-sc/ui?s=SPY)
  from StockCharts are great and the new [ACP
  platform](https://stockcharts.com/acp/?s=SPY) is useful, too. *(ACP has
  limitations without a paid account.)*
* [TradingView]: Charts on TradingView are gorgeous, but there are limitations
  on the number of indicators on a free account.
* [Finviz]: The [automated technical analysis charts] are helpful when you're
  in a hurry.

[Yahoo Finance]: https://finance.yahoo.com/
[chart for SPY]: https://finance.yahoo.com/chart/SPY
[StockCharts]: https://stockcharts.com/
[TradingView]: https://www.tradingview.com/
[Finviz]: https://finviz.com/
[automated technical analysis charts]: https://finviz.com/quote.ashx?t=SPY&ty=c&ta=1&p=d

## Research

My favorite research choice may be surprising, but it's [Fidelity]. They have
tons of research, guidance, screeners, analyst reports, and more. Finding all
of the information can be challenging at times because the interface changes
depending on the information you are viewing. It feels like some of the pages
are left over from an old system, but the information is still very useful.

Fidelity will require you to have an account before you can use the research
tools, but this is probably as simple as setting up a brokerage account and
making a small deposit. I already have a couple of accounts there for
work-related investments and this gives me full access to their research
tools.

There's no API access and some of the data is a little sluggish to be updated,
but the information is useful even for shorter term investors and traders.

As for the research runner-ups:

* [Barchart]: Stock research, earnings information, charting, technical
  analysis, and more are available on Barchart. You can access plenty of data
  for free, but they have paid accounts that give you more access to
  screeners. If you aren't able to get a Fidelity account where you live,
  Barchart will give you almost the same amount of information.
* [Finviz]: There's plenty of data per page on Finviz and the screeners are
  extremely fast and useful.
* [Stockrow]: It feels like a copy of Finviz in quite a few places, but it
  presents data in some different ways. They offer paid accounts, but the free
  account has plenty of data.
* [Tradytics]: It delivers a modern view of the overall market, the options
  flow, and plenty of other data. This one has paid accounts, too, but there
  are lots of free features that can help you make better decisions.
* [fintel.io]: This site gives you insight into what big hedge funds are doing
  in the market. Just keep in mind that the data is delayed (based on reports
  submitted from the funds themselves), and it's difficult to tell which side
  of the trade the hedge funds are on when they submit their forms. I like it
  better than [HedgeFollow] and [HedgeMind], but those can be useful as well.

[Barchart]: https://barchart.com/
[Fidelity]: https://www.fidelity.com/
[Stockrow]: https://stockrow.com/
[Tradytics]: https://tradytics.com/overall-market
[fintel.io]: https://fintel.io/
[HedgeFollow]: https://hedgefollow.com/
[HedgeMind]: https://www.hedgemind.com/

## APIs

Most APIs for stock market data are so expensive that they're not worth
considering. However, if you don't need up-to-the-second data, there are some
free options with great data.

Yahoo! Finance has a great API for stock quotes, company information, and
options quotes. The API also has historical data that normally costs hundreds
or more from other APIs. If you use Python, the [yfinance] module is great.
You can pull it into [pandas] so you can slice and dice the data all you want.

Although Finviz doesn't have an official API, the [finvizfinance] Python
module allows you to retrieve plenty of corporate data, quotes, and charts
from Finviz.

[iexcloud] has one of the best APIs around. You can get a free account with a
decent amount of credit (if you use it wisely) and their paid plans start at
$9 per month.

[yfinance]: https://pypi.org/project/yfinance/
[pandas]: https://pandas.pydata.org/
[finvizfinance]: https://finvizfinance.readthedocs.io/en/latest/
[iexcloud]: https://www.iexcloud.io/

## News

Almost all of the previously mentioned sites have some sort of news flow
available on their site. However, [Benzinga] has a feature where you can load
up your watchlist and get near real-time data in your email inbox. You can
select the stocks you care about and the types of news and filings for each.
Their paid plan has more access to news that you won't see elsewhere, but it's
expensive.

The [SEC Edgar Filing Tracker] is a great way to track SEC filings for the
stocks you care about. You can search through filings via a simple interface
and you can set up email alerts for certain stocks.

If you are a TD Ameritrade customer, the ThinkOrSwim platform has tons of
real-time news that you can filter from within the application itself.

[Benzinga]: https://www.benzinga.com/
[SEC Edgar Filing Tracker]: https://sec.report/

## Why is all of this important?

You should trade stocks for companies you love and the companies that make
products you love. However, it's critical to understand if these companies are
generating positive cash flow, making products that build a wider moat, and
drawing the interest of institutional investors. These are just a few factors
to consider when choosing to invest or trade.

Fortunately for you, almost all of the data you need to make these decisions
can be acquired for free or at a very low cost. Good luck!

----

*Disclaimer: Keep in mind that I am not an investment professional and you
should make your own decisions around stock research and trades. Investing
comes with plenty of risk and I'm the last person who should be giving anyone
investment advice.* 😜

*Photo credit: [Jacek Dylag on Unsplash](https://unsplash.com/photos/5SjAaqqCCmY)*
