
mkdir -p /var/local/aws

(cd roles/voice/aws-polly && docker build --tag local_aws_polly .)

docker create --name aws-polly -p 4022:5050 -v /var/local/aws:/aws -w /aws local_aws_polly

