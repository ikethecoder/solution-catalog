
mkdir -p /opt/ai

( cd /opt/ai && git clone https://github.com/RasaHQ/rasa-nlu-trainer )

( cd /opt/ai/rasa-nlu-trainer && docker build -t rasa_trainer . )

( cd /opt/ai/rasa-nlu-trainer && docker create -p 5001:8080 --name rasa_trainer rasa_trainer)

