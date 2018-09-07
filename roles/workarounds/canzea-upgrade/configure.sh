

git config --global user.name "SaaS Express Agent"
git config --global user.password "support@canzea.com"

git config --global credential.helper store

echo "http://esadmin:${GITEA_ROOT_TOKEN}@@gitea.service.dc1.consul:11080" > /root/.git-credentials
chmod 600 /root/.git-credentials

yes | cp -f roles/workarounds/canzea-upgrade/config/config-upgrade.json /root/.ecosystem-catalog/config.json

canzea --reset
