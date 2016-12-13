
# https://www.vaultproject.io/docs/config/index.html

sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.service /etc/systemd/system/multi-user.target.wants/vault.service
canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.config /etc/vault.config


