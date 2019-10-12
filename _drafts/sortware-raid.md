```bash
lsblk
```

Para listar los dispositivos

```
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda           8:0    0   3.7T  0 disk
`-sda1        8:1    0   511M  0 part
sdb           8:16   0   3.7T  0 disk
`-sdb1        8:17   0   511M  0 part
nvme1n1     259:0    0   477G  0 disk
|-nvme1n1p1 259:2    0   511M  0 part
|-nvme1n1p2 259:5    0  19.5G  0 part
| `-md2       9:2    0  19.5G  0 raid1 /
|-nvme1n1p3 259:7    0  1023M  0 part  [SWAP]
`-nvme1n1p4 259:9    0 455.9G  0 part
  `-md4       9:4    0 455.9G  0 raid1 /var
nvme0n1     259:1    0   477G  0 disk
|-nvme0n1p1 259:3    0   511M  0 part  /boot/efi
|-nvme0n1p2 259:4    0  19.5G  0 part
| `-md2       9:2    0  19.5G  0 raid1 /
|-nvme0n1p3 259:6    0  1023M  0 part  [SWAP]
`-nvme0n1p4 259:8    0 455.9G  0 part
  `-md4       9:4    0 455.9G  0 raid1 /var
```

Crear el array de discos en raid 1:

```
mdadm --create --verbose /dev/md6 --level=1 --raid-devices=2 /dev/sda /dev/sdb
```

Crear el sistema de ficheros:

```
mkfs -t ext4 /dev/md6
```

Para ver el estado del raid:

```
mdadm --detail /dev/md6
```

Vemos que empieza a resincronizar:

```
> cat /proc/mdstat
Personalities : [raid1]
md6 : active raid1 sdb[1] sda[0]
      3906886464 blocks super 1.2 [2/2] [UU]
      [=>...................]  resync =  9.8% (385586624/3906886464) finish=290.2min speed=202232K/sec
      bitmap: 28/30 pages [112KB], 65536KB chunk

md4 : active raid1 nvme1n1p4[1] nvme0n1p4[0]
      478049216 blocks [2/2] [UU]
      bitmap: 0/4 pages [0KB], 65536KB chunk

md2 : active raid1 nvme0n1p2[0] nvme1n1p2[1]
      20478912 blocks [2/2] [UU]

unused devices: <none>
```

Añadir la configuración al fichero `/etc/mdadm.conf`

```
mdadm --detail --brief /dev/md6 >> /etc/mdadm.conf
```

Buscamos el UUID del dispositivo con el comando `blkid`:

```
> blkid
/dev/nvme1n1p1: LABEL="EFI_SYSPART" UUID="367C-A19C" TYPE="vfat" PARTLABEL="primary" PARTUUID="6f05f011-587c-441d-bcdc-468b7dd675fc"
/dev/nvme1n1p2: UUID="5953c7e1-aeb3-cbbd-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="d6342152-20e6-4a84-a3c9-056348696e77"
/dev/nvme1n1p3: LABEL="swap-nvme1n1p3" UUID="9e2ec132-1c96-4efb-9c71-9c0203024b47" TYPE="swap" PARTLABEL="primary" PARTUUID="8b6762f4-aef6-43b2-b5ef-5d8ff0845b6f"
/dev/nvme1n1p4: UUID="bf94b32f-5d37-0027-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="logical" PARTUUID="90789773-8521-4035-b620-dd2c17e0e143"
/dev/nvme0n1p1: SEC_TYPE="msdos" LABEL="EFI_SYSPART" UUID="0290-BBA7" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="372d7763-fae8-4dd5-a000-470b00f83c01"
/dev/nvme0n1p2: UUID="5953c7e1-aeb3-cbbd-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="ed91b503-e12e-4804-9ba5-ddbdffb0a21a"
/dev/nvme0n1p3: LABEL="swap-nvme0n1p3" UUID="612c663a-8c8c-48b0-a903-0dcdf27129f4" TYPE="swap" PARTLABEL="primary" PARTUUID="68e88a4b-b0cc-4a55-a5b3-99fea91e3869"
/dev/nvme0n1p4: UUID="bf94b32f-5d37-0027-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="logical" PARTUUID="2bcea8d3-ea8d-4ffb-8044-25045a33c6c3"
/dev/md2: LABEL="/" UUID="9c213fbe-4e39-45a9-a44a-72122c09aa1b" TYPE="xfs"
/dev/sdb: UUID="456fa19a-5dee-98ed-74e2-187a1686992c" UUID_SUB="32793306-ee48-8d0a-8d26-ed0620c59178" LABEL="wozniak:6" TYPE="linux_raid_member"
/dev/md4: LABEL="/var" UUID="e4ae5ec6-b9c6-4b15-bb30-2922af36b07c" TYPE="xfs"
/dev/sda: UUID="456fa19a-5dee-98ed-74e2-187a1686992c" UUID_SUB="b421d676-bb48-bc9a-0b83-f9a6f95fa3c5" LABEL="wozniak:6" TYPE="linux_raid_member"
/dev/md6: UUID="427a480c-0d8d-4c44-a5bb-9ff2d28272ba" TYPE="ext4"
/dev/nvme1n1: PTUUID="ef01a674-ad03-42f6-a7f6-fae8c040189d" PTTYPE="gpt"
/dev/nvme0n1: PTUUID="9dce7179-0565-41a0-b125-f618eb8a246b" PTTYPE="gpt"
```

Y entonces añadimos la línea al fstab:

```
UUID=427a480c-0d8d-4c44-a5bb-9ff2d28272ba /mnt/data               ext4    defaults        0 1
```

Referencias:

* https://www.digitalocean.com/community/tutorials/how-to-manage-raid-arrays-with-mdadm-on-ubuntu-16-04
* https://linuxhint.com/uuid_storage_devices_linux/
