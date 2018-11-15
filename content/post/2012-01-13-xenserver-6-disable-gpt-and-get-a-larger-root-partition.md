---
title: 'XenServer 6: Disable GPT and get a larger root partition'
author: Major Hayden
type: post
date: 2012-01-13T15:00:10+00:00
url: /2012/01/13/xenserver-6-disable-gpt-and-get-a-larger-root-partition/
dsq_thread_id:
  - 3642806778
categories:
  - Blog Posts
tags:
  - command line
  - linux
  - xen
  - xenserver

---
[XenServer 6][1] is a solid virtualization platform, but the installer doesn't give you many options for customized configurations. By default, it installs with a 4GB root partition and uses [GUID Partition Tables (GPT)][2]. GPT is new in XenServer 6.

I'd rather use [MBR partition tables][3] and get a larger root partition. If you want to make these adjustments in your XenServer 6 installation, follow these steps after booting into the [XenServer 6 install disc][4]:

[<img src="/wp-content/uploads/2012/01/01-300x220.jpg" alt="xenserver_install_01" title="xenserver_install_01" width="300" height="220" class="alignleft size-medium wp-image-2744" srcset="/wp-content/uploads/2012/01/01-300x220.jpg 300w, /wp-content/uploads/2012/01/01.jpg 672w" sizes="(max-width: 300px) 100vw, 300px" />][5]

When the installer initially boots, press F2 to access the advanced installation options.

 <br style="clear: both;" />

[<img src="/wp-content/uploads/2012/01/02-300x220.jpg" alt="xenserver_install_02" title="xenserver_install_02" width="300" height="220" class="alignleft size-medium wp-image-2747" srcset="/wp-content/uploads/2012/01/02-300x220.jpg 300w, /wp-content/uploads/2012/01/02.jpg 672w" sizes="(max-width: 300px) 100vw, 300px" />][6]

Type `shell` and press enter. The installer should begin booting into a pre-installation shell where you can make your adjustments.

<br style="clear: both;" />

[<img src="/wp-content/uploads/2012/01/04-300x164.jpg" alt="" title="xenserver_install_04" width="300" height="164" class="alignleft size-medium wp-image-2761" srcset="/wp-content/uploads/2012/01/04-300x164.jpg 300w, /wp-content/uploads/2012/01/04.jpg 752w" sizes="(max-width: 300px) 100vw, 300px" />][7]

Once you've booted into the pre-installation shell, type `vi /opt/xensource/installer/constants.py` and press enter.

<br style="clear: both;" />

[<img src="/wp-content/uploads/2012/01/05-300x164.jpg" alt="xenserver_install_05" title="xenserver_install_05" width="300" height="164" class="alignleft size-medium wp-image-2765" srcset="/wp-content/uploads/2012/01/05-300x164.jpg 300w, /wp-content/uploads/2012/01/05.jpg 752w" sizes="(max-width: 300px) 100vw, 300px" />][8]

Change `GPT_SUPPORT = True` to `GPT_SUPPORT = False` to disable GPT and use MBR partition tables. Adjust the value of `root_size` from 4096 (the default) to a larger number to get a bigger root partition. The size is specified in MB, so 4096 is 4GB. Save the file and exit `vim`.

<br style="clear: both;" />

[<img src="/wp-content/uploads/2012/01/06-300x164.jpg" alt="" title="xenserver_install_06" width="300" height="164" class="alignleft size-medium wp-image-2768" srcset="/wp-content/uploads/2012/01/06-300x164.jpg 300w, /wp-content/uploads/2012/01/06.jpg 752w" sizes="(max-width: 300px) 100vw, 300px" />][9]

Type `exit` and the installer should start.

<br style="clear: both;" />

Once the installation is complete, you should have a bigger root partition on a MBT partition table:

```
# df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              20G  1.8G   17G  10% /
# fdisk -l /dev/sda

Disk /dev/sda: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        2611    20971520   83  Linux
/dev/sda2            2611        5222    20971520   83  Linux
/dev/sda3            5222       19457   114345281   8e  Linux LVM
```


 [1]: http://www.citrix.com/English/ps2/products/product.asp?contentID=683148&ntref=prod_top
 [2]: http://en.wikipedia.org/wiki/GUID_Partition_Table
 [3]: http://en.wikipedia.org/wiki/Master_boot_record
 [4]: http://www.citrix.com/lang/English/lp/lp_1688615.asp
 [5]: /wp-content/uploads/2012/01/01.jpg
 [6]: /wp-content/uploads/2012/01/02.jpg
 [7]: /wp-content/uploads/2012/01/04.jpg
 [8]: /wp-content/uploads/2012/01/05.jpg
 [9]: /wp-content/uploads/2012/01/06.jpg
