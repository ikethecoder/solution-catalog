
yes | cp roles/workarounds/canzea-upgrade/config/config-upgrade.json /root/.ecosystem-catalog/config.json


git config --global user.name "SaaS Express Agent"
git config --global user.password "support@canzea.com"

git config --global credential.helper store

export URL=SECRET_SERVICE_GITEA_ESADMIN_CREDENTIALS_URL

echo "https://esadmin:${SECRET_GITEA_ROOT_TOKEN}@${URL}" > /root/.git-credentials
chmod 600 /root/.git-credentials

