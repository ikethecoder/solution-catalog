# A git repository is setup
# Create user (on remote machine)
# Register public key in Vault (on remote machine)
# Create user (local) and register public key (local)
# SSH Link established

git config --global user.email "you@example.com"
git config --global user.name "Your Name"


mkdir /opt/cloud-profile
(cd /opt/cloud-profile && git init)
(cd /opt/cloud-profile && touch README.md)
(cd /opt/cloud-profile && git add -A && git commit -m"Initial")


cp roles/workarounds/cloud-profile/per-instance/configure.sh /var/lib/cloud/scripts/per-instance/configure.sh
