---
author: Major Hayden
date: '2023-05-05'
summary: |
  Add a Fedora x86_64 or aarch64 image to Oracle Cloud and launch an instance. 🚀
tags:
  - cloud
  - fedora
  - oracle
title: Fedora on Oracle Cloud
coverAlt: Stairway with stone walls
coverCaption: |
  [James Wood](https://unsplash.com/photos/GoArxJdvQ6Q)
---

I enjoy taking Fedora with me to various clouds and ensuring that it works well on all
of them. I've written posts on taking [Fedora to Hetzner cloud](/p/fedora-37-hetzner/)
and [deploying custom Fedora
images](/2021/11/16/deploy-custom-fedora-35-aws-image-builder/) to AWS with image
builder.

Although Oracle Cloud isn't a cloud I use frequently, a question came up earlier this
week in the Fedora community about how to take an image there. I love a good challenge,
so buckle up and follow along as we launch a Fedora 38 instance on
[Oracle Cloud](https://www.oracle.com/cloud/).

{{< alert >}}
Be sure to create an Oracle Cloud account first!
The rest of the blog post requires CLI interactions with the Oracle Cloud API.
{{< /alert >}}

Let's go! 🎒

# Oracle's cloud tools

Although you can do the image upload and import via the web interface, I enjoy getting
to learn a cloud provider's CLI tools in case I need them later. Oracle offers a CLI
called `oci` that you can install via `pipx`:

```
$ pipx install oci-cli
  installed package oci-cli 3.26.0, installed using Python 3.11.3
  These apps are now globally available
    - create_backup_from_onprem
    - oci
done! ✨ 🌟 ✨

$ oci --version
3.26.0
```

The CLI tool has a helpful authentication wizard that configures your credentials on
your local machine. Run `oci -i` and follow the prompts.

```
$ oci session authenticate
Enter a region by index or name(e.g.
1: af-johannesburg-1, 2: ap-chiyoda-1, 3: ap-chuncheon-1, 4: ap-dcc-canberra-1, 5: ap-hyderabad-1,
6: ap-ibaraki-1, 7: ap-melbourne-1, 8: ap-mumbai-1, 9: ap-osaka-1, 10: ap-seoul-1,
11: ap-singapore-1, 12: ap-sydney-1, 13: ap-tokyo-1, 14: ca-montreal-1, 15: ca-toronto-1,
16: eu-amsterdam-1, 17: eu-dcc-dublin-1, 18: eu-dcc-dublin-2, 19: eu-dcc-milan-1, 20: eu-dcc-milan-2,
21: eu-dcc-rating-1, 22: eu-dcc-rating-2, 23: eu-frankfurt-1, 24: eu-jovanovac-1, 25: eu-madrid-1,
26: eu-marseille-1, 27: eu-milan-1, 28: eu-paris-1, 29: eu-stockholm-1, 30: eu-zurich-1,
31: il-jerusalem-1, 32: me-abudhabi-1, 33: me-dcc-muscat-1, 34: me-dubai-1, 35: me-jeddah-1,
36: mx-queretaro-1, 37: sa-santiago-1, 38: sa-saopaulo-1, 39: sa-vinhedo-1, 40: uk-cardiff-1,
41: uk-gov-cardiff-1, 42: uk-gov-london-1, 43: uk-london-1, 44: us-ashburn-1, 45: us-chicago-1,
46: us-gov-ashburn-1, 47: us-gov-chicago-1, 48: us-gov-phoenix-1, 49: us-langley-1, 50: us-luke-1,
51: us-phoenix-1, 52: us-sanjose-1): 51
    Please switch to newly opened browser window to log in!
    You can also open the following URL in a web browser window to continue:
https://login.us-phoenix-1.oraclecloud.com/v1/oauth2/authorize?...
```

A long URL will appear on the console. Open that URL in a browser and finish the login
process in your browser. Once you finish, you should see a message like this:

```
Enter the name of the profile you would like to create: DEFAULT
Config written to: /home/major/.oci/config

    Try out your newly created session credentials with the following example command:

    oci iam region list --config-file /home/major/.oci/config --profile DEFAULT --auth security_token
```

Replace _major_ with your username and try out your authentication:

```
$ oci iam region list --config-file /home/major/.oci/config --profile DEFAULT --auth security_token
{
  "data": [
    {
      "key": "AMS",
      "name": "eu-amsterdam-1"
    },
    ...
```

Success! Let's move on.

# Uploading the Fedora image

Most cloud providers have a custom image process that involves uploading the image to
some object storage and then telling the compute service where the image is located.
Oracle Cloud follows the same pattern.

First up, we need our _compartment ID_.
This is a way to logically separate infrastructure at Oracle Cloud.
We will store it as an environment variable called `COMPARTMENT_ID`

```
$ COMPARTMENT_ID=$(oci iam compartment list --auth security_token | jq -r '.data[]."compartment-id"')
```

We need an object storage bucket to hold our image file.
Naming things isn't my strong suit, so I'll call my bucket _majors-fedora-upload-bucket_:

```
$ oci os bucket create --name majors-fedora-upload-bucket \
    --compartment-id $COMPARTMENT_ID --auth security_token
{
  "data": {
    "approximate-count": null,
    "approximate-size": null,
    "auto-tiering": null,
    ...
```
{{< alert >}}
Within the data that is returned, look for the **namespace** key. You will need the
value from that key when you do the image import step.
{{< /alert >}}

Now we need a Fedora image. The latest [Fedora 38 QCOW
image](https://mirrors.kernel.org/fedora/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2)
should work fine.

```
$ wget https://mirrors.kernel.org/fedora/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2
```

_(Oracle Cloud has aarch64 instances and you can use a Fedora aarch64 image for those instead. This example focuses on x86_64.)_

Upload the image to our bucket:

```
$ oci os object put \
    --bucket-name majors-fedora-upload-bucket \
    --file ~/Downloads/Fedora-Cloud-Base-38-1.6.x86_64.qcow2 \
    --auth security_token
Upload ID: 0f9b7008-b2d5-185f-08c7-8aeae904f136
Split file into 4 parts for upload.
Uploading object  [####################################]  100%          
{
  "etag": "c0f1bd77-46c6-4e65-a2bb-0d0b0dafe586",
  "last-modified": "Fri, 05 May 2023 21:33:41 GMT",
  "opc-multipart-md5": "iK+1qeXizzd1r+5lEZX6cQ==-4"
}
```

This may take a while depending on your upload speed.

# Import the Fedora image

If you forgot to save the namespace from your bucket when you created it, just look it
up again with the `bucket get` command:

```
$ oci os bucket get --name majors-fedora-upload-bucket \
    --auth security_token | jq -r '.data.namespace'
axr6swqvwoeb
```

At this point, we must tell Oracle's compute service to import the image we just
uploaded to the object storage. Let's run another command to do the import:

```
$ oci compute image import from-object --auth security_token \
    --bucket-name majors-fedora-upload-bucket \
    --compartment-id $COMPARTMENT_ID \
    --name "Fedora-Cloud-Base-38-1.6.x86_64.qcow2" \
    --namespace axr6swqvwoeb \
    --display-name Fedora-Cloud-Base-38-1.6 \
    --operating-system Fedora \
    --operating-system-version 38 \
    --source-image-type QCOW2 \
    --launch-mode PARAVIRTUALIZED
{
  "data": {
    "agent-features": null,
    "base-image-id": null,
    "billable-size-in-gbs": null,
```

Look for the `id` in the output that was returned. Use that identifier to check the
status of the import.

```
$ export IMAGE_ID=ocid1.image.oc1.phx.aaaaaaaayiu26gv67exe7mvpxkq76zwh44otstzktzaf2f6vqe5izqzrciqq
$ oci compute image get --auth security_token \
    --image-id $IMAGE_ID | jq -r '.data."lifecycle-state"'
IMPORTING
```

This step takes about ten minutes for most images I tested.

Oracle Cloud uses _work requests_ for most long running actions in the cloud. You can
get their status via the CLI tools, but I found that to be extremely tedious. For a
percentage completed and a progress bar, go to the [Custom
Images](https://cloud.oracle.com/compute/images) panel in the web interface, click your
image name, click the **Create image** link under **Work requests** and monitor the
percentage there. 😉

# Create an instance

The `oci` CLI tool is good at many things, but it's tedious with many others. Launching
a VM instance via the CLI was incredibly frustrating for me, so I usually go to the web
interface to get this done. _(You could also use tools like Terraform for this step.)_

Let's run through the steps:

1. Go to the [Instances](https://cloud.oracle.com/compute/instances) panel in the web UI
2. Click the **Create instance** button at the top
3. Click **Change Image** in the **Image and Shape** section
4. Click the **My images** box and then the checkbox next to the Fedora image you imported
5. Click **Select Image** at the bottom
6. Choose your preferred _shape_ (instance type)
7. Choose your SSH key
8. Click **Create** at the bottom

Now you should have an instance beginning to launch! 🚀

After it's online, you should be able to ssh[^cantconnect] to the instance using the
_fedora_ user:

```
$ ssh fedora@129.146.75.xxx
[fedora@fedora-38-oracle-whee ~]$ cat /etc/fedora-release 
Fedora release 38 (Thirty Eight)
```

Enjoy running Fedora on Oracle Cloud! 🎉

[^cantconnect]: If you aren't able to access the instance, you might be missing an internet gateway or a security group to allow traffic through to your instance. 
    Here are direct links to the console instructions for those items:

    * [Adding security groups](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/networksecuritygroups.htm#console)
    * [Working with internet gateways](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingIGs.htm#console)