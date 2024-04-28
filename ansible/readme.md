# ansible

All things ansible.

## current projects being managed here

- home raspi (ups-monitoring, external-ip-monitoring, tailscale node)
- colo raspi (external-ip-monitoring, file-backup, tailscale node)
- network routers and switches

## requirements

Install roles via the Galaxy, if any.

`ansible-galaxy install -p ./galaxy_roles -r ./requirements.yml`

## .vault_pass

`.vault_pass` is a simple file containing your vault password (excluded from this repo). This file is referenced in `ansible.cfg` via `vault_password_file`.

## passwords for user module

Use the following to hash passwords for use with the Ansible user module. Might need to install `passlib` via `pip3 install passlib`.

```bash
python3 -c "from passlib.hash import sha512_crypt; import getpass; print(sha512_crypt.using(rounds=5000).hash(getpass.getpass()))"
```

## encryption

When running `ansbile` or `ansible-vault` it is reading your `ansible.cfg` file and the `vault_password_file` variable to see where your `.vault_pass` file is located.

### file and variable encryption

There is the easy way and the hard way ¯\_(ツ)_/¯.

#### The hard way

To encrypt the hard way use `ansible-vault`.

```bash
> ansible-vault encrypt_string 'mySecret' --name 'myVar'
myVar: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          63346636616363326366623730353436343939316265313261376539666339643563636132623061
          3836613632333335663631333834663135616436613336350a346233366633323033306561653062
          62313233376538376164633533646433623734333332643034636436396366353362393233353731
          3930343939643033630a316664313135653030666532643235333765653638613362313334313362
          3732
Encryption successful
```

To decrypt the hard way use `ansible` locally in debug.

```bash
> ansible localhost -m debug -a var='colo_ovpn_remote' -e "@./roles/colo/vars/main.yml"
localhost | SUCCESS => {
    "colo_ovpn_remote": "blah"
}
```

Example below for full files.

```bash
> ansible-vault decrypt ./roles/switch/vars/main.yml
Decryption successful
> ansible-vault encrypt ./roles/switch/vars/main.yml
Encryption successful
```

#### The easy way

Use wolfmah's [ansible-vault-inline](https://marketplace.visualstudio.com/items?itemName=wolfmah.ansible-vault-inline&ssr=false#overview) extension. Use cmd + option + 0 (zero).

<img src="docs/enc_demo.gif" width="500">

## keys

The public key `keys/id_rsa.pub` is in the repo but the private key `keys/id_rsa` is excluded from this repo. The private key is referenced in `group_vars/all.yml` via `ansible_ssh_private_key_file`.

## usage

list hosts.

`ansible all --list-hosts`

ping all hosts with the `ping` module.

`ansible switches -m ping`

run `pb_colo` playbook.

`ansible-playbook pb_colo.yml`

run `pb_network` which includes `switches` and `network` but only run it on `switches` with `--limit`.

`ansible-playbook pb_network.yml --limit switches`
