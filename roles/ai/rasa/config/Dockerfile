FROM python:2.7-slim

ENV RASA_NLU_DOCKER="YES" \
    RASA_NLU_HOME=/app \
    RASA_NLU_PYTHON_PACKAGES=/usr/local/lib/python2.7/dist-packages

VOLUME ["${RASA_NLU_HOME}", "${RASA_NLU_PYTHON_PACKAGES}"]

# Run updates, install basics and cleanup
# - build-essential: Compile specific dependencies
# - git-core: Checkout git repos
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git-core && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR ${RASA_NLU_HOME}

COPY ./requirements.txt requirements.txt

# Split into pre-requirements, so as to allow for Docker build caching
RUN pip install $(tail -n +2 requirements.txt)

RUN pip install sklearn-crfsuite==0.3.5 spacy==1.8.2 scikit-learn==0.18.1 scipy==0.19.0

RUN python -m spacy download en

RUN pip install git+https://github.com/mit-nlp/MITIE.git#egg=mitie

COPY . ${RASA_NLU_HOME}

RUN python setup.py install

RUN ls /app

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["help"]
