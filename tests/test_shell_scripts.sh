#!/bin/bash
# Shellcheck and basic integrity tests for install.sh and bootstrap.sh
shellcheck /home/netyeti/Audit/install.sh
echo 'Checking shell script: install.sh'

shellcheck ./bootstrap.sh
echo 'Checking shell script: bootstrap.sh'