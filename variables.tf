# Network variables
variable "region" {}
variable "main_vpc_cidr" {}
variable "public_subnets" {}
variable "public_subnets2" {}
variable "private_subnets" {}
variable "private_subnets2" {}

# Launch Configuration variable
variable "ami_ubuntu" {}

# Database variables
#variable "database_name" {}       
variable "database_user" {}  
variable "database_password" {} 

