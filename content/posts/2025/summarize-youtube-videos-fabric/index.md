---
author: Major Hayden
date: '2025-09-22'
summary: |
  Some of my favorite YouTube videos are really informative with lots of useful content, but I struggle to extract the most important concepts as I'm watching.
  A new tool called fabric and Claude can help.
tags:
  - ai
  - general advice
title: Summarize YouTube videos with Fabric
coverAlt: Branch of a tree with orange leaves
coverCaption: |
  Photo by <a href="https://unsplash.com/@cinematicbyfuji?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Ingmar</a> on <a href="https://unsplash.com/photos/a-close-up-of-a-branch-with-leaves-HbkzVNT2i_M?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
---

I watch plenty of YouTube videos with instructional content.
Some are related to my work while many others involve my hobbies, such as ham radio and financial markets.
Lots of them have really useful information in them, but I struggle with taking notes while I'm watching.

It turns out there's a tool for that!
During some face to face work meetings last week, a coworker showed off [fabric](https://github.com/danielmiessler/Fabric).

Let's go through how to use it with some examples.

## Installation & setup

The author, Daniel Miessler, offers lots of installation methods in the [README](https://github.com/danielmiessler/Fabric?tab=readme-ov-file#installation).
Fedora users will also need `yt-dlp` to download YouTube videos:

```bash
sudo dnf install yt-dlp
```

Next, run `fabric setup` to enter the configuration menu:

```
> fabric --setup

Available plugins (please configure all required plugins)::

AI Vendors [at least one, required]

	[1]	AIML
	[2]	Anthropic (configured)
	[3]	Azure
	[4]	Cerebras
	[5]	DeepSeek
	[6]	Exolab
	[7]	Gemini
	[8]	GrokAI
	[9]	Groq
	[10]	Langdock
	[11]	LiteLLM
	[12]	LM Studio
	[13]	Mistral
	[14]	Ollama
	[15]	OpenAI
	[16]	OpenRouter
	[17]	Perplexity
	[18]	SiliconCloud
	[19]	Together
	[20]	Venice AI

Tools

	[21]	Custom Patterns - Set directory for your custom patterns (optional)
	[22]	Default AI Vendor and Model [required] (configured)
	[23]	Jina AI Service - to grab a webpage as clean, LLM-friendly text (configured)
	[24]	Language - Default AI Vendor Output Language (configured)
	[25]	Patterns - Downloads patterns [required] (configured)
	[26]	Strategies - Downloads Prompting Strategies (like chain of thought) [required]
	[27]	YouTube - to grab video transcripts (via yt-dlp) and comments/metadata (via YouTube API) (configured)

[Plugin Number] Enter the number of the plugin to setup (leave empty to skip):
```

In my case, I did the following:

* Option 2: Anthropic (Claude Opus)
* Option 21: Download the patterns (prompts for the LLM)
* Option 22: Set Anthropic as the default AI vendor
* Option 27: YouTube setup with an [API key from Google](https://developers.google.com/youtube/v3/getting-started)

Now it's time to summarize some videos!

## Basic summarization

There are [lots of patterns](https://github.com/danielmiessler/Fabric/tree/main/data/patterns) in the repository to choose from, but let's just use the `summarize` pattern for now.
One of my favorite people on YouTube for information on financial markets is [Chris Ciovacco](https://www.youtube.com/user/CiovaccoCapital).
He publishes videos weekly on Fridays with lots of inter-market analysis and some helpful trading psychology reminders.

His most recent video has this URL:
```
https://www.youtube.com/watch?v=eFiLaRNw8XM
```

We can use the video URL with fabric to get a summary:
```bash
> fabric -y "https://youtube.com/watch?v=eFiLaRNw8XM" \
    --stream --pattern summarize
```

And the summary:
```
ONE SENTENCE SUMMARY:
Market analysis shows strong uptrend intact with multiple bullish signals supporting potential continued gains through 2029-2033.

MAIN POINTS:

1. Fed cut rates 25 basis points with additional cuts likely in pipeline
2. Market could fall 3-14% without damaging existing uptrend from April low
3. Fed cuts within 1% of highs historically led to gains 16/16 times
4. Dow stocks breadth thrust signal triggered, historically very bullish long-term indicator
5. NASDAQ breadth signals show consistent positive returns over 1-5 year periods
6. Multiple technical indicators suggest keeping open mind about strong outcomes
7. S&P 500 RSI above 45 for 102 days indicates short-term overbought conditions
8. Bank of America predicts secular bull market lasting until 2029-2033
9. Current uptrend remains intact based on volume-weighted average price levels
10. Weight of evidence approach favors patience over frequent trading decisions

TAKEAWAYS:

1. Stay patient during normal 3-14% pullbacks as they won't damage the uptrend structure
2. Multiple rare breadth thrust signals historically produced excellent 1-5 year returns
3. Fed rate cuts near market highs have perfect historical track record of gains
4. Short-term overbought conditions may cause 2% drop but shouldn't affect long-term strategy
5. Secular bull market could extend to 2029-2033 based on historical data patterns
```

This is accurate and it gives me some good tidbits of information as I think about placing trades for the next week.

What actually happened here?

1. Fabric downloaded the transcript of the video using `yt-dlp`.
2. It sent the transcript to Claude Opus with a prompt asking for a summary.
3. Claude Opus returned the summary, which fabric printed to the terminal.

## Extracting wisdom

There are so many patterns that come with fabric, but one of my other favorites is `extract_wisdom`.
Here's the same video as before, but now with the new pattern:

```bash
> fabric -y "https://youtube.com/watch?v=eFiLaRNw8XM" \
    --stream --pattern extract_wisdom
```

There's much, much more detail here:
```
# SUMMARY

Stock market analyst reviews Fed rate cuts, technical analysis, and historical data suggesting strong upside potential through 2029-2035 secular bull market.

# IDEAS

- Fed cut rates 25 basis points with additional cuts likely in pipeline ahead
- Market could fall 3-14% without damaging existing uptrend from April low significantly  
- When Fed cuts within 1% of S&P highs, market higher year later 16/16 times
- Average gain nearly 15% when Fed cuts near all-time market highs historically
- Dow stocks breadth thrust above 85% after oversold readings signals strong performance ahead
- After similar breadth signals, S&P 500 higher one year later in every instance recorded
- Median gain 16.2% one year after Dow breadth thrust signals trigger historically
- Three-year returns average 41.45% after rare Dow breadth thrust signals trigger successfully
- Five-year returns average 82% after Dow breadth thrust signals with 76% median gain
- NASDAQ breadth thrust signals just triggered in September 2025 for first time recently
- After NASDAQ breadth signals, one-year median gains reach 18% with 17% average historically
- Three years after NASDAQ signals, every case shows gains with 48% average return
- Five years after NASDAQ signals, every case higher with 84% average gain recorded
- NASDAQ 200-day breadth moves rare but produce 15% one-year gains on average
- Two years after NASDAQ 200-day signals, market gains average over 34% consistently
- Four years after NASDAQ signals, every case higher with 56% average and median
- S&P 500 RSI above 45 for 102 days represents one of longest streaks ever
- After similar RSI streaks, market drops 2.17% average over following two weeks
- Bank of America predicts secular bull market lasting until 2029 or 2033 timeframe
- Secular bull market could extend to 2034-2035 based on historical data patterns
- Midcap relative performance made new 52-week low despite bullish breadth signals recently
- Midcap underperformance by 73% week-to-date following Fed meeting and rate cut
- Volatility remains necessary evil for capturing satisfying long-term investment gains and compounding
- Weight of evidence approach requires flexible, unbiased and open mind for decisions
- Patient investors holding during uptrends benefit when markets make new higher highs

# INSIGHTS

- Historical Fed rate cuts near market peaks consistently predict positive one-year market performance
- Breadth thrust signals across multiple indices suggest broad market participation and strength ahead
- Short-term overbought conditions create minor pullbacks within larger secular bull market trends
- Weight of evidence approach balances bullish signals with realistic volatility expectations for investors
- Secular bull markets driven by demographics can extend much longer than typical expectations
- Technical analysis provides objective framework for distinguishing volatility from trend damage assessment
- Multiple independent signals converging suggests higher probability of sustained market uptrend continuation
- Patient long-term investors benefit most from riding out normal volatility within uptrends
- Historical data patterns repeat with remarkable consistency across different market cycle periods
- Professional investment firms reach similar conclusions when analyzing same objective historical data sets

# QUOTES

- "The market could backtrack quite a bit here. It wouldn't do a lot of damage to the existing uptrend."
- "When the Fed cuts rates within 1% of an S&P 500 all-time high, they've done so 16 times historically."
- "In every single case, 16 for 16, the S&P 500 was higher a year later from the date of the cut."
- "It's very very easy to see green tables and believe that the market is never going to go down again."
- "Volatility is a necessary evil. The ability to ride out volatility is a necessary evil."
- "We're thinking in probabilities rather than certainties."
- "Bank of America came out recently and said that we're in a secular bull market that could last until 2029 or 2033."
- "The objective of all of this is to make money."
- "We don't want to get caught off guard if the market falls 2% over the next two weeks."
- "We want to continue to make decisions based on the weight of the evidence."
- "The only way that we can use the weight of the evidence effectively is if we head into next week and every week with that flexible, unbiased and open mind."

# HABITS

- Monitor health of existing market trends using multiple technical analysis reference points daily
- Use anchored volume weighted average price lines to assess uptrend integrity continuously
- Prepare mitigation strategies in advance for various market pullback scenarios and percentage levels
- Focus on weight of evidence approach rather than single indicators for investment decisions
- Maintain fully invested positions during confirmed uptrends to maximize long-term compound growth
- Trade less rather than more in bull markets to minimize taxable events
- Study historical precedents and patterns to maintain realistic expectations about market volatility
- Review breadth data across multiple indices to assess broad market participation levels
- Analyze relative performance between asset classes to identify leadership and lagging sectors
- Maintain flexible, unbiased mindset when interpreting conflicting market signals and data points
- Prepare mentally for normal volatility to avoid emotional decision-making during market stress
- Use multiple timeframes from weeks to years when analyzing investment performance expectations
- Document and track rare market signals to build database of historical precedents
- Balance bullish signals with bearish data to maintain realistic market outlook perspectives
- Consult multiple professional sources to validate independent analysis and investment thesis conclusions

# FACTS

- Fed has cut rates within 1% of S&P highs 16 times with 100% success rate
- S&P 500 RSI stayed above 45 for 102 straight days, longest streak in history
- After similar RSI streaks, market drops average 2.17% over following two weeks historically
- Dow breadth thrust signals occurred only handful of times since 2001 market data available
- NASDAQ breadth signals show 86% success rate one year later with 18% median gains
- After NASDAQ 200-day signals, four-year performance shows 100% success rate with 56% gains
- Midcap performance relative to S&P 500 recently made new 52-week low this year
- Bank of America predicts secular bull market lasting until 2029 or 2033 based on data
- Dotcom bear market lasted approximately three years from 2000 peak to 2003 retest
- S&P 400 midcap new high/low data available going back only to 2010 currently
- NASDAQ 100 breadth data extends back to 2002 for historical comparison analysis purposes
- Current market uptrend began from April low based on technical analysis reference points
- Fed meeting occurred Wednesday September 17th with 25 basis point rate cut announced
- Wall Street Journal reported all major indices performed well following Fed rate cut decision
- Professional investment analysis reaches similar 2034-2035 secular bull market target dates consistently

# REFERENCES

- JP Morgan historical data on Fed rate cuts near market highs
- Wall Street Journal headlines following Fed meeting coverage
- Bank of America secular bull market research and predictions
- August 8th video covering annotated chart analysis
- Last week's video on six recent stock market signals
- S&P 500, S&P 400, NASDAQ 100, and Dow Jones index data
- RSI (Relative Strength Index) technical indicator analysis
- Anchored Volume Weighted Average Price (AWOP) technical analysis tool
- 150-day and 200-day simple moving averages for breadth analysis
- Christmas Eve market low historical reference point
- COVID market crash and recovery period analysis
- Dotcom bubble and bear market historical comparison
- Financial crisis market low and recovery analysis
- 2010, 2011, 2015, 2016 market corrections and recovery patterns

# ONE-SENTENCE TAKEAWAY

Multiple historical signals suggest secular bull market continues through 2029-2035 despite normal volatility.

# RECOMMENDATIONS

- Maintain fully invested positions during confirmed uptrends to maximize long-term compound growth potential
- Use weight of evidence approach combining multiple signals rather than single indicator decisions
- Prepare mitigation strategies in advance for 3-14% pullbacks without panicking or selling positions
- Focus on one to five-year performance expectations rather than short-term two-week market movements
- Study historical precedents to maintain realistic expectations about normal market volatility patterns ahead
- Monitor breadth data across multiple indices to assess broad market participation and strength
- Keep flexible, unbiased mindset when interpreting conflicting market signals and data points consistently
- Trade less frequently in bull markets to minimize taxable events and maximize position holding
- Use technical analysis reference points to distinguish between volatility and actual trend damage
- Maintain patient approach during normal pullbacks within context of existing secular bull trends
- Analyze relative performance between asset classes to identify leadership and lagging sector rotation
- Document rare market signals to build historical database for future investment decision making
- Balance bullish signals with bearish data to maintain realistic market outlook and expectations
- Consult multiple professional sources to validate independent analysis and investment thesis development conclusions
- Prepare mentally for normal volatility to avoid emotional decision-making during temporary market stress
```

## Getting clarification

You can take any piece of the summary and query the LLM for a further explanation.
If you saved the output to a file, then you can send the output right back to the LLM using the `-a` option.

Or, you can take a small piece and ask for more detail with a pipe:

```text
> echo "How do I do this myself on TradingView? Analyze relative performance between asset classes to identify leadership and lagging sector rotation" | fabric --stream
Here's how to analyze relative performance and sector rotation on TradingView:

## 1. **Set Up Multi-Asset Comparison Charts**

### Basic Relative Performance Setup:
1. Open a new chart
2. Click the "Compare" button (or press "+" next to symbol)
3. Add multiple assets you want to compare
4. Switch to "Percentage" scale (right-click Y-axis → Percentage)

### Key Asset Classes to Compare:
- **Equities**: SPY, QQQ, IWM, EFA, EEM
- **Bonds**: TLT, IEF, HYG, LQD
- **Commodities**: GLD, SLV, DBC, USO
- **Sectors**: XLF, XLK, XLE, XLV, XLI, XLU, etc.

--- SNIP ---

```
