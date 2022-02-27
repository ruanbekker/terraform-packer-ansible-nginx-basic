locals {
    default_tags = {
        "Owner"       = "devops"
        "ManagedBy"   = "terraform"
        "Environment" = var.environment_name
        "Backup"      = "false"
        "Status"      = "active"
    }
}
