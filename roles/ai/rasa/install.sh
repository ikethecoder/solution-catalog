
mkdir -p /opt/ai

( cd /opt/ai && git clone https://github.com/RasaHQ/rasa_nlu.git )

( cd /opt/ai/rasa_nlu && docker build -t rasa_nlu . )

( cd /opt/ai/rasa_nlu && docker create -p 5000:5000 --name rasa_nlu rasa_nlu start )

# curl 'http://localhost:5000/parse?q=hello'
