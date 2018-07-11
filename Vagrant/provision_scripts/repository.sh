#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install vim