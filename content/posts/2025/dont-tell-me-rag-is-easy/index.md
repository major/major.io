---
author: Major Hayden
date: '2025-04-18'
summary: |
  Retrieval-augmented generation (RAG) is helpful for AI workflows, but it
  certainly is not easy.
tags: 
  - 4runner
  - repair
  - toyota
title: Don't tell me RAG is easy
coverAlt: Small plants growing on a sandy surface
coverCaption: |
  [Annie Spratt](https://unsplash.com/photos/brown-grass-on-white-sand-during-daytime-FuTY0Q6OQmM) via Unsplash
---

Blog posts have been moving slowly here lately and much of that is due to work demands since the end of 2024.
I've been working on an AI-related product with a talented team of people and we learned plenty of lessons about retrieval-augmented generation, or RAG.

This post covers the basics of RAG, some assumptions I made, and what I've learned.

## What is RAG?

Large language models, or LLMs, are trained on huge amounts of information.
This information could come from just about anywhere, including books, online resources, and even this blog!
There are plenty of ethical questions here, especially around LLM providers that train their models on copyrighted or otherwise restricted material.
They gain ground on their competitors in the short run, but this is not ideal in the long run.

Sometimes training a model isn't feasible.
That's where RAG comes in.

**Training a model is *expensive*.**
It requires lots of very expensive hardware that consumes a significant amount of electricity.
This makes RAG ideal for speeding up development at a lower cost.
Developers can quickly update or change RAG data for information that changes rapidly, such as sports statistics, and it avoids the hassle of constantly training a model on new information.

A very simple workflow for RAG would be something like this:

1. Someone asks a question
2. Search for relevant information in your RAG database
3. Add the question and the RAG context to a prompt for the LLM
4. Send the whole prompt to the LLM for inference

**Step two is incredibly difficult.**

If you are embarking on the RAG journey for the first time, there's a lot you need to know at a high level.
Let's get started.

## Start with high quality documents

Imagine that you're one of the top chefs in the world.
You work in a restaurant with [Michelin stars](https://en.wikipedia.org/wiki/Michelin_Guide).
The restaurant is opening for a special Saturday night dinner and your plan is to serve a delicious piece of fish for each guest.
You already know how you plan to season the fish and how you're going to cook it.
Your sauces are all ready.

The fish arrives and when the cooler opens, you gasp.
***"What is that smell?"*** 😱

**What do you do?**
You have hungry guests on the way.
Your sauce is exquisite and you know you can cook the fish perfectly.
But how are you supposed to deal with fish that has gone bad along the way?

This is likely the first step in your RAG journey: **source document quality.**

You might run into quality issues like these:

* Widely varying document structures or markup
* Documents written in other languages, or written in a language that isn't the author's primary language
* Large blocks of low readability text, such as kernel core dumps, command line output, or diagrams, that are difficult to parse
* Boilerplate language across multiple documents
* Metadata at the front of the document or scattered throughout
* No structure, markup, or boundaries whatsoever
* Incorrect, outdated, or problematic information

This is a **garbage in, garbage out** problem.
RAG can help you match documents to user questions, but if the documents steer the user in the wrong direction, the outcome is terrible.

You have a few options:

* Engage with the groups who created or currently maintain the information to make improvements
* Use an LLM to summarize or extract information from the documents (some LLMs are good at building FAQs from documents)
* Find the highest quality documents in the group and start with those

Once you have a document quality plan together, it's time for the next step.

## Getting documents ready for search

You have plenty of options at this step, but I've had a good amount of luck with a hybrid search approach.
This combines a vector (semantic) search along with a traditional full text search.

**Vector searches aim to capture the *meaning* behind the search rather than just looking for keywords.**
They examine how words are positioned in a sentence and which words are closest together.
These searches require a step where you convert a string of text into vectors and this can be time consuming on slower hardware.

**Keyword, or full-text, searches are cheaper and easier to run.**
They're great for matching specific keywords or an exact phrase.

When you combine both of these together, you get the best of both worlds.

The challenge here is that you need an embedding model to convert strings into a list of vectors.
Every embedding model, like an inference model, has a limit on how much text that it can turn into vectors in one shot.
This is called the _context window_ and it varies from model to model.

If a model has a 350 token context window, that means it can only handle 350 tokens (close to 350 words) before the model overflows.
If you put 450 tokens into this example model, it vectorizes the first 350 and skips the remaining 100.
This means you can only do a vector search across the first 350 tokens.[^token_overflow]

This is where chunking comes in.
You need to split your documents into chunks so that they fit within the context window of the embedding model.
However, there are advantages and disadvantages to larger or smaller chunks:

* Larger chunks preserve more of the text from your documents and make it easier to find document/chunk relationships.
  Your vector database is a little smaller and you can get better results from queries that are more broad.
* Smaller chunks give you a more precise retrieval and save you money at inference time since you're sending a little less context to the LLM.
  They're better for specific questions and they lower the risk of hallucination since you're providing context that is more specific.

There are _plenty of options_ to review here, especially with how you create chunks and set overlaps between the chunks.
I really like where [unstructured](https://docs.unstructured.io/open-source/core-functionality/overview) is headed with their open source library.
You can partition via different methods depending on the document type and then split within the partitions.

This avoids situations where you might put a piece of chapter one with chapter two just because that's where the chunks happened to split.
Partitioning on chapters first and then splitting into chunks keeps the relevant information together better.

## Time to search

I've talked about hybrid searches already, but there's an [excellent guide from Pamela Fox](https://pamelafox.github.io/my-py-talks/pgvector-python/) that gives you a deep dive into RAG from "I know nothing" to "I can do things!" in 17 slides.
This is a great way to visualize what is actually happening behind the scenes for each search type.
Be prepared for calculus! 🤓

In a perfect world, your search results should:

* Return the smallest amount of matching chunks to avoid confusing the LLM (and to consume fewer tokens)
* Only provide chunks that are relevant to the user's question
* Contain all of the needed steps for a process (give all steps of a recipe instead of just the second half)
* Complete very quickly to avoid keeping the user waiting

This can be tricky with certain languages, especially English.
For example, if someone asks "How do I keep a bat from flying away?", what are they talking about?

* Are they near a bat (the flying mammal) that they want to trap and keep from flying away? 🦇
* Are they playing a game of baseball and the bat keeps slipping from their hands as they swing? ⚾

Vector searches help a lot with these confusing situations, but they're not perfect.
Let's look at a way to improve them next.

## Refine the user's question

If you can budget some extra tokens to refine the user's question prior to searching, you can improve your RAG searches substantially.

Let's keep the last example going and assume you have an AI service that handles baseball questions.
In your case, you could take the user's question and clarify it using an LLM.
Here's an example prompt (that is totally untested):

```
You are a helpful AI assistant and an expert in the game of baseball.
Use the question provided below to create five questions which are
more specific and relevant to baseball terminology.

Question: How do I keep a bat from flying away?
```

The LLM might reply with something like this:

```
1. How can I keep my hands tacky so the bat will stay in my hands
   when I swing?
2. How can I keep a better grip on a bat when my hands are sweaty?
3. What coverings or other materials can I add to a bat to get
   a better grip?
4. Can I adjust my swing to avoid losing my grip on the bat?
5. Are there exercises I can do to avoid letting the bat go when
   I swing?
```

These refined questions offer more ways for vector searches to match document since there is more meaning to search through.
LLMs often add more relevant keywords to the questions and that can be helpful for keyword searches, too.

You can then adjust your workflow to something like this:

1. Receive a question from the user
2. Refine the question using an LLM
3. Use the refined questions to search the RAG database
4. Add the context and the **original question** to the prompt (we want to maintain the user's original intent!)
5. Send the prompt to the LLM

LLMs can hallucinate and make bad choices, so always send the user's original question to the LLM rather than the refined questions.
If the LLM hallucinates on the question refinement step, the issue is contained to the RAG search rather than the RAG search and inference.

## Extra credit

There are plenty of ways to tweak this process depending on your time and budget.

### Categories
You can break your documents into categories and infer what the user is asking about to narrow your search.
Imagine you needed to answer questions for all sports.
You might break up your documents into categories for each sport and you could limit your searches to that sport.
An LLM might be able to help you quickly determine which sport the user is asking about and then you can narrow your RAG search to only that sport.

### Get the whole document
Let's day you do a RAG hybrid search and your top 10 results brings back 7 chunks from the same document.
In that case, that entire document or portion of the document is likely really useful for the user.
You might want to build in some functionality that retrieves the whole document, or perhaps the whole chapter/section, in these situations and sends it to the LLM.

### Prioritize documents
Certain documents in your collection might have a higher priority over others.
For example, if you have support teams that track which documents they refer customers to most often, those documents should be weighted higher in your results.
You might be able to examine web traffic to tell you which articles on your site are accessed most often.
Those documents would be great for a higher weight.

### Links to source
Document quality issues might lead you to put short summaries of documents in your RAG database.
Adding a source link to the original page is helpful because an LLM would be able to answer the question at a high level and refer the user to a specific page for a deeper dive.

### RAFT

RAG and fine tuning (RAFT) is another good option if your budget allows for it.
You can train your LLM on your high quality documents (quality is more important with RAFT) and provide additional documents via RAG when needed.
For example, you might fine tune your model on sports data from last season and earlier.
You could then provide the current season's data via RAG.
This gives you great responses on historical data while allowing you to quickly update your current data with the latest games.

## Summary

**RAG isn't easy.** 😂

Don't let anyone tell you it's easy.
You would never take a stack of documents, cut them into pieces, throw them into a box, and put them in front of a brand new hire at your company.
Don't try to do the same thing with RAG.
RAG is a quick way to find all of the places in your organization where old data has been ignored. 🤭

Start with high quality documents that have meaningful, relevant information for your users.
Get them into a database where you can search them quickly and efficiently.

Once they're in the database, get creative about how you search them.
Simply returning relevant chunks is a good start.
From there, look to see how you can take those results and expand upon them.

Good luck in your adventure! 🧗‍♂️

[^token_overflow]: Lots of hand-waving happening here. 😆
    Every model counts tokens differently and you may need to look for a specific tokenizer to know how many tokens can fit within the window.
