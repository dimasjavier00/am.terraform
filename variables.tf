variable "project" {
    description = "the name of project"
    default = "am"
}
variable "environment" {
    description = "the enviroment to release"
    default = "dev"
}
variable "location" {
    description = "Azure region"
    default = "East Us 2"
}

variable "tags"{
    description = "all tags used"
    default = {
        environment = "dev"
        project = "am"
        created_by = "terraform"
    }
}

variable "password"{
    description = "sqlserver password"
    type = string
    sensitive = true
}