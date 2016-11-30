
mkdir -p /var/go/.local/bin

cp bin/canzea /var/go/.local/bin/.

chmod +x /var/go/.local/bin/canzea

rm -rf /var/go/.local/bin/ike-environments

(cd /var/go/.local/bin; git clone https://IKE_CI:55665566@gitlab.com/ikethecoder/ike-environments.git)

(cd /var/go/.local/bin; cp ike-environments/environment/production/bin/canzea .)

chown -R go:go /var/go/.local
