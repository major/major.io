---
aliases:
- /2015/03/15/xerox-colorqube-9302-and-linux/
author: Major Hayden
date: 2015-03-16 02:23:07
tags:
- fedora
- linux
- networking
- printing
title: Xerox ColorQube 9302 and Linux
---

I do a bunch of Linux-related tasks daily. Some are difficult and others are easy. Printing has always been my nemesis.

Some printers offer up highly standardized methods for printing. For example, many HP printers simply work with JetDirect and PCL 5. However, the quirkier ones that require plenty of transformations before paper starts rolling can be tricky.

We have some Xerox ColorQube printers at the office and they require some proprietary software to get them printing under Linux. To get started, you'll need a [Linux printer driver for the Xerox ColorQube 9200 series][1].

Once you've downloaded the RPM (or DEB), install it:

```
sudo rpm -Uvh Xeroxv5Pkg-Linuxx86_64-5.15.551.3277.rpm
```


Start the Xerox Printer Manager:

```
sudo xeroxprtmgr
```


You should have a screen like this:

[<img src="/wp-content/uploads/2015/03/Xerox-Printer-Manager_006.png" alt="Xerox Printer Manager_006" width="400" height="536" class="aligncenter size-full wp-image-5411" srcset="/wp-content/uploads/2015/03/Xerox-Printer-Manager_006.png 400w, /wp-content/uploads/2015/03/Xerox-Printer-Manager_006-224x300.png 224w" sizes="(max-width: 400px) 100vw, 400px" />][2]

Press the double down arrow button at the top (it's the one on the left), and then press the button at the top right of the next window that looks like rectangles stacked on top of one another. Choose **Manual Install** from the menu that appears.

[<img src="/wp-content/uploads/2015/03/Selection_008.png" alt="Selection_008" width="433" height="544" class="aligncenter size-full wp-image-5413" srcset="/wp-content/uploads/2015/03/Selection_008.png 433w, /wp-content/uploads/2015/03/Selection_008-239x300.png 239w" sizes="(max-width: 433px) 100vw, 433px" />][3]

In the next menu, enter a nickname for the printer, the printer's IP address, and select the correct printer model from the list. The printer should be properly configured in your CUPS system afterwards:

[<img src="/wp-content/uploads/2015/03/Printers_009.png" alt="Printers_009" width="792" height="436" class="aligncenter size-full wp-image-5415" srcset="/wp-content/uploads/2015/03/Printers_009.png 792w, /wp-content/uploads/2015/03/Printers_009-300x165.png 300w" sizes="(max-width: 792px) 100vw, 792px" />][4]

Any new print jobs set to the printer will cause the Xerox printer manager to pop up. This gives you the opportunity to customize your job (collating, stapling, etc) and you can also use secure print (which I highly recommend).

 [1]: http://www.support.xerox.com/support/colorqube-9300-series/downloads/enus.html?operatingSystem=linux&fileLanguage=en
 [2]: /wp-content/uploads/2015/03/Xerox-Printer-Manager_006.png
 [3]: /wp-content/uploads/2015/03/Selection_008.png
 [4]: /wp-content/uploads/2015/03/Printers_009.png