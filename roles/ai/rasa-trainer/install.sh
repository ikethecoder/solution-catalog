
mkdir -p /opt/ai

( cd /opt/ai && git clone https://github.com/RasaHQ/rasa-nlu-trainer )

( cd /opt/ai/rasa-nlu-trainer && docker build -t rasa_trainer . )

( cd /opt/ai/rasa-nlu-trainer && docker create -p 5001:8080 --name rasa_trainer -v rasa:/rasa-nlu-trainer/src/state rasa_trainer)


# Edited the Dockerfile to use : "-s", "state"

docker volume create --name rasa

docker volume inspect rasa

( cd /opt/ai/rasa-nlu-trainer && cp src/state/testData.json /var/lib/docker/volumes/rasa/_data/. )
