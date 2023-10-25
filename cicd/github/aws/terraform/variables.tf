variable "account_id" {
  description = "The account id of the aws account (ex: 123456789012)"
  type        = string
}

variable "role_name" {
  description = "The role name used to access the account"
  type        = string
}

variable "region" {
  description = "The region the requisite resources will be deployed in"
  type        = string
}