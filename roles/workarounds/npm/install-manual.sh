
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -

yum -y remove nodejs.x86_64

yum -y install nodejs

yum -y remove npm.x86_64

npm install npm@latest -g
