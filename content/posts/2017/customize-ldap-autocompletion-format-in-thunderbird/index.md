---
aliases:
- /2017/07/18/customize-ldap-autocompletion-format-in-thunderbird/
author: Major Hayden
date: 2017-07-18 18:08:42
tags:
- email
- javascript
- ldap
- linux
- thunderbird
title: Customize LDAP autocompletion format in Thunderbird
---

Thunderbird can connect to an LDAP server and autocomplete email addresses as you type, but it needs some adjustment for some LDAP servers. One of the LDAP servers that I use regularly returns email addresses like this in the thunderbird interface:

```
username <firstname.lastname@domain.tld>
```

The email address looks fine, but I'd much rather have the person's full name instead of the username. Here's what I'm looking for:

```
Firstname Lastname <firstname.lastname@domain.tld>
```

In older Thunderbird versions, setting `ldap_2.servers.SERVER_NAME.autoComplete.nameFormat` to `displayName` was enough. However, this option isn't used in recent versions of Thunderbird.

## Digging in

After a fair amount of searching the Thunderbird source code with `awk`, I found a mention of `DisplayName` in `nsAbLDAPAutoCompleteSearch.js` that looked promising:

```javascript
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
ldap_2.servers.default.attrmap.DisplayName: cn,commonname
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