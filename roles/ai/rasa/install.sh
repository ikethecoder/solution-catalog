# Note, make sure rasa-trainer is installed first, as it:
# - Adds the docker volume shared between the two
# - Adds the training data testData.json

mkdir -p /opt/ai

( cd /opt/ai && git clone https://github.com/RasaHQ/rasa_nlu.git )

# Replace the Dockerfile to add additional training libraries
# pip install sklearn-crfsuite==0.3.5 spacy==1.8.2 scikit-learn==0.18.1 scipy==0.19.0
# python -m spacy download en
# pip install git+https://github.com/mit-nlp/MITIE.git#egg=mitie
( cd /opt/ai/rasa_nlu && cp $CATALOG_LOCATION/roles/ai/rasa/config/Dockerfile . )

# Update the config.json
( cd /opt/ai/rasa_nlu && cp config_spacy.json config.json )

( cd /opt/ai/rasa_nlu && docker build -t rasa_nlu . )

( cd /opt/ai/rasa_nlu && docker create -p 5000:5000 --name rasa_nlu -v rasa:/app/models rasa_nlu start )

# curl 'http://localhost:5000/parse?q=hello'


# docker run -p 5000:5000 --name rasa_nlu -v rasa:/app/models rasa_nlu start
# docker run -p 5000:5000 --name rasa_nlu rasa_nlu start

# curl -v -XPOST localhost:5000/train?name=canzea -d @/var/lib/docker/volumes/rasa/_data/testData.json

# Steps:
# - http://192.241.145.221:5001/
# - curl -v -XPOST localhost:5000/train?name=canzea -d @/var/lib/docker/volumes/rasa/_data/testData.json