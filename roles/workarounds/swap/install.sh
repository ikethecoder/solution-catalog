
dd if=/dev/zero of=/swapfile bs=1024 count=500000

mkswap /swapfile

swapon /swapfile
