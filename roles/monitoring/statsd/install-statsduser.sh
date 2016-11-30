
adduser -m statsduser

export TMP_PASSWORD=statsduser1; expect roles/application/user/set-password.expect statsduser

sudo -E -u statsduser expect roles/application/user/key-gen.expect

