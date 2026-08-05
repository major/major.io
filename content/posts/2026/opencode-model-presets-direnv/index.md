---
author: Major Hayden
date: '2026-08-05'
summary: >
  Some LLMs are better at some tasks than others.
  With a little tinkering, you can select your preferred models automatically in OpenCode based on the directory you're working in.
tags:
  - development
  - opencode
title: Switch OpenCode model presets based on directory
---

I've tried lots of coding agents, such as Claude Code, Codex, Pi and OpenCode, but I keep coming back to OpenCode.
The flexible configuration, keyboard shortcuts, and visual presentation in a terminal really appeal to me.
However, I run into situations where certain sets of models and agents make sense in one software project but not another.

By combining [oh-my-opencode-slim] with [direnv], [opencode] can use different models for different projects.

[opencode]: https://github.com/anomalyco/opencode
[oh-my-opencode-slim]: https://github.com/alvinunreal/oh-my-opencode-slim
[direnv]: https://direnv.net/

# Quick oh-my-opencode-slim overview

I was a huge fan of oh-my-opencode (later renamed to [oh-my-openagent]) in the past because it combined a really easy to use agent workflow with lots of helpful skills.
Getting in and out with simple tasks was fine, but if you needed to do some log coding sessions or some deep analysis, it offered some excellent tooling.
**But oh boy, it consumed a lot of tokens.**

I found [oh-my-opencode-slim] a little later.
At first, it looks like a similar agent suite to oh-my-openagent, but it takes a different approach to working with code.
Sure, it will integrate with your multiplexer, such as tmux or zellij, just like oh-my-openagent.
It also comes with a few good agents.

The big thing I like about it is that you can set agent _presets_.

[oh-my-openagent]: https://github.com/code-yeongyu/oh-my-openagent

# Presets in oh-my-opencode-slim

Presets are groups of models that you prefer using to power the various agents.
These models can be mixed and matched between providers, so if you have OpenAI and Anthropic accounts, you can have Sonnet 5 power one agent and then use GPT 5.6 Terra with another.
It also offers fallbacks in case a model is unavailable or the API endpoint is overloaded (or you ran out of token budget).

Here's an excerpt of my configuration where Anthropic is the primary provider with Google's Vertex AI as a backup:

```json
"presets": {
  "anthropic": {
    "orchestrator": {
      "model": [
        "anthropic/claude-sonnet-5",
        "google-vertex/claude-sonnet-5@default"
      ],
      "variant": "medium",
      "skills": [
        "*"
      ],
      "mcps": [
        "*",
        "!context7"
      ]
    },
    "oracle": {
      "model": [
        "anthropic/claude-opus-5",
        "google-vertex/claude-opus-4-6@default"
      ],
      "variant": "high",
      "skills": [
        "simplify"
      ],
      "mcps": []
    },
    "librarian": {
      "model": [
        "anthropic/claude-haiku-4-5",
        "google-vertex/claude-haiku-4-5@20251001"
      ],
      "variant": "low",
      "skills": [],
      "mcps": [
        "websearch",
        "context7",
        "gh_grep"
      ]
    },
    "explorer": {
      "model": [
        "anthropic/claude-haiku-4-5",
        "google-vertex/claude-haiku-4-5@20251001"
      ],
      "variant": "low",
      "skills": [],
      "mcps": []
    }
  }
```

When I exceed my Anthropic budget, oh-my-opencode-slim begins sending requests to Vertex AI instead for each agent.
Certain agents can see certain MCP servers while other agents cannot.
This keeps agent concerns separate and reduces token usage especially for agents that don't need to access any MCP server to do their work.

All of your presets go into your `~/.config/opencode/oh-my-opencode-slim.json` file and you can set a system-wide default preset there.

You can adjust the system-wide preset inside a running instance of opencode by running the `/preset` command.
This changes the preset in the config file and you must restart opencode for the change to take effect.

There's one more handy way for setting presets: an environment variable!
Run `export OH_MY_OPENCODE_SLIM_PRESET=your-preset-name` before starting opencode to set the preset for the entire session.
For a one-off preset switch, run `OH_MY_OPENCODE_SLIM_PRESET=your-preset-name opencode`.

How can we automatically export an environment variable based on the git repository we're using right now?
That's where `direnv` comes in!

# What's direnv?

[direnv] is a handy executable that loads and unloads environment variables depending on which variable you're sitting in right now.
It looks for an `.envrc` file in the current directory, and if it doesn't find one, it walks up to parent directories looking for one.
It loads the first one that it finds.

If you want to try out `direnv` now, be sure to run `direnv allow` in the directory you want to use it in.

# Configuring presets per directory

On my system, I have my git directories set up like this: `~/git/<github_gitlab_org>/<github_gitlab_repo>`.
I added some `.envrc` files:

* In `~/git/major`, I have a `.envrc` file that contains`export OH_MY_OPENCODE_SLIM_PRESET=opencode-go`.
* In `~/git/other_org`, I have a `.envrc` file that contains `export OH_MY_OPENCODE_SLIM_PRESET=anthropic`.

These presets correspond to presets in my oh-my-opencode-slim configuration.
If I switch into `~/git/major/major.io` (the source code for this blog), direnv will automatically load the `.envrc` file and set `OH_MY_OPENCODE_SLIM_PRESET` to `opencode-go`.
If I switch into `~/git/other_org/other_repo`, direnv will automatically load the `.envrc` file and set `OH_MY_OPENCODE_SLIM_PRESET` to `anthropic`.

This means I can launch `opencode` from any git repository without worrying which model preset is being used.
You can also put these `.envrc` files into the git repo directory as well if you need to override the organization preset for a specific repository.

But there's one step that remains: telling my shell that `direnv` should be used.

# Configuring the shell

I use zsh with [oh-my-zsh](https://ohmyz.sh/), so adding direnv is as simple as adding `direnv` to my `plugins` array in `.zshrc`.
Refer to the [direnv shell hook instructions](https://direnv.net/docs/hook.html) for instructions on how to set up the shell hook for your shell.

⚠️ Remember to reload your shell config or open a new shell session after setting up the hook.
