#!/bin/bash

ansible-playbook -u vagrant --private-key /home/marius/Yonder/Vagrant/.vagrant/machines/proxy/libvirt/private_key -i 10.143.20.2, /home/marius/Yonder/Vagrant/global/scripts/ansible/install.yml
ansible-playbook -u vagrant --private-key /home/marius/Yonder/Vagrant/.vagrant/machines/proxy/libvirt/private_key -i 10.143.20.2, /home/marius/Yonder/Vagrant/global/users/ansible/users.yml
ansible-playbook -u vagrant --private-key /home/marius/Yonder/Vagrant/.vagrant/machines/proxy/libvirt/private_key -i 10.143.20.2, certificate.yml
ansible-playbook -u vagrant --private-key /home/marius/Yonder/Vagrant/.vagrant/machines/proxy/libvirt/private_key -i 10.143.20.2, install.yml
ansible-playbook -u vagrant --private-key /home/marius/Yonder/Vagrant/.vagrant/machines/proxy/libvirt/private_key -i 10.143.20.2, nginx.yml
