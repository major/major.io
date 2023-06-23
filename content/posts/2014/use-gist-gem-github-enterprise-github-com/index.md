---
aliases:
- /2014/08/08/use-gist-gem-github-enterprise-github-com/
author: Major Hayden
date: 2014-08-08 21:13:07
dsq_thread_id:
- 3642807707
tags:
- bash
- github
- ruby
title: Quickly post gists to GitHub Enterprise and github.com
---

[<img src="/wp-content/uploads/2014/08/github-150x150.png" alt="GitHub Logo" width="150" height="150" class="alignright size-thumbnail wp-image-5124" srcset="/wp-content/uploads/2014/08/github-150x150.png 150w, /wp-content/uploads/2014/08/github-300x300.png 300w, /wp-content/uploads/2014/08/github.png 560w" sizes="(max-width: 150px) 100vw, 150px" />][1]

The [gist gem][2] from GitHub allows you to quickly post text into a GitHub gist. You can use it with the public github.com site but you can also [configure it][3] to work with a GitHub Enterprise installation.

To get started, add two aliases to your `~/.bashrc`:

```
alias gist="gist -c"
alias workgist="GITHUB_URL=https://github.mycompany.com gist -c"
```


The `-c` will copy the link to the gist to your keyboard whenever you use the gist tool on the command line. Now, go through the login process with each command after sourcing your updated `~/.bashrc`:

```
source ~/.bashrc
gist --login
(follow the prompts to auth and get an oauth token from github.com)
workgist --login
(follow the prompts to auth and get an oauth token from GitHub Enterprise)
```


You'll now be able to use both aliases quickly from the command line:

```
cat boring_public_data.txt | gist
cat super_sensitive_company_script.sh | workgist
```


 [1]: /wp-content/uploads/2014/08/github.png
 [2]: https://github.com/defunkt/gist
 [3]: https://github.com/defunkt/gist#github-enterprise