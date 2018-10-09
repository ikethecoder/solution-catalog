
mkdir -p /root/.ecosystem-catalog

yes | cp roles/workarounds/canzea/config/env.json /root/.ecosystem-catalog/env.json
yes | cp roles/workarounds/canzea/config/config.json /root/.ecosystem-catalog/config.json

yes | cp roles/workarounds/canzea/config/profiled.sh /etc/profile.d/hashicorp.sh


yes | cp roles/workarounds/canzea/config/canzea.bash /usr/local/sbin/canzea

chmod +x /usr/local/sbin/canzea

(cd roles/workarounds/canzea && docker build --tag canzea .)

