---
title: Customize LDAP autocompletion format in Thunderbird
author: Major Hayden
type: post
date: 2017-07-18T18:08:42+00:00
url: /2017/07/18/customize-ldap-autocompletion-format-in-thunderbird/
featured_image: /wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427.jpg
categories:
  - Blog Posts
tags:
  - email
  - javascript
  - ldap
  - linux
  - thunderbird

---
[<img src="/wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427.jpg" alt="Mailbox" width="1024" height="350" class="aligncenter size-full wp-image-6778" srcset="/wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427.jpg 1024w, /wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427-300x103.jpg 300w, /wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427-768x263.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]Thunderbird can connect to an LDAP server and autocomplete email addresses as you type, but it needs some adjustment for some LDAP servers. One of the LDAP servers that I use regularly returns email addresses like this in the thunderbird interface:

```


The email address looks fine, but I'd much rather have the person's full name instead of the username. Here's what I'm looking for:

```


In older Thunderbird versions, setting `ldap_2.servers.SERVER_NAME.autoComplete.nameFormat` to `displayName` was enough. However, this option isn't used in recent versions of Thunderbird.

## Digging in

After a fair amount of searching the Thunderbird source code with `awk`, I found a mention of `DisplayName` in [nsAbLDAPAutoCompleteSearch.js][2] that looked promising:

```
// Create a minimal map just for the display name and primary email.
      this._attributes =
        Components.classes["@mozilla.org/addressbook/ldap-attribute-map;1"]
                  .createInstance(Components.interfaces.nsIAbLDAPAttributeMap);
      this._attributes.setAttributeList("DisplayName",
        this._book.attributeMap.getAttributeList("DisplayName", {}), true);
      this._attributes.setAttributeList("PrimaryEmail",
        this._book.attributeMap.getAttributeList("PrimaryEmail", {}), true);
    }
```


Something is unusual here. The LDAP field is called `displayName`, but this attribute is called `DisplayName` (note the capitalization of the _D_). Just before that line, I see a lookup in an attributes map of some sort. There may be a configuration option that is called `DisplayName`.

In Thunderbird, I selected **Edit > Preferences**. I clicked the **Advanced** tab and then **Config Editor**. A quick search for _DisplayName_ revealed an interesting configuration option:

```


## Fixing it

That's the problem! This needs to map to `displayName` in my case, and not `cn,commonname` (which returns a user's username). There are two different ways to fix this:

```
# Change it for just one LDAP server
ldap_2.servers.SERVER_NAME.attrmap.DisplayName: displayName
# Change it for all LDAP servers by default (careful)
ldap_2.servers.default.attrmap.DisplayName: displayName
```


After making the change, quit Thunderbird and relaunch it. Compose a new email and start typing in the email address field. The user's first and last name should appear!

 [1]: /wp-content/uploads/2017/07/1280px-Mailbox_USA-e1500401199427.jpg
 [2]: https://dxr.mozilla.org/comm-central/source/mailnews/addrbook/src/nsAbLDAPAutoCompleteSearch.js#232-233
