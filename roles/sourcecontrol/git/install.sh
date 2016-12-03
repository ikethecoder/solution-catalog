
#  https://www.linux.com/learn/how-run-your-own-git-server

yum -y install git-core

adduser git

export TMP_PASSWORD=get1git; expect roles/application/user/set-password.expect git

sudo -E -u git expect roles/application/user/key-gen.expect

sudo -E -u root expect roles/application/user/key-gen.expect

chmod +x roles/sourcecontrol/git/set-public-key.sh

export TMP_PASSWORD=get1git; expect roles/sourcecontrol/git/set-public-key.expect

chmod 600 /home/git/.ssh/authorized_keys
