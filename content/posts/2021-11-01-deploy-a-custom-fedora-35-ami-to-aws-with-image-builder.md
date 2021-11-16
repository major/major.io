---
author: Major Hayden
categories:
- Blog Posts
date: '2021-11-16'
description: >-
  Want to build your own Fedora 35 image for AWS? Use Image Builder to build
  and deploy an image made just for you. 🏗
images:
- images/2021-11-16-construction-cranes.jpg
slug: deploy-custom-fedora-35-aws-image-builder
tags:
- amazon
- aws
- cloud
- imagebuilder
- fedora
- linux
title: Deploy a custom Fedora 35 AMI to AWS with Image Builder
type: post
---

{{< figure src="/images/2021-11-16-construction-cranes.jpg" alt="Construction cranes over city landscape" position="center" >}}

[Fedora] reigns supreme as my Linux distribution of choice when I deploy new
workloads to public clouds. It gives me a well-tested, modern Linux system with
tons of helpful tools.

Fedora's [cloud images] provide a great base to begin building a cloud
deployment, but sometimes I find myself wanting a highly customized image with
some features I care about. For example, I may want some packages pre-installed
that aren't included with the default cloud image, or I may want certain
services stopped or started at boot time.

Fortunately, Fedora includes [Image Builder]. Image Builder does the hard work
of building your image, uploading it to a cloud provider, and then registering
that image. It has built-in support for handing AMIs (Amazon Machine Images) at
AWS and you can use it as a one-stop-shop for customizing an AMI for your use
case.

[Fedora]: https://getfedora.org/
[cloud images]: https://alt.fedoraproject.org/cloud/
[Image Builder]: https://www.osbuild.org/documentation/

## Configure the AWS cli

Start by installing the `awscli` package:

```console
$ sudo dnf install awscli
```

The cli will need some way to access your AWS account. I usually create an
administrative user and attach an administrative policy to the user. This allows
me to control my entire account via the cli tool.

