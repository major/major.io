---
aliases:
- /2008/01/29/limiting-which-commands-are-kept-in-the-bash-history-file/
author: Major Hayden
date: 2008-01-29 18:33:55
dsq_thread_id:
- 3642772791
tags:
- bash
- command line
title: Limiting which commands are kept in the bash history file
---

By setting a certain bash environment variable, you can limit which commands are kept in the .bash_history file. The following options can be passed to the HISTCONTROL environmental variable:

**ignorespace** - omits commands beginning with a space

**ignoredups** - omits commands that match the previously run command

**ignoreboth** - combines **ignorespace** and **ignoredups**

**erasedups** - removes previous lines that match the line that was just run

To set it, simply run the following from the command line, or add it to the .bashrc or a single user's .bash_profile:

`export HISTCONTROL=ignorespace`

If no value is set, then all commands will be saved regardless of their content.