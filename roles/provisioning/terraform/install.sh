wget -nv --no-cookies --no-check-certificate https://releases.hashicorp.com/terraform/0.7.11/terraform_0.7.11_linux_amd64.zip

unzip -q terraform_0.7.11_linux_amd64.zip

cp terraform /usr/local/bin/.

chmod +x /usr/local/bin/terraform

yes | rm -f terraform terraform_0.7.11_linux_amd64.zip
