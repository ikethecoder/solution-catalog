#!/bin/bash

CMD="docker run --rm --user go -v $PWD:/working -w /working $@"

$CMD
