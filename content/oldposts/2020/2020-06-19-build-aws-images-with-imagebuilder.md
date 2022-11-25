---
author: Major Hayden
date: '2020-06-19'
summary: Build a customized image for AWS with Image Builder and use the built-in
  automatic uploader and importer.
images:
- images/2020-06-19-aluminum-factory.jpg
slug: build-aws-images-with-imagebuilder
tags:
- aws
- cloud
- fedora
- linux
title: Build AWS images with Image Builder
---

{{< figure src="/images/2020-06-19-aluminum-factory.jpg" alt="Aluminum factory" position="center" >}}

The AMIs provided by most Linux distributions in AWS work well for most use
cases. However, there are those times when you need a customized image to
support a certain configuration or to speed up CI processes.

You can get a customized image via a few methods:

1. Build from an existing AMI, customize it, and snapshot it.
2. Use an automated tool, such as Packer, to automate #1.
3. Build your own image locally in KVM, VMware, or Virtualbox and upload the
   image into S3, import it into an EC2, and create an AMI from the snapshot.

My preferred option is the last method since the installation happens locally
and the image is first booted in AWS. This ensures that log files and
configurations are clean on first boot. Although this method produces the best
result, it has plenty of steps that can go wrong.

## Importing an image into AWS (the hard way)

AWS has [documentation for importing an image] and the basic steps include:

1. Install into a VM locally and customize it.
2. Snapshot the image and upload it into an S3 bucket.
3. Create an IAM role for `vmimport` so that EC2 can pull the image from S3
   and import it.
4. Run `aws ec2 import-snapshot` to tell EC2 to import the image.
5. Monitor the output of `aws ec2 describe-import-snapshot-tasks` until the
   snapshot fully imports into EC2. It might fail to import, so you need to be
   prepared for that. (If that happens, go back to step 4.)
6. Get the snapshot ID from the import.
7. Run `aws ec2 register-image` to create the AMI from the snapshot ID.

This is a lot of manual work. 😩

[documentation for importing an image]: https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html

## Using Image Builder to make images

Image Builder has two main components:

* [osbuild-composer] takes an image configuration and generates instructions
  for the image build stages (and optionally uploads an image to a cloud)
* [osbuild] takes those instructions and builds an image

[osbuild-composer]: https://github.com/osbuild/osbuild-composer
[osbuild]: https://github.com/osbuild/osbuild

The support for uploading to clouds first arrived in Fedora 32 and this post
will use that release for generating images.

To get started, install `osbuild-composer` along with `composer-cli`, a
command line interface to create images. Start the socket for
`osbuild-composer` as well:

```text
# dnf -y install composer-cli osbuild-composer
# systemctl enable --now osbuild-composer.socket
```

Verify that everything is working:

```text
# composer-cli sources list
fedora
updates
fedora-modular
updates-modular
```

We now need an image blueprint. A blueprint is a TOML file that provides some
basic specifications for the image, such as which packages to install, which
services should start at boot time, and the system's time zone. Refer to the
[Lorax composer documentation] for a full list of options.

In this example, we will build a small image with nginx to serve a website.
Here's the TOML file:

```toml
name = "aws-nginx"
description = "AWS nginx image"
version = "0.0.1"

[[packages]]
name = "chrony"

[[packages]]
name = "cloud-utils-growpart"

[[packages]]
name = "nginx"

[customizations.kernel]
append = "no_timer_check console=hvc0 LANG=en_US.UTF-8"

[customizations.services]
enabled = ["chronyd", "nginx"]

[customizations.timezone]
timezome = "UTC"
```

Our specification says:

* Build an image with `nginx` and ensure it starts at boot time
* Install `chrony` for time synchronization, set the time zone to UTC, and
  start it at boot time.
* Install `cloud-utils-growpart` so that cloud-init can automatically grow the
  root filesystem on the first boot
* Add some kernel boot parameters to ensure the serial console works in AWS

Push the blueprint into `osbuild-composer` and ensure the packages are
available. (The `depsolve` check is optional, but I recommend it so you can
find any typos in your package names.)

