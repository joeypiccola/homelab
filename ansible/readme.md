# ansible

All things ansible.

## requirements

Install roles via the Galaxy.

`ansible-galaxy install -p ./galaxy_roles -r ./requirements.yml`

## .vault_pass

Simple file containing your vault password (excluded from this repo). This file is referenced in `ansible.cfg` via `vault_password_file`.

## keys

The public key `keys/id_rsa.pub` is in the repo but the private key `keys/id_rsa` is excluded from this repo. The private key is referenced in `group_vars/all.yml` via `ansible_ssh_private_key_file`.

## usage

ping all hosts.

`ansible -i hosts all -m ping`

run `pb_colo` playbook.

`ansible-playbook pb_colo.yml`
