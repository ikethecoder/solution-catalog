

git config --global user.name "SaaS Express Agent"
git config --global user.email "saas_express_agent@canzea.com"

git config --global credential.helper store

echo "http://esadmin:${GITEA_ROOT_TOKEN}@gitea.service.dc1.consul:11080" > /root/.git-credentials
chmod 600 /root/.git-credentials

yes | cp -f roles/workarounds/canzea-upgrade/config/config-upgrade.json /root/.ecosystem-catalog/config.json

canzea --util=add-env ECOSYSTEM_CONFIG_GIT "http://gitea.service.dc1.consul:11080/esadmin/ecosystems.git"

canzea --reset
