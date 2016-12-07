resource "aws_security_group" "web-server" {
    name = "vpc_web"
    description = "Allow incoming ssh connections fromm all but only http connectins only from VPC."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.elb.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}", "${var.private_subnet_cidr_1}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "WebServerSG"
    }
}

resource "aws_security_group" "elb" {
    name = "vpc_elb"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }



    egress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}", "${var.private_subnet_cidr_1}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "elbSG"
    }
}

resource "aws_instance" "web" {
    ami = "${lookup(var.amis, var.region)}"
    count = "${var.count}"
    availability_zone = "us-east-1a"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_pair_name}"
    vpc_security_group_ids = ["${aws_security_group.web-server.id}"]
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "${var.user}-${var.app_name}-${var.environment} Web Server ${count.index}"
    }
}

resource "aws_eip" "web" {
    count = "${var.count}"
    instance = "${element(aws_instance.web.*.id, count.index)}"
    vpc = true
}

resource "aws_elb" "app" {
  name = "${var.user}-${var.app_name}-${var.environment}"
  subnets = ["${aws_subnet.us-east-1a-public.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:80"
    interval = 5
  }
  instances = ["${aws_instance.web.*.id}"]
}