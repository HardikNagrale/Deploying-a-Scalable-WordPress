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
