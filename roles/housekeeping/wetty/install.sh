
mkdir -p /opt/housekeeping

( cd /opt/housekeeping && git clone https://github.com/krishnasrinivas/wetty )

( cd /opt/housekeeping/wetty && docker build -t wetty . )

( cd /opt/housekeeping/wetty && docker create -p 3000:3000 --name wetty wetty)
