output "realm" {
    value = "${var.realm}"
}

output "milestone_realm_created" {
    value = "CREATED"
    depends_on = [
        "null_resource.realm-exec"
    ]
}
