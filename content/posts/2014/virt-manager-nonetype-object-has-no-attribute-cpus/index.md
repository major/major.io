---
aliases:
- /2014/03/06/virt-manager-nonetype-object-has-no-attribute-cpus/
author: Major Hayden
date: 2014-03-06 18:44:58
tags:
- fedora
- python
- rpm
- virt-manager
- virtualization
- xen
title: 'virt-manager: ‘NoneType’ object has no attribute ‘cpus’'
---

After upgrading my Fedora 20 Xen hypervisor to virt-manager 1.0.0, I noticed that I couldn't open the console or VM details for any of my guests. Running `virt-manager --debug` gave me the following traceback:

```
Traceback (most recent call last):
  File "/usr/share/virt-manager/virtManager/engine.py", line 803, in _show_vm_helper
    details = self._get_details_dialog(uri, uuid)
  File "/usr/share/virt-manager/virtManager/engine.py", line 760, in _get_details_dialog
    obj = vmmDetails(con.get_vm(uuid))
  File "/usr/share/virt-manager/virtManager/details.py", line 530, in __init__
    self.init_details()
  File "/usr/share/virt-manager/virtManager/details.py", line 990, in init_details
    for name in [c.model for c in cpu_values.cpus]:
AttributeError: 'NoneType' object has no attribute 'cpus'
[Tue, 04 Mar 2014 22:13:31 virt-manager 21019] DEBUG (error:84) error dialog message:
summary=Error launching details: 'NoneType' object has no attribute 'cpus'
details=Error launching details: 'NoneType' object has no attribute 'cpus'
```

I [opened a bug report][1] and the fix was [committed upstream][2] today. If you want to make these updates to your Fedora 20 server before the update package is available, just snag the [three RPM's from koji][3] and install them:

```
mkdir /tmp/virt-manager
cd /tmp/virt-manager
wget http://kojipkgs.fedoraproject.org/packages/virt-manager/1.0.0/4.fc20/noarch/virt-install-1.0.0-4.fc20.noarch.rpm
wget http://kojipkgs.fedoraproject.org/packages/virt-manager/1.0.0/4.fc20/noarch/virt-manager-1.0.0-4.fc20.noarch.rpm
wget http://kojipkgs.fedoraproject.org/packages/virt-manager/1.0.0/4.fc20/noarch/virt-manager-common-1.0.0-4.fc20.noarch.rpm
yum localinstall *.rpm
```

**UPDATE:** Thanks to Cole's comment below, you can actually pull in the RPM's using koji directly:

```
koji download-build virt-manager-1.0.0-4.fc20
```

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=1072704
 [2]: https://git.fedorahosted.org/cgit/virt-manager.git/commit/?id=b078ba8c3d69b62fe748d9182babef8971914277
 [3]: http://koji.fedoraproject.org/koji/buildinfo?buildID=502966