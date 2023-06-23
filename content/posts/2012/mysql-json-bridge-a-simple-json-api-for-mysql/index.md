---
aliases:
- /2012/03/28/mysql-json-bridge-a-simple-json-api-for-mysql/
author: Major Hayden
date: 2012-03-29 02:34:53
dsq_thread_id:
- 3644401717
tags:
- development
- github
- json
- mysql
- python
- rackspace
- web
title: 'mysql-json-bridge: a simple JSON API for MySQL'
---

My quest to get better at [Python][1] led me to create a new project on GitHub. It's called [mysql-json-bridge][2] and it's ready for you to use.

**Why do we need a JSON API for MySQL?**

The real need sprang from a situation I was facing daily at [Rackspace][3]. We have a lot of production and pre-production environments which are in flux but we need a way to query data from various MySQL servers for multiple purposes. Some folks need data in ruby or python scripts while others need to drag in data with .NET and Java. Wrestling with the various adapters and all of the user privileges on disparate database servers behind different firewalls on different networks was less than enjoyable.

That's where this bridge comes in.

The bridge essentially gives anyone the ability to talk to multiple database servers across different environments by talking to a single endpoint with easily configurable security and encryption. As long as the remote user can make an HTTP POST and parse some JSON, they can query data from multiple MySQL endpoints.

**How does it work?**

It all starts with a simple HTTP POST. I've become a big fan of the Python [requests][4] module. If you're using it, this is all you need to submit a query:

```
import requests
payload = {'sql': 'SELECT * FROM some_tables WHERE some_column=some_value'}
url = "http://localhost:5000/my_environment/my_database"
r = requests.post(url, data=payload)
print r.text
```


The bridge takes your query and feeds it into the corresponding MySQL server. When the results come back, they're converted to JSON and returned via the same HTTP connection.

**What technology does it use?**

[Flask][5] does the heavy lifting for the HTTP requests and [Facebook's Tornado database class][6] wraps the [MySQLdb][7] module in something a little more user friendly. Other than those modules, [PyYAML][8] and [requests][4] are the only other modules not provided by the standard Python libraries.

**Is it fast?**

Yes. I haven't done any detailed benchmarks on it yet, but the overhead is quite low even with a lot of concurrency. The biggest slowdowns come from network latency between you and the bridge or between the bridge and the database server. Keep in mind that gigantic result sets will take a longer time to transfer across the network and get transformed into JSON.

**I found a bug. I have an idea for an improvement. You're terrible at Python.**

All feedback (and every pull request) is welcome. I'm still getting the hang of Python (hey, I've only been writing in it seriously for a few weeks!) and I'm always eager to learn a new or better way to accomplish something. Feel free to create an issue in GitHub or submit a pull request with a patch.

 [1]: http://python.org
 [2]: https://github.com/rackerhacker/mysql-json-bridge
 [3]: http://rackspace.com/
 [4]: http://python-requests.org
 [5]: http://flask.pocoo.org/
 [6]: https://github.com/facebook/tornado/blob/master/tornado/database.py
 [7]: http://mysql-python.sourceforge.net/
 [8]: http://pyyaml.org/