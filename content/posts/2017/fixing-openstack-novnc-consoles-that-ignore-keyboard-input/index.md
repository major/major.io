---
aliases:
- /2017/05/18/fixing-openstack-novnc-consoles-that-ignore-keyboard-input/
author: Major Hayden
date: 2017-05-18 16:58:56
tags:
- kvm
- networking
- openstack
- python
- vnc
title: Fixing OpenStack noVNC consoles that ignore keyboard input
---

I opened up a noVNC console to a virtual machine today in my OpenStack cloud but found that the console wouldn't take keyboard input. The **Send Ctrl-Alt-Del** button in the top right of the window worked just fine, but I couldn't type anywhere in the console. This happened on an Ocata OpenStack cloud deployed with [OpenStack-Ansible][2] on CentOS 7.

## Test the network path

The network path to the console is a little deep for this deployment, but here's a quick explanation:

  * My laptop connects to HAProxy
  * HAProxy sends the traffic to the nova-novncproxy service
  * nova-novncproxy connects to the correct VNC port on the right hypervisor

If all of that works, I get a working console! I knew the network path was set up correctly because I could see the console in my browser.

My next troubleshooting step was to dump network traffic with `tcpdump` on the hypervisor itself. I dumped the traffic on port 5900 (which was the VNC port for this particular instance) and watched the output. Whenever I wiggled the mouse over the noVNC console in my browser, I saw a flurry of network traffic. The same thing happened if I punched lots of keys on the keyboard. At this point, it was clear that the keyboard input was making it to the hypervisor, but it wasn't being handled correctly.

## Test the console

Next, I opened up `virt-manager`, connected to the hypervisor, and opened a connection to the instance. The keyboard input worked fine there. I opened up `remmina` and connected via plain old VNC. The keyboard input worked fine there, too!

## Investigate in the virtual machine

The system journal in the virtual machine had some interesting output:

```
kernel: atkbd serio0: Unknown key released (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
kernel: atkbd serio0: Unknown key released (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
kernel: atkbd serio0: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
kernel: atkbd serio0: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
kernel: atkbd serio0: Unknown key released (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
kernel: atkbd serio0: Unknown key released (translated set 2, code 0x0 on isa0060/serio0).
kernel: atkbd serio0: Use 'setkeycodes 00 <keycode>' to make it known.
```


It seems like my keyboard input was being lost in translation - literally. I have a US layout keyboard (Thinkpad X1 Carbon) and the virtual machine was configured with the `en-us` keymap:

```
# virsh dumpxml 4 | grep vnc
    <graphics type='vnc' port='5900' autoport='yes' listen='192.168.250.41' keymap='en-us'>
```


A thorough Googling session revealed that it is [not recommended to set a keymap for virtual machines][3] in libvirt in most situations. I set the `nova_console_keymap` variable in `/etc/openstack_deploy/user_variables.yml` to an empty string:

```
nova_console_keymap: ''
```


I redeployed the nova service using the OpenStack-Ansible playbooks:

```
openstack-ansible os-nova-install.yml
```


Once that was done, I powered off the virtual machine and powered it back on. (This is needed to ensure that the libvirt changes go into effect for the virtual machine.)

**Great success!** The keyboard was working in the noVNC console once again!

_Photo credit: [Wikipedia][4]_

 [1]: /wp-content/uploads/2017/05/Televideo925Terminal-e1495126632469.jpg
 [2]: https://github.com/openstack/openstack-ansible
 [3]: https://github.com/novnc/noVNC/issues/666#issuecomment-248303186
 [4]: https://commons.wikimedia.org/wiki/File:Televideo925Terminal.jpg