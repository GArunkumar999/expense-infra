resource "aws_instance" "bastion" {
  ami                    = "ami-09c813fb71547fc4f" # This is our devops-practice AMI ID
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  instance_type          = "t2.large"
  subnet_id   = local.public_subnet_id
  associate_public_ip_address = true

  # 20GB is not enough
  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  user_data = file("bastion.sh")
  tags = {
    Name = "${var.project}-${var.environment}-bastion"
  }
}

