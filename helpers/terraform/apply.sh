terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=./id_rsa.pub" \
  -var "pvt_key=./id_rsa" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT"
