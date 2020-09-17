# ansible

All things ansible.

## current projects being managed here

- Homelab networks (Cisco switchces and Ubiquity router)
- RasPi environmental monitoring sensors
- Co-located RasPi for backups
- Various debian telgraf configs for RasPis and other debian systems
- RasPi doorbell

## requirements

Install roles via the Galaxy, if any.

`ansible-galaxy install -p ./galaxy_roles -r ./requirements.yml`

## .vault_pass

`.vault_pass` is a simple file containing your vault password (excluded from this repo). This file is referenced in `ansible.cfg` via `vault_password_file`.

## passwords for user module

Use the following to hash passwords for use with the Ansible user module. Might need to install `passlib` via `pip3 install passlib`.

```bash
python -c "from passlib.hash import sha512_crypt; import getpass; print(sha512_crypt.using(rounds=5000).hash(getpass.getpass()))"
```

## encryption

When running `ansbile` or `ansible-vault` it is reading your `ansible.cfg` file and the `vault_password_file` variable to see where your `.vault_pass` file is located.

### Variable-level encryption

To encrypt use `ansible-vault`.

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

To decrypt use `ansible` locally in debug.

```bash
> ansible localhost -m debug -a var='colo_ovpn_remote' -e "@./roles/colo/vars/main.yml"
localhost | SUCCESS => {
    "colo_ovpn_remote": "blah"
}
```

### File-level encryption

Fully encrypted files can be easily decrypted in VSCode using Eric's Ho's [ansible-vault](https://marketplace.visualstudio.com/items?itemName=dhoeric.ansible-vault) extension. You can also call `ansible-vault` directly to decrypt and encrypt files.

```bash
> ansible-vault decrypt ./roles/switch/vars/main.yml
Decryption successful
> ansible-vault encrypt ./roles/switch/vars/main.yml
Encryption successful
```

## keys

The public key `keys/id_rsa.pub` is in the repo but the private key `keys/id_rsa` is excluded from this repo. The private key is referenced in `group_vars/all.yml` via `ansible_ssh_private_key_file`.

## usage

ping all hosts.

`ansible -i hosts all -m ping`

run `pb_colo` playbook.

`ansible-playbook pb_colo.yml`
