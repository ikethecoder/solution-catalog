

#
# sudo openssl genrsa -out /etc/nginx/ssl/canzea.com.key 2048

# sudo openssl req -new -sha256 -key /etc/nginx/ssl/canzea.com.key -out  /etc/nginx/ssl/canzea.com.csr

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CA
State or Province Name (full name) []:British Columbia
Locality Name (eg, city) [Default City]:Vancouver
Organization Name (eg, company) [Default Company Ltd]:Canzea Technologies
Organizational Unit Name (eg, section) []:IT
Common Name (eg, your name or your server's hostname) []:canzea.com
Email Address []:aidan.cope@canzea.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:



# sudo cat /etc/nginx/ssl/canzea.com.csr
#

# Submit to certificate provider

# Update DNS canzea.com

#



# GET THE CERTIFICATE

# export VAULT_TOKEN=990cc0fc-fec8-e0dc-b8f9-817e63b58565

# canzea --lifecycle=wire --solution=vault --action=get-secret --args='{"key":"ssl/canzea"}' --raw

# mkdir -p /etc/nginx/ssl/canzea.com

export SSL_DETAIL=`canzea --lifecycle=wire --solution=vault --action=get-secret --args='{"key":"ssl/canzea"}' --raw`

# Create SSL config file

# sudo -E bash -c "ruby r.rb"


# sudo -E bash -c "cat /etc/nginx/ssl/canzea.com.ca /etc/nginx/ssl/canzea.com.crt > /etc/nginx/ssl/canzea.com.bundle"

sudo -E bash -c "cat /etc/nginx/ssl/canzea.com.crt > /etc/nginx/ssl/canzea.com.bundle"
sudo -E bash -c "cat /etc/nginx/ssl/canzea.com.ca >> /etc/nginx/ssl/canzea.com.bundle"

# sudo vi /etc/nginx/conf.d/ssl.conf

# sudo systemctl restart nginx

require 'json'

data = JSON.parse(ENV['SSL_DETAIL'])
puts data['ca']
puts data['certificate']

File.write('/etc/nginx/ssl/canzea.com.ca', data['ca'])
File.write('/etc/nginx/ssl/canzea.com.crt', data['certificate'])


# Create the DHPARAM for SSL
(cd /etc/nginx/ssl && openssl dhparam -out dhparam.pem 4096)