```text
# composer-cli blueprints push aws-image.toml
# composer-cli blueprints depsolve aws-nginx
blueprint: aws-nginx v0.0.1
    acl-2.2.53-5.fc32.x86_64
    alternatives-1.11-6.fc32.x86_64
    audit-libs-3.0-0.19.20191104git1c2f876.fc32.x86_64
    ...
```

We can now build the image:

```text
# composer-cli --json compose start aws-nginx ami
{
    "build_id": "285c1ee8-6b9e-4725-9c4c-346eafae86de",
    "status": true
}
# composer-cli --json compose status 285c1ee8-6b9e-4725-9c4c-346eafae86de
[
    {
        "id": "285c1ee8-6b9e-4725-9c4c-346eafae86de",
        "blueprint": "aws-nginx",
        "version": "0.0.1",
        "compose_type": "ami",
        "image_size": 0,
        "status": "RUNNING",
        "created": 1592578852.962228,
        "started": 1592578852.987541,
        "finished": null
    }
]
```

Our image is building! After a few minutes, the image is ready:

```text
# composer-cli --json compose status 285c1ee8-6b9e-4725-9c4c-346eafae86de
[
    {
        "id": "285c1ee8-6b9e-4725-9c4c-346eafae86de",
        "blueprint": "aws-nginx",
        "version": "0.0.1",
        "compose_type": "ami",
        "image_size": 6442450944,
        "status": "FINISHED",
        "created": 1592578852.962228,
        "started": 1592578852.987541,
        "finished": 1592579061.3364012
    }
]
# composer-cli compose image 285c1ee8-6b9e-4725-9c4c-346eafae86de
285c1ee8-6b9e-4725-9c4c-346eafae86de-image.vhdx: 1304.00 MB
# ls -alh 285c1ee8-6b9e-4725-9c4c-346eafae86de-image.vhdx
-rw-r--r--. 1 root root 1.3G Jun 19 15:12 285c1ee8-6b9e-4725-9c4c-346eafae86de-image.vhdx
```

We can take this image, upload it to S3 and import it into AWS using the
process mentioned earlier in this post. Or, we can have osbuild-composer do
this for us.

## Preparing for automatic AWS upload

Start by making a bucket in S3 in your preferred region. Mine is called
`mhayden-image-uploads`:

```text
# aws --region us-east-2 s3 mb s3://mhayden-image-uploads
make_bucket: mhayden-image-uploads
```

Now we need a role that allows EC2 to import images for us. Save this file as
`vmimport.json`:

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": { "Service": "vmie.amazonaws.com" },
         "Action": "sts:AssumeRole",
         "Condition": {
            "StringEquals":{
               "sts:Externalid": "vmimport"
            }
         }
      }
   ]
}
```

We now need a policy to apply to the `vmimport` role that allows EC2 to use
the role to download the image, import it, and register an AMI **(replace the
bucket name with your S3 bucket)**. Save this as `vmimport-policy.json`:

```json
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect": "Allow",
         "Action": [
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket"
         ],
         "Resource": [
            "arn:aws:s3:::mhayden-image-uploads",
            "arn:aws:s3:::mhayden-image-uploads/*"
         ]
      },
      {
         "Effect": "Allow",
         "Action": [
            "ec2:ModifySnapshotAttribute",
            "ec2:CopySnapshot",
            "ec2:RegisterImage",
            "ec2:Describe*"
         ],
         "Resource": "*"
      }
   ]
}
```

Add the role and the policy to IAM:

```text
# aws iam create-role --role-name vmimport \
    --assume-role-policy-document "file://vmimport.json"
# aws iam put-role-policy --role-name vmimport --policy-name vmimport \
    --policy-document "file://vmimport-policy.json"
```

## Building an image with automatic upload

We can use our same TOML blueprint we created earlier and provide one
additional TOML file that provides AWS configuration and credentials. Create
an `aws-config.toml` file with the following content:

```toml
provider = "aws"

