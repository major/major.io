---
title: Exporting SSL certificates from Windows to Linux
author: Major Hayden
type: post
date: 2007-03-23T13:11:16+00:00
url: /2007/03/23/exporting-ssl-certificates-from-windows-to-linux/
dsq_thread_id:
  - 3642765870
categories:
  - Blog Posts
tags:
  - command line
  - security
  - web

---
First, you have to get the certificate and key out of Windows in a pfx (PKCS #12) format.

* Click Start, Run, then type "mmc" and hit enter.
* In the leftmost menu, choose "Add/Remove Snap In".
* Click "Add", then click "Certificates", then OK.
* When the wizard starts, choose "Computer Account", "Local Computer" and finish out the wizard.
* Once you're finished, get back to the MMC and expand the "Certificates" node, then the "Personal" node.
* Click on the "Certificates" node under "Personal" and find your certificate in the right pane.
* Right click on the certificate and choose "All Tasks", then "Export".
* When the wizard starts, choose "Yes" for exporting the private key, then select **ONLY** "Strong Private Key Protection" from the PFX section. You will also need to set a password and specify a location for the PFX file.
* Once the PFX file has been saved, close out the MMC (don't save the snap-in if it asks).
* Get the PFX over to the Linux server somehow.

Once the PFX makes it over to the Linux server, you have to decrypt the PFX into a plaintext PEM file (PFX's are binary files, and can't be viewed in a text editor):

```
openssl pkcs12 -in file.pfx -out file.pem
```

You will be asked for the password for the PFX (which is the one you set in the Windows wizard). Once you enter that, you will be asked for a new password. This new password is used to encrypt the private key. You cannot proceed until you enter a password that is 4 characters or longer. **REMEMBER** this password!

When this step is complete, you should have a PEM file that you can read in a text editor. Open the file in a text editor and copy the private key and certificate to different files. Remember to keep the dashed lines intact when you copy the certificates - this is important. There is some additional text above the key, and also between the key and certificate - this text should be ignored and should not be included in the certificate and key files.

Now that you have the key and certificate separated, you need to decrypt the private key (or face the wrath of Apache every time you restart the server). You can decrypt the private key like this:

```
openssl rsa -in file.key -out file.key
```

Yes, provide the same file name twice and it will decrypt the key onto itself, keeping everything in one file. OpenSSL will ask for a password to decrypt the key, and this is the password you set when you decrypted the PFX. If you forgot the password, you will need to start over from when you brought it over from the Windows box.

After this entire process, you will have four files, a PFX, PEM, KEY, and CRT. Throw away the PFX and PEM, and you can use the key and certificate files to install into Apache. In case you forget the syntax, here's what goes in the Apache configuration:

```
SSLEngine On
SSLCertificateFile /path/to/your/certificate
SSLCertificateKeyFile /path/to/your/privatekey
```
