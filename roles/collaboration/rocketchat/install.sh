
# docker pull rocketchat/rocket.chat:latest

docker create --name db -d mongo --smallfiles

docker create --name rocketchat --link db -p 8780:3000 -d rocket.chat

# 0e241fa3dba894af93b2a4b5dde271137294257cbffd23a6b299e5a8c7be97aa


# docker run -a db
# docker run -a rocketchat

