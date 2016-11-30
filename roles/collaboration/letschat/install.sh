

docker run -d --name some-mongo mongo:latest

docker run  --name some-letschat --link some-mongo:mongo -p 8680:8080 -d sdelements/lets-chat
