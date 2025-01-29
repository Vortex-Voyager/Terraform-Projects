output "alb-dns-name" {
  value = aws_lb.alb.dns_name

}

output "rds-endpoint" {
  value = aws_db_instance.Database.endpoint

}