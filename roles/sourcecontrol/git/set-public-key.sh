cat ~/.ssh/id_rsa.pub | ssh -o StrictHostKeyChecking=no git@localhost "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