💣 _(Note: Although this works well for my simple uses here, be careful using
administrative users on large accounts. You may want to be more restrictive with
your IAM policies, but that's a topic for a different post.)_

We start by accessing the [IAM] dashboard in your AWS account. Follow these
steps:

1. Click **Users** on the left and then **Add users** on the right
2. Enter a name for your user _(I used `desktop-cli`)_
3. Click the **Acces key - Programmatic access** checkbox
4. Click **Next: Permissions**
5. Click **Attach existing policies directly** and then tick the box next to
   **Administrator Access**
6. Click **Next: Tags** and add any tags if your organization requires them
7. Click **Next: Review** and then **Create User**

The next screen shows your **Access key ID** and your **Secret access key**.
Click **Show** to display your secret access key. Go back to your cli tool and
run the configuration command:

```console
$ aws configure --profile personal
AWS Access Key ID [None]: << enter your access key id here >>
AWS Secret Access Key [None]:<< enter your secret access key here >>
Default region name [None]: us-east-1
Default output format [None]:
```

Let's verify that the credentials work:

```console
$ aws --profile personal sts get-caller-identity
{
    "UserId": "xxx",
    "Account": "xxx",
    "Arn": "arn:aws:iam::xxx:user/desktop-cli"
}
```

To avoid typing your profile over and over, just export an environment variable:

```console
$ export AWS_PROFILE=personal
```

[IAM]: https://console.aws.amazon.com/iamv2/home?#/users

## Preparing permissions for image imports

When you import images into AWS, some services must take action on your behalf
to copy your image from S3 into an EBS snapshot, and then register that snapshot
as an AMI. This requires an S3 bucket and some extra permissions for some AWS
services.

First off, let's create an S3 bucket to hold our image:

```console
$ aws s3 mb s3://image-upload-bucket-blog-post
make_bucket: image-upload-bucket-blog-post
```

From here, we follow the [AWS documentation for importing images] with some
slight modifications for Image Builder. Save this file as `trust-policy.json`:

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

Now we create the `vmimport` role with the policy that allows AWS to assume this
role and import an image:

```console
$ aws iam create-role --role-name vmimport \
    --assume-role-policy-document "file://trust-policy.json"
```

We need to set some policy for our new `vmimport` role now to limit what AWS is
allowed to do in our account. Save the following as `role-policy.json`:

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
            "arn:aws:s3:::image-upload-bucket-blog-post",
            "arn:aws:s3:::image-upload-bucket-blog-post/*"
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

🛑 Stop here and change `image-upload-bucket-blog-post` to the S3 bucket name
that you used in the first step of this section.

```console
$ aws iam put-role-policy --role-name vmimport --policy-name vmimport \
    --policy-document "file://role-policy.json"
```

Image Builder also needs a user that can perform some functions inside AWS to
upload and import the image. Let's create a policy for a new user and save it as
`image-builder-policy.json`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:RegisterImage",
                "ec2:ImportSnapshot",
                "ec2:DescribeImportSnapshotTasks"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::image-upload-bucket-blog-post/*"
        }
    ]
}
```

Add the policy, create a user, and attach the policy to your user:

```console
$ aws iam create-policy --policy-name imagebuilder \
    --policy-document "file://image-builder-policy.json"
$ aws iam create-user --user-name imagebuilder
$ aws iam attach-user-policy --user-name imagebuilder \
    --policy-arn arn:aws:iam::YOUR_ACCOUNT_NUMBER:policy/imagebuilder
```

The ARN for your IAM policy includes your account number and the ARN should
appear after running the `create-policy` command.

[AWS documentation for importing images]: https://docs.aws.amazon.com/vm-import/latest/userguide/vmie_prereqs.html#vmimport-role

## Install Image Builder

It's no secret that I love good command line tools over graphical interfaces, so
we will follow the cli steps for Image Builder in the remainder of this post.
Let's start by installing everything we need for Image Builder and starting the
socket activation unit:

```console
$ sudo dnf install composer-cli osbuild-composer
$ sudo systemctl enable --now osbuild-composer.socket
```

Verify that `osbuild-composer` is listening:

```console
$ composer-cli status show
API server status:
    Database version:   0
    Database supported: true
    Schema version:     0
    API version:        1
    Backend:            osbuild-composer
    Build:              NEVRA:osbuild-composer-%{epoch}:37-1.fc35.x86_64
```

That was easy!

## Build and deploy our AMI

Image Builder uses specifications called [blueprints]. These are TOML files that
tell Image Builder how to configure your image. You can configure these in many
different ways, but here's the one I'm using for this post:

```toml
name = "major-perfect-f35"
description = "Major's perfect Fedora 35 cloud image"
version = "0.0.1"

[[packages]]
name = "firewalld"

[[packages]]
name = "tmux"

[[packages]]
name = "vim"

[[packages]]
name = "zsh"

[[customizations.user]]
name = "major"
key = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIcfW3YMH2Z6NpRnmy+hPnYVkOcxNWLdn9VmrIEq3H0Ei0qWA8RL6Bw6kBfuxW+UGYn1rrDBjz2BoOunWPP0VRM= major@amdbox"
shell = "/usr/bin/zsh"
groups = ["wheel"]

[customizations.timezone]
timezone = "America/Chicago"

[customizations.firewall.services]
enabled = ["ssh", "dhcpv6-client"]

[customizations.services]
enabled = ["sshd", "firewalld"]
```

I saved this file as `image.toml`. The next step involves pushing the blueprint
and solving the dependencies in the blueprint:

```console
$ composer-cli blueprints push image.toml
$ composer-cli blueprints depsolve major-perfect-f35
```

We need some extra configuration to tell Image Builder how to authenticate with
AWS. Save this file as `aws.toml`:

```ini
provider = "aws"

[settings]
accessKeyID = "YOUR_ACCESS_KEY_ID"
secretAccessKey = "YOUR_SECRET_ACCESS_KEY"
bucket = "image-upload-bucket-blog-post"
region = "us-east-1"
key = "major-perfect-f35"
```

Replace the bucket name with your S3 bucket and set an S3 object name in `key`.
To get your access key and secret access key, run this command:

```console
$ aws iam create-access-key --user imagebuilder
```

Finally, we're ready to tell Image Builder to deploy our image! Run this last
command to start the compose:

```console
composer-cli compose start major-perfect-f35 ami major-perfect-f35 aws.toml
```

Replace `major-perfect-35` with the name in your blueprint. Now, follow along in
the system journal as your image is deployed:

```text
[AWS] 🚀 Uploading image to S3: image-upload-bucket-blog-post/major-perfect-f35
[AWS] 📥 Importing snapshot from image: image-upload-bucket-blog-post/major-perfect-f35
[AWS] 🚚 Waiting for snapshot to finish importing: import-snap-06bc48cb9779f98d8
[AWS] 🧹 Deleting image from S3: image-upload-bucket-blog-post/major-perfect-f35
[AWS] 📋 Registering AMI from imported snapshot: snap-02ed2710572b7b94b
[AWS] 🎉 AMI registered: ami-0964ea222b6a6711e
```

(Don't ask me who put all of the emojis in the logging code. 🤭)

Let's verify that our image is fully imported:

```console
$ aws ec2 describe-images --filters "Name=tag:Name,Values=major-perfect-f35"
{
    "Images": [
        {
            "Architecture": "x86_64",
            "CreationDate": "2021-11-16T18:12:33.000Z",
            "ImageId": "ami-0964ea222b6a6711e",
            "ImageLocation": "xxx/major-perfect-f35",
            "ImageType": "machine",
            "Public": false,
            "OwnerId": "xxx",
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "State": "available",
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1",
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "SnapshotId": "snap-02ed2710572b7b94b",
                        "VolumeSize": 6,
                        "VolumeType": "gp2",
                        "Encrypted": false
                    }
                }
            ],
            "EnaSupport": true,
            "Hypervisor": "xen",
            "Name": "major-perfect-f35",
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "major-perfect-f35"
                }
            ],
            "VirtualizationType": "hvm"
        }
    ]
}
```

Go forth and build instances with your new, customized Fedora 35 AMI! 🎉

[blueprints]: https://www.osbuild.org/guides/blueprint-reference/blueprint-reference.html

*Photo credit: [Svetlozar Apostolov](https://unsplash.com/photos/I_AcuSVwGYU)*
