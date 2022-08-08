---
title: 'HOWTO: Mikrotik OpenVPN server'
author: Major Hayden
date: 2015-05-01T15:33:35+00:00
url: /2015/05/01/howto-mikrotik-openvpn-server/
dsq_thread_id:
  - 3728295785
tags:
  - mikrotik
  - networking
  - openvpn

---
[<img src="/wp-content/uploads/2015/05/rb850_picture-300x300.jpg" alt="RB850Gx2 mikrotik" width="300" height="300" class="alignright size-medium wp-image-5543" srcset="/wp-content/uploads/2015/05/rb850_picture-300x300.jpg 300w, /wp-content/uploads/2015/05/rb850_picture-150x150.jpg 150w, /wp-content/uploads/2015/05/rb850_picture.jpg 800w" sizes="(max-width: 300px) 100vw, 300px" />][1]Mikrotik firewalls have been good to me over the years and they work well for multiple purposes. Creating an OpenVPN server on the device can allow you to connect into your local network when you're on the road or protect your traffic when you're using untrusted networks.

Although Miktrotik's implementation isn't terribly robust (TCP only, client cert auth is wonky), it works quite well for most users. I'll walk you through the process from importing certificates through testing it out with a client.

<!--more-->

### Import certificates

Creating a CA and signing a certificate and key is outside the scope of this post and there are plenty of sites that cover the basics of creating a [self-signed certificate][2]. You could also create a certificate signing request (CSR) on the Mikrotik and have that signed by a trusted CA. In my case, I have a simple CA already and I signed a certificate for myself.

Upload your certificate, key, and CA certificate (if applicable) to the Mikrotik. After that, import those files into the Mikrotik's certificate storage:

```
 import file-name=firewall.example.com.crt
passphrase:
     certificates-imported: 1
     private-keys-imported: 0
            files-imported: 1
       decryption-failures: 0
  keys-with-no-certificate: 0

[major@home] /certificate> import file-name=firewall.example.com.pem
passphrase:
     certificates-imported: 0
     private-keys-imported: 1
            files-imported: 1
       decryption-failures: 0
  keys-with-no-certificate: 0

[major@home] /certificate> import file-name=My_Personal_CA.crt
passphrase:
     certificates-imported: 1
     private-keys-imported: 0
            files-imported: 1
       decryption-failures: 0
  keys-with-no-certificate: 0
```


**Always import the certificate first, then the key.** You should be able to do a `/certificate print` and see the entries for the files you imported. In the print output, look at the flags column and verify that the line with your certificate has a **T** and a **K**. If the K is missing, import the key one more time. If that still doesn't work, ensure that your certificate and key match.

The default naming conventions used for certificates is a little confusing. You can rename a certificate by running `set name=firewall.example.com number=0` (run a `/certificate print` to get the right number).

### OpenVPN server configuration

We're now ready to do the first steps of the OpenVPN setup on the Mikrotik. You can do this configuration via the Winbox GUI or via the web interface, but I prefer to use the command line. Let's start:

```
/interface ovpn-server server
set certificate=firewall.example.com cipher=blowfish128,aes128,aes192,aes256 default-profile=default-encryption enabled=yes
```


This tells the device that we want to use the certificate we imported earlier along with all of the available ciphers. We're also selecting the **default-encryption** profile that we will configure in more detail later. Feel free to adjust your cipher list later on but I recommend allowing all of them until you're sure that the VPN configuration works.

We're now ready to add an OpenVPN interface. In Mikrotik terms, you can have multiple OpenVPN server profiles running under the same server. They will all share the same certificate, but each may have different authentication methods or network configurations. Let's define our first profile:

```
/interface ovpn-server
add name=openvpn-inbound user=openvpn
```


There's now a profile with a username of **openvpn**. That will be the username that we use to connect to this VPN server.

### Secrets

The router needs a way to identify the user we just created. We can define a secret easily:

```
/ppp secret
add name=openvpn password=vpnsarefun profile=default-encryption
```


We've set a password secret and defined a connection profile that corresponds to the secret.

### Profiles

We've been referring to this **default-encryption** profile several times and now it's time to configure it. This is one of the things I prefer to configure using the Winbox GUI or the web interface since there are plenty of options to review.

The most important part is how you connect the VPN connection into your internal network. You have a few options here. You can configure an IP address that will always be assigned to this connection no matter what. There are upsides and downsides with that choice. You'll always get the same IP on the inside network but you won't be able to connect to the same profile with multiple clients.

I prefer to set the bridge option to my internal network bridge (which I call **lanbridge**). That allows me to use my existing bridge configuration and filtering rules on my OpenVPN tunnels. My configuration looks something like this:

```
/ppp profile
set 1 bridge=lanbridge local-address=default-dhcp only-one=no remote-address=default-dhcp
```


I've told the router that I want VPN connections to be hooked up to my main bridge and it should get local and remote IP addresses from my default DHCP server. In addition, I've also allowed more than one simultaneous connection to this profile.

The other defaults are fairly decent to get started. You can go back and adjust them later if needed.

### OpenVPN client

Every client has things configured a bit differently but I'll be working with a basic OpenVPN configuration file here that should work on most systems (or at least show you what to click in your client GUI).

Here's my OpenVPN client configuration file:

```
remote firewall.example.com 1194 tcp-client
persist-key
auth-user-pass /etc/openvpn/firewall-creds.txt
tls-client
pull
ca /home/major/.cert/ca.crt
redirect-gateway def1
dev tun
persist-tun
cert /home/major/.cert/cert.crt
nobind
key /home/major/.cert/key.key
```


In my configuration, I refer to a **/etc/openvpn/firewall-creds.txt** file to hold my credentials. You can store the file anywhere (or this might be configurable in a GUI) but it should look like this:

```
username
password
```


That's it - just a two line file with the username, a line feed, and a password.

At this point, you should be able to test your client.

### Troubleshooting

**Firewall** - Ensure that you have a firewall rule set to allow traffic into your OpenVPN port. This could be something as simple as:

```
/ip firewall filter add chain=input dst-port=1194 protocol=tcp
```


**Certificates** - Check that your certificate and key were imported properly and that your client is configured to trust the self-signed certificate or the CA you used.

**Compression** - For some reason, I have lots of problems if compression is enabled on the client. They range from connection failures to being unable to pass traffic through the tunnel after getting connected. Be sure that anything that mentions compression or LZO is disabled.

### Security

There are some security improvements that can be made after configuring everything:

  * Limit access to your OpenVPN port in your firewall to certain source IP's
  * Configure better passwords for your OpenVPN secret
  * Consider making a separate bridge or network segment for VPN users when they connect and apply filters to it
  * Adjust the list of ciphers in the default-encryption profile so that only the strongest can be used (may cause some clients to be unable to connect)

 [1]: /wp-content/uploads/2015/05/rb850_picture.jpg
 [2]: /2007/08/02/generate-self-signed-certificate-and-key-in-one-line/
