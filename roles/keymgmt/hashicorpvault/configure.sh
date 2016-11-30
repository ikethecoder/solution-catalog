
# https://www.vaultproject.io/docs/config/index.html

sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

ruby ./init/template.rb roles/keymgmt/hashicorpvault/config/vault.service /etc/systemd/system/multi-user.target.wants/vault.service
ruby ./init/template.rb roles/keymgmt/hashicorpvault/config/vault.config /etc/vault.config


