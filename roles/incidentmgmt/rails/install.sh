
adduser rails

gpasswd -a rails rails


# Install RVM

su rails -l -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"

su rails -l -c "curl -sSL https://get.rvm.io | bash -s stable --ruby"

su rails -l -c "source /home/rails/.rvm/scripts/rvm"

su rails -l -c "ruby -v"

su rails -l -c "/home/rails/.rvm/bin/rvm --default"

su rails -l -c "ruby -v"

su rails -l -c "gem list"

su rails -l -c "rvm install 2.2.1"

su rails -l -c "rvm rvmrc warning ignore allGemfiles"

su rails -l -c "rvm use ruby-2.2.1 --default"




