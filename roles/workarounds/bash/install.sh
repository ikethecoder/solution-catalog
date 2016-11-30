
# Convenience command for applying a template during a copy
# Reads all the ENV variables and puts them into the context for use in the template

# cpt <templated file> <output file>
echo "alias cpt='ruby /root/ike-environments/environment/production/init/template.rb'" >> ~/.bashrc

ruby roles/workarounds/bash/gen-set-environment-vars-script.rb

echo ". ~/.bash_ike" >> ~/.bashrc

