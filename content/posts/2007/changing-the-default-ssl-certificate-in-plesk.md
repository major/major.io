---
aliases:
- /2007/05/21/changing-the-default-ssl-certificate-in-plesk/
author: Major Hayden
date: 2007-05-22 02:16:57
dsq_thread_id:
- 3642767490
tags:
- plesk
- security
title: Changing the default SSL certificate in Plesk
---

When Plesk is installed, the default certificate for the Plesk interface itself is a self-signed certificate that is generated during the installation. This can be easily changed within the Server options page.

**If your SSL certificate is installed at the domain level:**

Click Domains > domain.com > Certificates > certificate name. Copy the CSR, key and CA certificates to a text application temporarily, and then click Server > Certificates. Once you're there, click Add Certificate and paste in the CSR, key and CA certificate. You will need to select a new name for the certificate that is different from the one you use at the domain level. Once you're done inserting that information, click OK and follow the instructions below.

**If your SSL certificate is installed at the server level**

Click Server > Certificates. Click the checkbox next to the certificate which needs to be installed as the default, then click Setup just above the certificate listing. Plesk will install the certificate and reload itself (which generally takes 5-15 seconds). Depending on your browser, you may need to log out of Plesk and log back in to see the new certificate.

When everything is complete, verify that the correct certificate is used when you access the Plesk interface, and also be sure that the intermediate certificates are installed correctly as well.