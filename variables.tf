variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "mysql_version" {
  description = "Version of MySQL engine for RDS"
  type        = string
  default     = "8.0.23"
}

variable "db_instance_type" {
  description = "Instance type for the RDS database"
  type        = string
  default     = "db.t2.micro"
}

variable "db_storage_size" {
  description = "Allocated storage size for the RDS database (in GB)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "wordpressdb"
}

variable "db_username" {
  description = "Username for accessing the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for accessing the database"
  type        = string
  default     = "password123"
}

variable "multi_az" {
  description = "Enable multi-AZ deployment for RDS"
  type        = bool
  default     = true
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-091da1ddd2d61f0ad"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair for EC2 instances"
  type        = string
  default     = "my-key-pair"
}

variable "user_data" {
  description = "User data for EC2 instances"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_port" {
  description = "Port on which the EC2 instances are listening"
  type        = number
  default     = 80
}

variable "instance_protocol" {
  description = "Protocol for the EC2 instances"
  type        = string
  default     = "HTTP"
}

variable "lb_port" {
  description = "Port on which the load balancer is listening"
  type        = number
  default     = 80
}

variable "lb_protocol" {
  description = "Protocol for the load balancer"
  type        = string
  default     = "HTTP"
}

variable "health_check_target" {
  description = "Target for health checks"
  type        = string
  default     = "HTTP:80/"
}

variable "health_check_interval" {
  description = "Interval for health checks"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health checks"
  type        = number
  default     = 5
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold for health checks"
  type        = number
  default     = 2
}

variable "healthy_threshold" {
  description = "Healthy threshold for health checks"
  type        = number
  default     = 2
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout for connections"
  type        = number
  default     = 60
}

variable "connection_draining" {
  description = "Enable connection draining"
  type        = bool
  default     = true
}

variable "connection_draining_timeout" {
  description = "Connection draining timeout"
  type        = number
  default     = 300
}

variable "min_size" {
  description = "Minimum size for Auto Scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size for Auto Scaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity for Auto Scaling group"
  type        = number
  default     = 1
}

variable "ec2_ingress_port" {
  description = "Ingress port for EC2 security group"
  type        = number
  default     = 80
}

variable "ec2_ingress_cidr" {
  description = "CIDR block for EC2 security group ingress"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds_ingress_port" {
  description = "Ingress port for RDS security group"
  type        = number
  default     = 3306
}

variable "rds_ingress_cidr" {
  description = "CIDR block for RDS security group ingress"
  type        = string
  default     = "0.0.0.0/0"
}

variable "domain_name" {
  description = "Domain name managed by Route 53"
  type        = string
  default     = "example.com"
}
