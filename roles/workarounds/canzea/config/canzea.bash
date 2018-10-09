#!/bin/bash

docker run -ti --rm -v /var/local:/var/local -v /root:/root canzea canzea "$@"