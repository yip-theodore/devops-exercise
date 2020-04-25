variable "ssh_public_key_path" {
  type        = string
  # default     = "~/.ssh/id_rsa_aws.pub"
  description = "The path to the SSH public key"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of instance to start"
}
