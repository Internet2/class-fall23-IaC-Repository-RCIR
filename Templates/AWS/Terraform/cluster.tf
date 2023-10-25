resource "aws_instance" "matlab_vm" {
  count         = 3
  ami           = "ami-0123456789abcdef0"
  instance_type = "m5.large"
  tags = {
    Name = "MATLAB_VM-${count.index}"
  }
}