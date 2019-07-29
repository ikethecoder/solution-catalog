output "password" {
    value = "${random_string.user_password.result}"
}


output "milestone_user_created" {
    value = "CREATED"
    depends_on = [
        "null_resource.user-exec"
    ]
}

