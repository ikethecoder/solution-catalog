
(cd roles/voice/aws-polly && docker build --no-cache --tag local_aws_polly .)

docker rm -f aws-polly

docker create --name aws-polly -p 4022:5050 -v /var/local/aws:/aws -w /aws local_aws_polly

systemctl restart aws-polly
