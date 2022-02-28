#!/usr/bin/env bash
source ~/.bashrc
cd ..
source di57dot-openrc.sh
terraform init
terraform apply -auto-approve -lock=false
