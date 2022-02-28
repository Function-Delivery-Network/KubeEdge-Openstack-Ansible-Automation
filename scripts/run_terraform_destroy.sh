#!/usr/bin/env bash
source ~/.bashrc
cd ..
. di57dot-openrc.sh
terraform  destroy -auto-approve -lock=false
