

## Running the ansible playbook

Requires ansible be installed as well as the `community.general` collection.
We prefer using ansible >=2.13.17 through pip. The following should work:

```bash
sudo apt remove ansible -y # Old version may already exist
pip install ansible
sudo apt install ansible -y
```
