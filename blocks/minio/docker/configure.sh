

docker create --name minio --net=vlan0 -v /var/local/minio/data:/data -e MINIO_ACCESS_KEY=$PROVIDERS_MINIO_LIVE_ACCESS_KEY -e MINIO_SECRET_KEY=$PROVIDERS_MINIO_LIVE_SECRET_KEY minio/minio:RELEASE.2018-09-12T18-49-56Z $PROVIDERS_MINIO_LIVE_MODE $PROVIDERS_MINIO_DATA_PATH $PROVIDERS_MINIO_LIVE_GATEWAY_PROVIDER
