output "app_entrypoint_address" {
  value = "${aws_elb.app.dns_name}"
}
output "web_instance_public_address" {
    value = "${join(",", aws_instance.web.*.public_ip)}"
}
output "web_instance_private_ip" {
    value = "${join(",", aws_instance.web.*.ip)}"
}
output "db_instance_address" {
  value = "${aws_db_instance.default.address}"
}