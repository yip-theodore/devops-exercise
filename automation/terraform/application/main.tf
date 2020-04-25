resource "aws_instance" "application" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instance_count

  key_name = var.key_name

  security_groups = [aws_security_group.application.name]
  availability_zone = "eu-west-2a"

  tags = {
    Name      = "${var.stage}_application"
    component = "application"
    stage     = var.stage
  }
}

resource "aws_security_group" "application" {
  name = "${var.stage}_application"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32", "0.0.0.0/0"]
  }

  ingress {
    description = "HTTP web app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_elb" "elb" {
  name               = "${var.stage}-elb"
  availability_zones = ["eu-west-2a"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/api/healthcheck"
    interval            = 30
  }

  instances                   = aws_instance.application.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}


resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.stage}-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis.id]
}

resource "aws_security_group" "redis" {
  name = "${var.stage}_redis"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.application.id]
  }
}
