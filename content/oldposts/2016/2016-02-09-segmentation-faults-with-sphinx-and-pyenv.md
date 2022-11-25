---
title: Segmentation faults with sphinx and pyenv
author: Major Hayden
date: 2016-02-09T14:09:44+00:00
url: /2016/02/09/segmentation-faults-with-sphinx-and-pyenv/
dsq_thread_id:
  - 4564662885
tags:
  - development
  - fedora
  - python

---
I'm a big fan of the [pyenv][1] project because it makes installing multiple python versions a simple process. However, I kept stumbling into a segmentation fault whenever I tried to build documentation with sphinx in Python 2.7.11:

```
writing output... [100%] unreleased
[app] emitting event: 'doctree-resolved'(<document: <section "current series release notes"...>>, u'unreleased')
[app] emitting event: 'html-page-context'(u'unreleased', 'page.html', {'file_suffix': '.html', 'has_source': True, 'show_sphinx': True, 'last

generating indices... genindex[app] emitting event: 'html-page-context'('genindex', 'genindex.html', {'pathto': <function pathto at 0x7f4279d51230>, 'file_suffix': '.html'
Segmentation fault (core dumped)
```


I tried a few different versions of sphinx, but the segmentation fault persisted. I did a quick reinstallation of Python 2.7.11 in the hopes that a system update of gcc/glibc was causing the problem:

```
pyenv install 2.7.11
```


The same segmentation fault showed up again. After a ton of Google searching, I found that the `--enable-shared` option allows pyenv to use shared Python libraries at compile time:

```
env PYTHON_CONFIGURE_OPTS="--enable-shared CC=clang" pyenv install -vk 2.7.11
```


That worked! I'm now able to run sphinx without segmentation faults.

 [1]: https://github.com/yyuu/pyenv
