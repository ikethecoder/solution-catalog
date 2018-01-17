FROM gradle:4.4.1-jdk

WORKDIR /tmp

RUN git clone https://github.com/ikethecoder/aws-polly-example.git && \
    cd aws-polly-example && \
    ./gradlew build

RUN ls aws-polly-example/build/distributions


FROM openjdk:8u151-jdk-alpine

RUN adduser -h /aws -D polly

WORKDIR /tmp

COPY --from=0 /tmp/aws-polly-example/build/distributions/aws-polly-example.zip dist.zip

RUN unzip dist.zip && \
    rm -f dist.zip

EXPOSE 5050

USER polly

CMD ["/tmp/aws-polly-example/bin/aws-polly-example"]

