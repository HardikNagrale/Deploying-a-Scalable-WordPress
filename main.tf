provider "aws" {
  region = var.region
}

# Step 1: VPC Setup
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "PrivateSubnet2"
  }
}

# Step 2: Database Setup
resource "aws_db_instance" "wordpress_db" {
  engine               = "mysql"
  engine_version       = var.mysql_version
  instance_class       = var.db_instance_type
  allocated_storage    = var.db_storage_size
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  multi_az             = var.multi_az
  db_subnet_group_name = aws_db_subnet_group.main.name
  publicly_accessible = false

  tags = {
    Name = "WordPressDB"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "MainDBSubnetGroup"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# Step 3: EC2 Instance Setup
resource "aws_instance" "wordpress_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "WordPressInstance"
  }
}

# Step 4: Elastic Load Balancer (ELB) Setup
resource "aws_elb" "wordpress_elb" {
  name               = "WordPressELB"
  availability_zones = var.availability_zones
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  listener {
    instance_port     = var.instance_port
    instance_protocol = var.instance_protocol
    lb_port           = var.lb_port
    lb_protocol       = var.lb_protocol
  }

  health_check {
    target              = var.health_check_target
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold
    healthy_threshold   = var.healthy_threshold
  }

  cross_zone_load_balancing  = var.cross_zone_load_balancing
  idle_timeout               = var.idle_timeout
  connection_draining        = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout

  tags = {
    Name = "WordPressELB"
  }
}

# Step 5: Auto Scaling Setup
resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "WordPressASG"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  launch_configuration = aws_launch_configuration.wordpress_lc.name
}

resource "aws_launch_configuration" "wordpress_lc" {
  name                 = "WordPressLC"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [aws_security_group.ec2.id]
  user_data            = var.user_data
}

# Step 6: Security Group Configuration
resource "aws_security_group" "ec2" {
  name        = "EC2SecurityGroup"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.ec2_ingress_port
    to_port     = var.ec2_ingress_port
    protocol    = "tcp"
    cidr_blocks = [var.ec2_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name        = "RDSSecurityGroup"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.rds_ingress_port
    to_port     = var.rds_ingress_port
    protocol    = "tcp"
    cidr_blocks = [var.rds_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Step 7: DNS Configuration
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "elb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_elb.wordpress_elb.dns_name]
}

# Step 8: SSL/TLS Setup
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
}

resource "aws_lb_listener_certificate" "ssl_listener_certificate" {
  listener_arn    = aws_elb.wordpress_elb.arn
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "ec2_instance_ips" {
  description = "IP addresses of the EC2 instances"
  value       = aws_instance.wordpress_instance.*.public_ip
}

output "elb_dns_name" {
  description = "DNS name of the Elastic Load Balancer"
  value       = aws_elb.wordpress_elb.dns_name
}

output "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "ssl_certificate_arn" {
  description = "ARN of the SSL/TLS certificate"
  value       = aws_acm_certificate.ssl_certificate.arn
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  value       = aws_autoscaling_group.wordpress_asg.name
}

output "rds_security_group_id" {
  description = "ID of the security group for RDS instance"
  value       = aws_security_group.rds.id
}

output "ec2_security_group_id" {
  description = "ID of the security group for EC2 instances"
  value       = aws_security_group.ec2.id
}
