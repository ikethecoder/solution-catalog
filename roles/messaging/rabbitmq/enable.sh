
sudo service rabbitmq-server start

# Need rabbitmq running to do this
rabbitmqctl add_user ike geekkb
rabbitmqctl set_user_tags ike administrator
rabbitmqctl set_permissions -p / ike ".*" ".*" ".*"
