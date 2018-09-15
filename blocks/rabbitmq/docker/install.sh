

docker create --name rabbitmq --hostname mq -p 5672:5672 -p 15672:15672 -v /var/local/rabbitmq/data:/var/lib/rabbitmq/mnesia/rabbit@mq rabbitmq:3.7.7-management