[settings]
accessKeyID = "***"
secretAccessKey = "***"
bucket = "mhayden-image-uploads"
region = "us-east-2"
key = "fedora-32-image-from-my-blog-post"
```

Add your AWS credentials here along with your S3 bucket, preferred AWS region,
and an image key. The image key is the name applied to the snapshot and the
resulting AMI.

Now we can build our AMI and have it automatically uploaded:

```text
# composer-cli --json compose start aws-nginx ami fedora-32-image-from-my-blog-post aws-config.toml
{
    "build_id": "f343b20d-70f9-467a-9157-f9b4fc90ee87",
    "status": true
}
# composer-cli --json compose info f343b20d-70f9-467a-9157-f9b4fc90ee87
{
    "id": "f343b20d-70f9-467a-9157-f9b4fc90ee87",
    "config": "",
    "blueprint": {
        "name": "aws-nginx",
        "description": "AWS nginx image",
        "version": "0.0.1",
        "packages": [
            {
                "name": "chrony"
            },
            {
                "name": "cloud-utils-growpart"
            },
            {
                "name": "nginx"
            }
        ],
        "modules": [],
        "groups": [],
        "customizations": {
            "kernel": {
                "append": "no_timer_check console=hvc0 LANG=en_US.UTF-8"
            },
            "timezone": {},
            "services": {
                "enabled": [
                    "chronyd",
                    "nginx"
                ]
            }
        }
    },
    "commit": "",
    "deps": {
        "packages": []
    },
    "compose_type": "ami",
    "queue_status": "RUNNING",
    "image_size": 6442450944,
    "uploads": [
        {
            "uuid": "e747be78-87e2-48b9-b0d2-cc1bb393a9e4",
            "status": "RUNNING",
            "provider_name": "aws",
            "image_name": "fedora-32-image-from-my-blog-post",
            "creation_time": 1592580775.438667,
            "settings": {
                "region": "us-east-2",
                "accessKeyID": "***",
                "secretAccessKey": "***",
                "bucket": "mhayden-image-uploads",
                "key": "fedora-32-image-from-my-blog-post"
            }
        }
    ]
}
```

The output now shows an `uploads` section with the AWS upload details
included. This process may take some time, especially if your upload speed is
low. You can follow along with `composer-cli --json compose info` or you can
monitor the system journal:

```text
# journalctl -af -o cat -u osbuild-worker@1.service
Running job f343b20d-70f9-467a-9157-f9b4fc90ee87
2020/06/19 15:57:37 [AWS] 🚀 Uploading image to S3: mhayden-image-uploads/fedora-32-image-from-my-blog-post
2020/06/19 15:58:03 [AWS] 📥 Importing snapshot from image: mhayden-image-uploads/fedora-32-image-from-my-blog-post
2020/06/19 15:58:03 [AWS] ⏱ Waiting for snapshot to finish importing: import-snap-0f4baff3e1eb945a8
2020/06/19 16:04:50 [AWS] 🧹 Deleting image from S3: mhayden-image-uploads/fedora-32-image-from-my-blog-post
2020/06/19 16:04:51 [AWS] 📋 Registering AMI from imported snapshot: snap-0cf822f1441f9e407
2020/06/19 16:04:51 [AWS] 🎉 AMI registered: ami-0d0873cc888ab12a2
```

I ran this job on a small instance at Vultr and the whole process took about
10 minutes. The AWS image import process can vary a bit, but it's usually in
the range of 5-15 minutes.

At this point, I can take my new AMI (in my case, it's
`ami-0d0873cc888ab12a2`) and build instances at EC2! 🎉

## Wrapping up

Although there is some work involved in laying the groundwork for importing
images into EC2, this work only needs to be done one time. You can re-use your
existing AWS credentials TOML file over and over for new images that are made
from different blueprints.

You can also do almost all of this work via the [cockpit web interface] using
the `cockpit-composer` package if you prefer. The only downside to that method
is that some image customizations cannot be made through cockpit and some TOML
blueprint editing with `composer-cli` is needed. Look for that in a future
blog post.

[Lorax composer documentation]: https://weldr.io/lorax/lorax-composer.html#blueprints
[cockpit web interface]: https://cockpit-project.org/

*Photo credit: [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Shelekhov-aluminium-factory-4.jpg)*
