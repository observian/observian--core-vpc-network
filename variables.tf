variable "aws_region" {
  default = "us-east-1"
}

variable "zones" {
  description = "AZ map by region"
  default = {
    us-west-2-alpha   = "us-west-2a"
    us-west-2-bravo   = "us-west-2b"
    us-west-2-charlie = "us-west-2c"
    us-east-1-alpha   = "us-east-1a"
    us-east-1-bravo   = "us-east-1b"
    us-east-1-charlie = "us-east-1c"
  }
}

variable "application" {
  default = "base-app"
}
variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for base-app vpc"
}

variable "public_alpha_cidr" {
  description = "CIDR block for public subnet alpha"
}

variable "private_alpha_cidr" {
  description = "CIDR block for private subnet alpha"
}

variable "public_bravo_cidr" {
  description = "CIDR block for public subnet bravo"
}

variable "private_bravo_cidr" {
  description = "CIDR block for private subnet bravo"
}

variable "eks_cluster_name" {
  description = "the name of the eks cluster"
}

variable "namespace" {
  description = "default namespace that isn't the default namespace.  Defaults to \"development\""
  default     = "development"
}

variable "k8s-user-names" {
  description = "users who should have read-access to the cluster"
  default = [
    "user1",
    "user2",
    "user3"
  ]
}

variable "allowed_account_ids" {
}
