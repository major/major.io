---
aliases:
- /2022/08/11/migrating-from-vscode-to-vim/
author: Major Hayden
date: '2022-08-11'
summary: Some people say I just enjoy the sound of my mechanical keyboard too much.
  🤭 I see it as a simpler, more consistent workflow.
tags:
- development
- fedora
- terminal
- vim
- vscode
title: Migrating from vscode to vim
coverAlt: Dark mountains in the background behind sandy hills in the shadows
coverCaption: >
  Photo by <a href="https://unsplash.com/pt-br/@hudsonj142?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Jason Hudson</a>
  on <a href="https://unsplash.com/photos/a-desert-landscape-with-mountains-in-the-background-wtUkQ2MrbiY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
---

Every Linux user experienced at least one "battle of the text editors" once in their lifetime.
I even participated in a few!
Text editors form the foundation of nearly every Linux user's workflow.
You need to use one eventually, whether for quick configuration file edits, developing software, or writing blog posts in markdown _(like this one)_!

An older and much wiser Linux engineer told me this early in my career:

> Everyone spends time arguing about the best text editor.
> Nobody spends time being grateful that we have so many great choices!

He was totally right.
Sometimes we quickly forget about the benefits of choice in open source software.

But before I could say anything else, he said:

> And, naturally, emacs is the best editor out there, anyway.

🤦‍♂️

# Why migrate to vim?

[Visual Studio Code], or vscode, comes from Microsoft and delivers a full-featured editor and IDE with tons of plugins available.
It also offers plenty of extensions that enable extra functions for certain file types and merges testing output into the same interface.

However, newer releases performed poorly on my machine.
I spent too much time going through extensions to find out which one was causing the performance drops.
Then I noticed that my extension usage had gone way overboard and I wasn't vetting new extensions as I should have.

[Privacy questions] came up from time to time, too.
Switching to something like [vscodium] helped with the privacy issues but the slowdowns from extensions came right back.

What really pushed me over the edge was *inconsistency*.

Whenever I made edits of system configuration files, wrote comments in git commits, or made a quick change in a text document, I was in vim.
I began packaging more software in Fedora and it was much quicker to open a spec file in vim, make commits, and test my changes.
My vim configuration file grew as I changed settings to make edits easier and I loaded a few plugins (with [vim-plug]).

I found myself opening vscode less and less often.
I was gradually improving my skills in vim with visual selections, copy/paste, and moving quickly through files _(oh how I love using curly braces to jump between ansible tasks)_.
Did I make mistakes?
Oh, yes.
And if anyone was watching over my shoulder, it would have been hilarious (for them).

New adventures outside my comfort zone are always fun for me, so I embarked on a migration to vim as my full time editor.

[Visual Studio Code]: https://code.visualstudio.com/
[Privacy questions]: https://dev.to/destroyer22719/vscode-collects-data-from-its-users-here-s-how-to-disable-that-14g7
[vscodium]: https://vscodium.com/
[vim-plug]: https://github.com/junegunn/vim-plug

# Initial challenges

Old habits die hard.

My muscle memory of running `code -n .` kept kicking in when I went to edit something, so I removed vscode from my system entirely.
Just like throwing out the cookies as you start a diet, there's no going back now.

## File manager

I struggled with replicating the file manager component of vscode that runs down the left side.
My dependency on that file list was *deep*.
I stumbled upon a blog post called [Oil and vinegar - split windows and the project drawer] that argued against some of the file manager drawer designs.

A friend showed me [fzf] and the corrsponding vim plugin, [fzf.vim].
At first, I was totally lost.
Then I found a video from [samoshkin] that [explained how to use fzf] with the zsh shell as well as vim.

{{< youtube qgG5Jhi_Els >}}

It's now a critical part of my workflow in large projects.
If I know the filename, I type `:Files`, press enter, and search for the file.
If I know what's in the file, I type `:Ag`, press enter, and type search strings to match files.

[Oil and vinegar - split windows and the project drawer]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
[fzf]: https://github.com/junegunn/fzf
[fzf.vim]: https://github.com/junegunn/fzf.vim
[samoshkin]: https://github.com/samoshkin
[explained how to use fzf]: https://www.youtube.com/watch?v=qgG5Jhi_Els

## Spell checking

Vim makes it easy to write markdown, but I missed the spell checking in vscode.
Luckily vim has built-in spell checking and a friend showed me how to set up a toggle that turns it on and off:

```vimrc
noremap <silent><leader>S :set spell!<CR>
```

The default `leader` key is the backslash, so I can hit backslash followed by a capital S to enable spell checking.
Hitting the same keys (backslash, then capital S) turns the spell checking off.
I leave spell checking off by default and enable it just before publishing when I do my proofreading.
It reduces distractions while I'm writing.

## Colors

The [solarized-dark] theme has been my workhorse for years and it's easy on my eyes.
I found some vim examples online and the author was using the [nord] theme.
It's a blend of blues and light greys that gives me a little more contrast while still being easy on my eyes during the workday.

I started with a few plugins:

```vimrc
call plug#begin()
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
```

This adds support for the nord theme for all of vim as well as for [vim-airline] (an awesome vim status bar plugin).
I enabled nord by default as well:

```.vimrc
" Colors
colorscheme nord                               
highlight Comment ctermfg=darkgray cterm=italic
let g:airline_theme='nord'
```

The `ctermfg-darkgray` helps improve contrast for some of the darkest colors and `cterm=italic` makes comments italicized.

[solarized-dark]: https://ethanschoonover.com/solarized/
[nord]: https://www.nordtheme.com/
[vim-airline]: https://github.com/vim-airline/vim-airline

## My vim configuration

I manage all of my dotfiles with [chezmoi] and you can get my current `.vimrc` file in my [dotfiles repository].

To use my config as-is, follow these steps:

* Download the file and store it as `~/.vimrc` in your home directory.
* Ensure you have `ag`, `fzf`, and `ripgrep` installed for fuzzy finding.
* Install [vim-plug]
* Open vim, type `:PlugInstall`, and press enter.
* Close vim and re-open it.
* Enjoy!

Look for more vim-related posts here as I get more comfortable with vim and find more time-saving ideas. 🤓

[chezmoi]: https://www.chezmoi.io/#considering-using-chezmoi
[dotfiles repository]: https://github.com/major/dotfiles/blob/main/dot_vimrc