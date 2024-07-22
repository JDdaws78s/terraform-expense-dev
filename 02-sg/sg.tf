module "db" {
    source = "git::https://github.com/JDdaws78s/terraform-aws-sg-module.git"
    project_name = var.project_name
    environment = var.environment
    sg_name = "db"
    sg_description = "SG for DB mysql instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.db_sg_tags
}

module "backend" {
    source = "git::https://github.com/JDdaws78s/terraform-aws-sg-module.git"
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    sg_description = "SG for backend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "frontend" {
    source = "git::https://github.com/JDdaws78s/terraform-aws-sg-module.git"
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"
    sg_description = "SG for frontend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
} 

#db is accepting traffic from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id   # where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}