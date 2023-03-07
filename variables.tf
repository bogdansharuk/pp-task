
### Provider

variable  "aws_access_key" {
  type        = string
  description = "Add AWS access key for terraform"
  default     = "XXXXXXXXXXXXXXXXXXXX"
}

variable  "aws_secret_key" {
  type        = string
  description = "Add AWS secret key for terraform"
  default     = "XXXXXXXXXXXXXXXXXXXX"
}

variable  "aws_region" {
  type        = string
  description = "Set AWS region for deployment"
  default     = "eu-central-1"
}

### Project

variable  "project_name" {
  type        = string
  description = "Set project name"
  default     = "web"
}

### VPC

variable  "vpc_cidr_block" {
  type        = string
  description = "Set CIDR block for VPC "
  default     = "10.10.0.0/16"
}

variable  "subnet_1_cidr_block" {
  type        = string
  description = "Set CIDR block for public subnet 1"
  default     = "10.10.1.0/24"
}

variable  "subnet_2_cidr_block" {
  type        = string
  description = "Set CIDR block for public subnet 2"
  default     = "10.10.2.0/24"
}

### Security groups

variable "admin_ips" {
  type        = list
  description = "Add admin IPs for icmp/ssh ingress rules.\nExapmle:\n[\"x.x.x.x/32\",\"y.y.y.y/24\",\"0.0.0.0/0\"]"
  default     = []
}

variable "allow_ports" {
  type        = list
  description = "Add all allowed ports for dynamic ingress rules.\nExapmle:\n[\"22\",\"80\",\"443\"]"
  default     = ["80","443"]
}

variable "allow_ips" {
  type        = list
  description = "Add all allowed IPs for dynamic ingress rules.\nExapmle:\n[\"x.x.x.x/32\",\"y.y.y.y/24\",\"0.0.0.0/0\"]"
  default     = ["0.0.0.0/0"]
}

### EC2

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key"
  default     = "XXXXXXXXXXXXXXXXXXXX"
}