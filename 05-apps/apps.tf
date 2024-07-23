module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-backend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.private_sg_id.value]
  subnet_id              = local.private_subnet_id
  ami                    = data.aws_ami.ami

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.public_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami                    = data.aws_ami.ami

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}