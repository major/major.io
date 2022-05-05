---
author: Major Hayden
categories:
- Blog Posts
date: '2021-07-19'
summary: >-
    Firefox allows you to set dark mode as the default without changing themes
    or changing your desktop configuration. 😎
images:
- images/2021-07-19-dark-city-street.jpg
slug: enable-dark-mode-in-firefox
tags:
- fedora
- firefox
- i3
- linux
title: Enable dark mode in Firefox without changing themes
type: post
---

{{< figure src="/images/2021-07-19-dark-city-street.jpg" alt="Dark city street in Tokyo, Japan" position="center" >}}

Most modern web browsers, such as Firefox, take cues from the desktop
environment or from themes applied to the browser to determine whether a user
wants light or dark mode from websites. This is often done through the
[prefers-color-scheme] CSS media feature:

```css
.day   { background: #eee; color: black; }
.night { background: #333; color: white; }

@media (prefers-color-scheme: dark) {
  .day.dark-scheme   { background:  #333; color: white; }
  .night.dark-scheme { background: black; color:  #ddd; }
}

@media (prefers-color-scheme: light) {
  .day.light-scheme   { background: white; color:  #555; }
  .night.light-scheme { background:  #eee; color: black; }
}
```

There are those situations where you want web pages to prefer a dark mode, but
you don't want to change your desktop settings or apply a darker theme to
Firefox. You can follow these steps to prefer dark color schemes in Firefox:

1. Type `about:config` in the address bar and press enter.
2. Click *Accept the Risk and Continue*. (if you want to accept the risk) 😉
3. In the search box, type `ui.systemUsesDarkTheme`
4. Click the *Number* radio button below the search box.
5. Press the plus (+) on the far right side.
6. Set the value to `1` and press enter.

Now, close the `about:config` page and load up a website that has dark color
schemes available.

If you want to test the change quickly, just reload this page! My blog has light
and dark color schemes set depending on what your browser prefers. 🎉 😎

[prefers-color-scheme]: https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

*Photo credit: [Andre Benz on Unsplash](https://unsplash.com/photos/qi2hmCwlhcE)*
