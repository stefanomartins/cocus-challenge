output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}

output "webserver_private_ip" {
  value = aws_instance.webserver.private_ip
}

output "dbserver_private_ip" {
  value = aws_instance.dbserver.private_ip
}
