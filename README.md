## About this repository

This repo should exist on the ansible host and will be cloned to the guest machine.
It will live in `~/env`. A lot of commands implicitly assume this is where the repository exists

## Running the ansible playbook

Requires ansible be installed as well as the `community.general` collection.
We prefer using ansible >=2.13.17 through pip. 
This will ensure that `ansible-galaxy` and some of the popular collections, such as `community.general`, are installed as well.
The following should work on Ubuntu 22.04:

```bash
sudo apt remove ansible -y # Old version may already exist
pip install ansible
sudo apt install ansible -y
```

Prototyping/testing of the ansible playbook can be done with vagrant.
Vagrantfile is provided in this repo. From the base dir, one can run the following:

```bash
sudo apt install vagrant
vagrant up
vagrant provision # might be needed to run this if ssh authenthication fails
```

using `vagrant ssh` should give a virtual machine environment correctly set up.

Alternatively, we can run the playbook locally on a fresh Ubuntu install:

```
ansible-playbook -c local -i localhost, playbook.yml --ask-become-pass
```
