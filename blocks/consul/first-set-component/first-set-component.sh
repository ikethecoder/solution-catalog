#!/bin/bash

set -e

docker exec consul consul kv put components/
