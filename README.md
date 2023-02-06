## About this repository

This repo should exist on the ansible host and will be cloned to the guest machine.
It will live in `~/env`. A lot of commands implicitly assume this is where the repository exists

## Running the ansible playbook

Requires ansible be installed as well as the `community.general` collection.
We prefer using ansible >=2.13.17 through pip. The following should work:

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

using `vagrant ssh` should give a virtual machine environment correctly set up
