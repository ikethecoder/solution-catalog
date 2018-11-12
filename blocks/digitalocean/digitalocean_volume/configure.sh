

sudo mkfs.ext4 /dev/disk/by-id/scsi-0DO_Volume_working

mkdir -p /mnt/working

mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_working /mnt/working

echo /dev/disk/by-id/scsi-0DO_Volume_working /mnt/working ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
