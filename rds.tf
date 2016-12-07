resource "aws_db_instance" "default" {
  identifier = "${var.user}-wordpress-db"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6.27"
  instance_class       = "db.t1.micro"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${aws_db_subnet_group.main_db_subnet_group.name}"
  parameter_group_name = "default.mysql5.6"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
}

resource "aws_db_subnet_group" "main_db_subnet_group" {
    name = "${var.user}-wordpress-db-subnetgroup"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.us-east-1a-private.id}", "${aws_subnet.us-east-1a-private_1.id}"]
}
