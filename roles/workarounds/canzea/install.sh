
mkdir -p /root/.ecosystem-catalog

yes | cp roles/workarounds/canzea/config/env.json /root/.ecosystem-catalog/env.json
# yes | cp roles/workarounds/canzea/config/config.json /root/.ecosystem-catalog/config.json

canzea --config_git_commit --template=roles/workarounds/canzea/config/config.json /root/.ecosystem-catalog/config.json '{catalogBranch:$CATBRANCH}'

yes | cp roles/workarounds/canzea/config/profiled.sh /etc/profile.d/hashicorp.sh

(cd roles/workarounds/canzea && docker build --tag canzea .)

yes | cp roles/workarounds/canzea/config/canzea.bash /usr/local/sbin/canzea_c

chmod +x /usr/local/sbin/canzea_c


