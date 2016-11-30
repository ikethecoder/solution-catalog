

yum -y install python-simplejson


git clone https://github.com/deanwilson/yum-transaction-json.git

cp yum-transaction-json/transaction-json.py /usr/lib/yum-plugins/


cp yum-transaction-json/transaction-json.conf /etc/yum/pluginconf.d/transaction-json.conf

rm -rf yum-transaction-json

# Pretty prints the json of what needs updating
yum update -q --json | python -m json.tool

# yum info collectd -q --json | python -m json.tool

# yum -y install yum-utils
