#Module VPC (Public and Private subnets)
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = var.vpc_name
    cidr = var.cidr

    azs             = var.azs
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    enable_vpn_gateway = true

    tags = {
        Terraform = "true"
        Environment = "dev"
        OWNER = "ale_david_1996@outlook.com"
    }
}

resource "aws_eip" "project6" {
    tags = {
        Name="Project6"
        OWNER="ale_david_1996@outlook.com"
    }
}
resource "aws_eip_association" "project6-eip" {
    instance_id = aws_instance.instance_1.id
    allocation_id = aws_eip.project6.id
}

resource "aws_eip_association" "project6" {
    instance_id = aws_instance.instance_2.id
    allocation_id = aws_eip.project6.id
}

#Security Group for Project
resource "aws_security_group" "project-sg" {
    name = "projectsg"
    description = "Security Group of Projects DevOps"
    vpc_id = module.vpc.vpc_id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
    
    tags = {
      Terraform = "true"
      Environment = "dev"
      OWNER = "ale_david_1996@outlook.com"
      }
}

#Security Group for Load Balancer
resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Security Group for Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.project-sg.id]
  }

  tags = {
      Terraform = "true"
      Environment = "dev"
      OWNER = "ale_david_1996@outlook.com"
      }
}

#Instancia number one
resource "aws_instance" "instance_1" {
  ami           = "ami-0f409bae3775dc8e5"  
  instance_type = var.type_instance
  subnet_id     = "subnet-096e83d254890ab8a" 
  security_groups = [aws_security_group.project-sg.id]

   user_data = <<-EOT
              #!/bin/bash
              echo "Instance Name: instance-${var.instance_name1}" > /var/www/html/index.html
              echo "Region: ${var.name_region}" >> /var/www/html/index.html
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOT
}

#Instancia number two
resource "aws_instance" "instance_2" {
  ami           = "ami-051f7e7f6c2f40dc1" 
  instance_type = var.type_instance
  subnet_id     = "subnet-0aeac60b20a308628"
  security_groups = [aws_security_group.project-sg.id]

   user_data = <<-EOT
              #!/bin/bash
              echo "Instance Name: instance-${var.instance_name2}" > /var/www/html/index.html
              echo "Region: ${var.name_region}" >> /var/www/html/index.html
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOT
}

#Load Balancer
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.lb-sg.id]
  subnets            = module.vpc.public_subnets 
  
  enable_deletion_protection = false  
}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, this is the default response."
      status_code = "200"
    }
  }
}

#Target Group Attachment of the first instance
resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance_1.id
  port             = 80
}

#Target Group Attachment of the second instance
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance_2.id
  port             = 80
}

#Target Group
resource "aws_lb_target_group" "tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  #Health check
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = "traffic-port"
  }
}