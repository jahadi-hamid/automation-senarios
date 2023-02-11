#!/bin/bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
dnf install terraform ansible
ansible-galaxy collection install community.general
ansible-galaxy install alexisfacques.ansible_module_s3_minio_bucket
