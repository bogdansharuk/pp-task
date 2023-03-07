data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project_name}-ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "instance_1" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = var.ec2_instance_type
  key_name               = "${var.project_name}-ssh-key"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.subnet_public_1.id
  user_data              = file("user_data.sh")
  tags = {
    Name = "${var.project_name}-1"
  }
}

resource "aws_instance" "instance_2" {
  ami                    = "ami-06b4d9ba1f23a8da4"
  instance_type          = var.ec2_instance_type
  key_name               = "${var.project_name}-ssh-key"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.subnet_public_2.id
  user_data              = file("user_data.sh")
  tags = {
    Name = "${var.project_name}-2"
  }
}