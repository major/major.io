---
author: Major Hayden
date: '2021-11-01'
summary: >-
  Provision services on Microsoft's Azure CLI on Fedora 35. 💙
images:
- images/2021-11-01-ocean-through-porthole.jpg
slug: install-azure-cli-fedora-35
tags:
- azure
- cloud
- fedora
- linux
- python
title: Install Azure CLI on Fedora 35
---

{{< figure src="/images/2021-11-01-ocean-through-porthole.jpg" alt="Blue ocean viewed through a boat's porthole" position="center" >}}

I started work on packaging the [Azure CLI] and all of its components in Fedora
back in July 2021 and the work finally finished just as the Fedora 35
development cycled ended. This required plenty of packaging work and I was
thankful for all the advice I received along the way from experienced Fedora
packagers.

[Azure CLI]: https://github.com/Azure/azure-cli

## Installing Azure CLI

Make sure you're on Fedora 35 or later first. Then install `azure-cli`:

```console
$ sudo dnf -y install azure-cli
$ az --version
azure-cli                         2.29.0 *

core                              2.29.0 *
telemetry                          1.0.6

Extensions:
aks-preview                       0.5.29

Python location '/usr/bin/python3'
Extensions directory '/home/major/.azure/cliextensions'
```

## Authenticate with Azure

You have two methods for authenticating with Azure:

* via a web browser (good for desktops and workstations)
* via a device code (good for remote servers or virtual machines)

To authenticate with a browser, type `az login` and complete the steps in the
browser window that appears.

Otherwise, run `az login --use-device-code` and complete the steps manually
using the URL and the access code provided on the command line.

If everything works well, you should get a message saying `You have logged in.`
followed by some information about your account in JSON format.

## To the cloud!

Most resources in Azure live inside a resource group, so let's try to create one
to ensure the CLI is working and authenticated properly:

```
$ az group create --location eastus --resource-group major-testing-eastus
{
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/major-testing-eastus",
  "location": "eastus",
  "managedBy": null,
  "name": "major-testing-eastus",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

Perfect! 🎉

*Photo credit: [Sergi Marló](https://unsplash.com/photos/-mMoKrWFBjw)*
