---
title: Small update for supernova 0.9.6
author: Major Hayden
date: 2014-05-01T14:32:13+00:00
url: /2014/05/01/small-update-for-supernova-0-9-6/
dsq_thread_id:
  - 3646747077
tags:
  - openstack
  - python
  - supernova

---
A supernova user ran into a tough problem where supernova didn't seem to obey a configuration within the supernova configuration file. After checking python module versions and re-checking the configuration file a multitude of times, we discovered that there were variables defined in the user's `~/.bash_profile` that were not overwritten. It's key to remember how supernova works:

  1. supernova copies your current environment variables into a dictionary
  2. any configuration options from the supernova configuration are applied to the dictionary
  3. the dictionary is used to set environment variables only for the subprocess that runs nova (or the executable of your choice)
  4. your original environment variables are left unaltered.

A weird situation comes up if you set a variable in your environment (like `NOVA_RAX_AUTH`) but you don't set that as a configuration option within your supernova configuration file. That environment variable will carry over into your supernova subprocess and it will be used within that process.

You can fix it by clearing the conflicting environment variables from your environment or ensuring that they're not set in the first place. You can also set explicit configuration variables inside your supernova configuration file that will overwrite an environment variable that is set automatically in your environment.

With the release of supernova 0.9.6, you'll be warned if any potential conflicts exist in your environment variables:

```
$ supernova prod list
________________________________________________________________________________
*WARNING* Found existing environment variables that may cause conflicts:
  - NOVA_VARIABLE_DOESNT_EXIST
  - OS_THIS_DOESNT_EXIST
________________________________________________________________________________
```


You can get supernova via [PyPi][1] or on [GitHub][2].

 [1]: https://pypi.python.org/pypi?:action=display&name=supernova&version=0.9.6
 [2]: https://github.com/major/supernova
