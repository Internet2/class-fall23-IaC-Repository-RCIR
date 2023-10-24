resource "aws_ebs_volume" "stata_disk" {
  availability_zone = "us-west-2a"
  size              = 500
  tags = {
    Name = "Stata_Disk"
  }
}