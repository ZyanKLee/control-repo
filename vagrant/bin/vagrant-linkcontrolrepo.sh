#!/bin/bash
env=${1:production}
mount_dir=${2:-'/vagrant_puppet'}

link_controlrepo() {
  echo "### Linking Puppet ${1} environment to local development directory."
  if [ -d /etc/puppetlabs/code/environments/$1 ]; then
    mv /etc/puppetlabs/code/environments/$1 /etc/puppetlabs/code/environments/$1_$(date +%Y%m%d_%H%M%S)
  fi
  ln -sf $mount_dir /etc/puppetlabs/code/environments/$1
}

[ -L /etc/puppetlabs/code/environments/production ] || link_controlrepo $env

