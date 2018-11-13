---
title: Deploying OpenStack-Ansible for the first time
author: Major Hayden
type: post
date: -001-11-30T00:00:00+00:00
draft: true
url: /?p=6047
medium_post:
  - 'O:11:"Medium_Post":9:{s:16:"author_image_url";N;s:10:"author_url";N;s:10:"cross_link";s:3:"yes";s:2:"id";N;s:21:"follower_notification";s:3:"yes";s:7:"license";s:11:"cc-40-by-sa";s:14:"publication_id";s:2:"-1";s:6:"status";s:6:"public";s:3:"url";N;}'
categories:
  - Blog Posts

---
Get networking configs right

apt-get -y install bridge-utils vlan

Reboot

Distribute root's ssh keys

apt-get -y install git-core tmux

echo "set -g terminal-overrides 'xterm*:smcup@:rmcup@'" >> ~/.tmux.conf

git clone https://github.com/openstack/openstack-ansible -branch liberty /opt/openstack-ansible

tmux

cd /opt/openstack-ansible

scripts/bootstrap-ansible.sh

rsync -avz etc/openstack\_deploy/ /etc/openstack\_deploy

Drop openstack\_user\_config.yml

Adjust user_variables.yml

export DEPLOY_TEMPEST=no

http://docs.openstack.org/developer/openstack-ansible/install-guide/configure-creds.html

scripts/run-playbooks.sh
