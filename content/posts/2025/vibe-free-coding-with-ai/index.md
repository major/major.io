---
author: Major Hayden
date: '2025-05-07'
summary: |
  Yes, I do write code with help from an LLM, but I wouldn't call it vibe coding.
  Let's dig into how _(and why)_ I do it. 🤖
tags: 
  - ai
  - general advice
  - vscode
title: Vibe-free coding with AI
coverAlt: Extremely cute french bulldog looking out the window of a Jeep Wrangler
coverCaption: |
  Photo by <a href="https://unsplash.com/@karsten116?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Karsten Winegeart</a> on <a href="https://unsplash.com/photos/dog-looks-out-the-window-of-a-car-Y6AcV8Qdafw?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>   
---

The internet has been in quite a ruckus about _vibe coding_ recently.
Heck, there's already a [Wikipedia] page about it!
It must be real if it has a Wikipedia page! 😆

Long story short, vibe coding involves asking a large language model (LLM), the foundation of an AI platform, to write code for you.
LLMs are actually quite good at writing code.
It turns out that they're often terrible at understanding nuance or stitching complex code relationships together.

I use AI all the time when I write software, but I wouldn't call it _vibe coding_.
LLMs in my development environment help me catch errors more quickly, highlight improvements, and reduce time spent on very tedious tasks.

This post covers my use cases for AI while writing code and my current setup.

[Wikipedia]: https://en.wikipedia.org/wiki/Vibe_coding

# My setup

About 90% of my development happens in Visual Studio Code, or VS Code.
The rest is in vim. 
There's a helpful [GitHub Copilot extension for VS Code] that integrates really well to help with errors, give auto-complete suggestions, and answer questions.

GitHub offers a totally free GitHub Copilot subscription, but if you're a maintainer of a popular open source project or an avid open source contributor, they currently offer [Pro subscriptions] at no cost.
This free Pro offering could change at any time, so be prepared for that. 😉

[GitHub Copilot extension for VS Code]: https://code.visualstudio.com/docs/copilot/overview
[Pro subscriptions]: https://docs.github.com/en/copilot/managing-copilot/managing-copilot-as-an-individual-subscriber/getting-started-with-copilot-on-your-personal-account/about-individual-copilot-plans-and-benefits

# AI use cases

I use AI in several different ways when I write code.

## Fixing errors

Most of my development is done in Python and I'm almost always coding with `ruff` and `mypy`.
This means that I run into some linting problems from time to time and sometimes I forget to put a type annotation for functions or arguments.
Existing non-AI plugins catch most of these mistakes and usually the fixes are easy.
Sometimes they're difficult.

For those difficult times, it's handy to ask for some AI help, especially when I haven't used a specific python module before.
VS Code gives me a little sparkle emoji underneath the function name and offers to fix the problem for me.

This has helped recently at work as I've worked with llama-index extensively and determining which type is returned from a function can be challenging.
Sometimes it's a base model being returned, but sometimes it's a different class that inherits a base class.
Sure, I could dig through documentation or wade through the llama-index code for that, but that's tedious work.
I'd rather get a suggestion from Copilot and confirm that it's correct.
That's a lot easier than digging through the code to find the right answer.

## Understanding

How many times have you been working on a complex project and you think:

> Who wrote this?
> I have no idea what's going on.
> Why is this even here?

I'll often highlight the code in question and ask for an interpretation from the LLM.
Since Copilot has access to more files in the project, it's able to connect the dots with functions and methods from other files.

This helps me better understand the project in less time.
It also helps me learn new methods for doing things (even if those methods might be terrible).

## Testing

Errors sometimes still sneak into the code even with careful linting and strict type checking.
I'll often ask Copilot to write a test for a function for me with branch coverage.
Branch coverage catches those situations where code might be skipped based on an `if`/`else` clause and it ensures you're testing all possible code paths.
Sometimes Copilot will write a test that checks a condition I didn't consider.
That's a great opportunity to return to the original code and think through the logic once more.

There are other situations where a test fails and it's difficult to understand why.
I'll usually bring up the test on the right and the code on the left to think through the code path in my head.
Then there are those times where I ask Copilot to give a suggestion and it points to the exact spot in my code where I didn't consider a specific condition.
Strings and byte strings catch me offsides quite often. 🤭

## Improvements

We've all been in that situation where we know what needs to be done, we write a few functions, and then think "Gosh, that seems like too much code" or "That looks convoluted".
I'll sometimes ask Copilot for a suggestion to simplify a function or block of code.
I rarely take the whole suggestion, but it reminds me of patterns I've forgotten or it introduces me to new ones I haven't seen before.

As an example, I was working on some async python code that needed to be wrapped in a timeout.
The timeout seemed to be working fine, but then the original function being awaited kept running until it timed out later.
That caused exceptions to be thrown via Sentry and it was extremely annoying.

What I really needed is a way to stop the awaited function once the timeout wrapper was reached.

I asked Copilot for help with something like:

> This function keeps running after the timeout is reached and it causes another exception.
> I need to kill the awaited function as soon as the timeout is reached.

Sure enough, Copilot came back with a suggestion to use [`asyncio.wait_for`](https://docs.python.org/3/library/asyncio-task.html#asyncio.wait_for).
I'd never seen that before!
The docs highlighted the big difference between `wait` and `wait_for`:

> If a timeout occurs, it cancels the task and raises TimeoutError.

Perfect! 🎉

## Tedious tasks

There are many occasions where Copilot guesses what I'm thinking next, especially as I build out scaffolding for a new class or write documentation for a function.
As an example, I was writing an OpenShift template last month and I was bringing over some templated `Deployment` and `Service` definitions.
I customized the template with lots of variables for the image source, environment variables, and volume mounts.

OpenShift templates have a long section at the bottom where you define the default values for the variables used in your template.
As I began typing the first variable name, Copilot suggested the variable name, a short definition, and the default value.
The default value was correct, but the description was a little off.
After a quick fix of the description, I moved to the next variable and Copilot started filling in the next one from the template.
I gradually just tab completed the remainder of the file.

Many of the descriptions needed some tweaks here and there and the default variables needed to be updated.
However, all of that structure that I'd be copying and pasting repeatedly was all done for me.
That saved me plenty of time and reduced the chance of making a syntax error.

# Conclusion

GitHub Copilot in VS Code feels like a partner that is looking over my shoulder as I work.
I can choose when to engage with a suggestion or ask for additional help.
It's also a great way to get un-stuck when you're in a tight spot.

**None of this is a replacement for fully understanding what you're being asked to write and being knowledgeable about how your application fits together.**

Some might argue that an AI coding assistant is some kind of _crutch_[^crutch].
I'd argue that this depends completely on how you use it.
If you use it to write code for you without understanding the code, then yes, it's a crutch.

If you use it to help you understand the code, catch errors, and improve your code, then it's a useful virtual partner in your coding adventures. 🧗‍♂️

[^crutch]: In the realm of US English, a crutch is a device that helps you walk when you have an injury.
    Many people use it as a metaphor for something that helps you do something you can't do on your own.
    I've had people tell me that using VS Code is a crutch.
    Some people even say that **vim** is a crutch.
    
    _"You should juse use `ed` and enjoy it!"_ 😆
