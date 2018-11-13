---
title: Handling terminal color escape sequences in less
author: Major Hayden
type: post
date: 2013-05-22T02:33:00+00:00
url: /2013/05/21/handling-terminal-color-escape-sequences-in-less/
dsq_thread_id:
  - 3642807277
categories:
  - Blog Posts
tags:
  - centos
  - command line
  - fedora
  - general advice
  - linux
  - red hat
  - sysadmin

---
This post is a quick one but I wanted to share it since I taught it to someone new today. When you have bash output with colors, `less` doesn't handle the color codes properly by default:

```
$ colordiff chunk/functions.php chunk-old/functions.php | less
ESC[0;32m22a23,27ESC[0;0m
ESC[0;34m>       * Load up our functions for grabbing content from postsESC[0;0m
ESC[0;34m>       */ESC[0;0m
ESC[0;34m>      require( get_template_directory() . '/content-grabbers.php' );ESC[0;0m
ESC[0;34m> ESC[0;0m
```


Toss in the `-R` flag and you'll be able to see the colors properly (no colors to see here, but use your imagination):

```
$ colordiff chunk/functions.php chunk-old/functions.php | less -R
22a23,27
>        * Load up our functions for grabbing content from posts
>        */
>       require( get_template_directory() . '/content-grabbers.php' );
>
>       /**
```


The [man page][1] for `less` explains the feature in greater detail:

```
-R or --RAW-CONTROL-CHARS
       Like -r, but only ANSI "color" escape sequences are output in "raw" form.  Unlike -r, the screen appear-
       ance is maintained correctly in most cases.  ANSI "color" escape sequences are sequences of the form:
            ESC [ ... m
       where the "..." is zero or more color specification characters For  the  purpose  of  keeping  track  of
       screen  appearance,  ANSI  color escape sequences are assumed to not move the cursor.  You can make less
       think that characters other than "m" can end ANSI color escape  sequences  by  setting  the  environment
       variable  LESSANSIENDCHARS to the list of characters which can end a color escape sequence.  And you can
       make less think that characters other than the standard ones may appear between the ESC  and  the  m  by
       setting the environment variable LESSANSIMIDCHARS to the list of characters which can appear.
```


 [1]: http://linux.die.net/man/1/less
