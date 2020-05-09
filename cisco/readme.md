# cisco

All things cisco.

## notes

- On first pass of a new switch it might take a bit for VTP to pull in the VLANs resulting in access port configs to fail.

## usb serial

Find and download `MacOSX_1.6.1_20160309.pkg` for your TrendNet `TU-S9`. Do not have the usb2serial connected when installed!

`/Volumes/s$/applications/mac/usb2serial/Mac_TU-S9(10.9-10.12)/MacOSX_1.6.1_20160309.pkg`

Find the usb device.

`ls -la /dev/tty.us*`

Connect to the usb device with screen.

`screen /dev/tty.usbserial`

Maybe on a different port (e.g. Ubiquity).

`screen /dev/tty.usbserial 115200`

## wipe

Connect up your console cable and power on the switch while holding down the “mode” button.

```plaintext
switch:
switch: flash_init
switch: del flash:config.text
switch: del flash:vlan.dat
switch: boot
```

## bootstrap

To get a wiped switch online paste the following via the console. You'll need to fill in `ip address` and `enable secrets \ password`. Currently tested with 2960G & 2960S.

```plaintext
enable
config t

vtp mode off

ip default-gateway 10.0.2.1
int vlan 1
ip address 10.0.2.x 255.255.255.0
exit
ip name-server 10.0.3.24

hostname switch
ip domain-name piccola.us

ip ssh version 2
no aaa new-model
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

## vlan 2 / managment / uplink trunk

Once up and running move to `VLAN2` as management VLAN. Commands may vary, not tested.

```plaintext
config t
int vlan 1
no ip address
exit
int vlan 2
ip address x.x.x.x 255.255.255.0
exit
vlan 2
name mgmt
exit
wr
```

Then setup trunk port (maybe upgade first)

```plaintext
interface GigabitEthernet0/24
 description xx-logan-0 <-> xx-logan-0
 switchport trunk native vlan 2
 switchport mode trunk
```

## upgrade

Get the current booted version.

```plaintext
Switch#sh boot | in BOOT
BOOT path-list      : flash:c2960s-universalk9-mz.150-2.SE10a.bin
```

See what's in `flash:`.

```plaintext
Switch#dir flash:
Directory of flash:/
    2  -rwx    10988049   Mar 1 1993 00:15:48 +00:00  c2960s-universalk9-mz.122-55.SE11.bin
    3  -rwx        6168   Jan 2 2006 00:02:16 +00:00  multiple-fs
    4  -rwx    14571904  May 25 2017 18:18:51 +00:00  c2960s-universalk9-mz.150-2.SE10a.bin

57931776 bytes total (32155648 bytes free)
```

Maybe delete unused images or files.

```plaintext
Switch#delete flash:c2960s-universalk9-mz.122-55.SE11.bin
Delete filename [c2960s-universalk9-mz.122-55.SE11.bin]?
Delete flash:/c2960s-universalk9-mz.122-55.SE11.bin? [confirm]
```

Setup a tftp server and copy over your image.

```bash
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
sudo launchctl start com.apple.tftpd
sudo cp ~/Downloads/c2960s-universalk9-mz.152-2.E9.bin /private/tftpboot/
```

Copy image.

```plaintext
switch#copy tftp flash
Address or name of remote host []? 10.0.3.102
Source filename []? c2960s-universalk9-mz.152-2.E9.bin
Destination filename [c2960s-universalk9-mz.152-2.E9.bin]?
Accessing tftp://10.0.3.102/c2960s-universalk9-mz.152-2.E9.bin...
```

Verify image on client.

```bash
md5 c2960s-universalk9-mz.152-2.E9.bin
MD5 (c2960s-universalk9-mz.152-2.E9.bin) = ea604d030b378b6c5c3dda3d501ac2f5
```

Verify image on switch.

```plaintext
switch#verify /md5 flash1:c2960s-universalk9-mz.152-2.E9.bin
......Done!
verify /md5 (flash:c2960s-universalk9-mz.152-2.E9.bin) = ea604d030b378b6c5c3dda3d501ac2f5
```

Set boot image

Note: `switch all` is specific to stacked switches.

```plaintext
config t
boot system switch all flash:c2960s-universalk9-mz.152-2.E9.bin
exit
```

Get the booted version again.

```plaintext
Switch#sh boot | in BOOT
BOOT path-list      : flash:c2960s-universalk9-mz.150-2.SE10a.bin
```

Write and reload.

```plaintext
wr
reload
```
