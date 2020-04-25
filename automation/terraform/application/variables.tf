variable "ami" {
  type        = string
  description = "The AMI to use for the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to start"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "The number of instances to deploy"
}

variable "key_name" {
  type        = string
  description = "The key name of the Key Pair to use for the instance"
}

variable "stage" {
  type    = string
  default = "staging"
}
