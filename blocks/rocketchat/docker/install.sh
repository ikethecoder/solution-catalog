
docker create --name db mongo:3.4.10 --smallfiles

docker create --name rocketchat --link db -p 8780:3000 rocket.chat:0.68.5

# 0e241fa3dba894af93b2a4b5dde271137294257cbffd23a6b299e5a8c7be97aa


# docker run -a db
# docker run -a rocketchat

