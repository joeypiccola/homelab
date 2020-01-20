# cisco

All things cisco.

## bootstrapping

To get a wiped switch online paste the following via the console. You'll need to fill in `ip address` and `hostname`. Currently tested with 2960G.

```plaintext
enable
config t

ip default-gateway 10.0.2.1
int vlan 1
ip address 10.0.2.x 255.255.255.0
exit
ip name-server 10.0.3.24

hostname cs-logan-0
ip domain-name piccola.us

ip ssh version 2
no aaa new-model
system mtu routing 1500
ip subnet-zero
crypto key generate rsa general-keys modulus 2048

ip http server
ip http secure-server

line con 0
login local
privilege level 15
line vty 0 15
login local
transport input ssh
line vty 0 15
transport input ssh
exit

enable secret ******
username cisco privilege 15 password ******
service password-encryption
exit
wr
```
