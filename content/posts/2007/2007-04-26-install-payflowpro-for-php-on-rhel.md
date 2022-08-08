---
title: Install PayFlowPro for PHP on RHEL
author: Major Hayden
date: 2007-04-26T22:06:35+00:00
url: /2007/04/26/install-payflowpro-for-php-on-rhel/
dsq_thread_id:
  - 3679052713
tags:
  - development
  - web

---
To install PayFlowPro, you will need a few things:

  * The PHP source code for version of PHP installed ([go here][1])
  * The SDK from Verisign/PayPal (this comes from the portal, login required)
  * The gcc and automake packages

Take the Verisign SDK and copy the following:

  * Copy pfpro.h to /usr/include
  * Copy the .so file to /usr/lib

Untar the PHP source code and cd into php-[version]/ext/pfpro. Run `phpize` and make sure it finishes successfully. Now run:

`./configure --prefix=/usr --enable-shared`

Then run `make` and `make install`. Now, go to the php.ini and add:

`extension=pfpro.so`

Run `php -i | grep pfpro` to make sure the module was successfully built. Restart Apache and you're all set!

_The pfpro module is now available via pecl in PHP 5.1+. Thanks to Chris R. for pointing that out._

 [1]: http://museum.php.net/
