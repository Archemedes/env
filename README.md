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
