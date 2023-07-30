# Proxmox Settings

## GPU-passthrough

- edit grub configuration to enable IOMMU

````=bash
# backup old grub
mv /etc/default/grub /etc/default/grub.bak

# update new grub
mv ./grub /etc/default/grub

# update grub
update-grub
````

- add modules to ``/etc/modules``

````
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
````

- IOMMU interrupt mapping

```
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf
```
- blacklist drivers

```
echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
```
- use ``lspci`` to find your gpu

- output the vendor ID(s) of the devices
````
#replace the device identifier (01:00) if needed
lspci -n -s 01:00
````

- replace the vendor ids from the output of the previous step if needed
````
echo "options vfio-pci ids=10de:2504,10de:228e disable_vga=1" > /etc/modprobe.d/vfio.conf
# update initramfs
update-initramfs -u
# reboot proxmox host
reboot now
````
