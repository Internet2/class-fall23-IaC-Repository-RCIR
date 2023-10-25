variable "location" {
	type	= string
	default	= "eastus"
}

variable "prefix" {
	type	= string
	default	= "i2c23proj"
}

# Time (in days) for transitions in storage lifecycle.
#  time_to_cool: time since last modification to move from hot to cool storage
#  time_to_archive: time since last modification to move from cool to archive storage
#  time_to_delete: time since last modification to delete 
#  snapshot_retention: days to retain snapshot
#
variable "time_to_cool" {
  type = number
  default = 42
}
variable "time_to_archive" {
  type = number
  default = 86
}
variable "time_to_delete" {
  type = number
  default = 365
}
variable "snapshot_retention" {
  type = number
  default = 30
}
