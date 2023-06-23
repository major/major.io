---
aliases:
- /2007/07/01/plesk-and-phpmyadmin-non-static-method-pma_configishttps-should-not-be-called-statically/
author: Major Hayden
date: 2007-07-01 16:27:21
dsq_thread_id:
- 3642768474
tags:
- database
- plesk
title: 'Plesk and PHPMyAdmin: Non-static method PMA_Config::isHttps() should not be
  called statically'
---

If this situation pops up in Plesk, it means that a user has changed their MySQL password outside of Plesk. The password in Plesk's own database does not match, so the auto-creation of the phpMyAdmin settings fails. You'll end up seeing this after clicking "DB WebAdmin":

**MySQL said: Non-static method PMA_Config::isHttps() should not be called statically**

The funny thing is that MySQL doesn't actually say this. It's a PHP error. To correct the problem, you can manually change the password within Plesk's database, or you can follow an easier method:

Click Databases

Click Database Users

Click the user that has a password change

In the password fields, enter the new password that they're using with MySQL

This will force Plesk to change its password in its own database, and it will run the query to change the password in MySQL (but since it's the same password, no change will be made).