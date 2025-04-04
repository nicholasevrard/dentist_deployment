# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("${path.module}/my-key.pub")
}

# Creating a security group to restrict/allow inbound connectivity
resource "aws_security_group" "network-security-group" {
  name        = "my-security-group"
  description = "Allow TLS inbound & outbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Not recommended to add "0.0.0.0/0" instead we need to be more specific with the IP ranges to allow connectivity from.
  tags = {
    Name = "my-security-group"
  }
}

# Creating Ubuntu EC2 instance for CICD/CD
resource "aws_instance" "VMcicdcd" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "VMcicdcd"
  }
}

# Creating Ubuntu EC2 instance for test
resource "aws_instance" "VMtest" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "VMtest"
  }
}

# Creating Ubuntu EC2 instance for production
resource "aws_instance" "VMprod" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "VMprod"
  }
}

# Creating Ubuntu EC2 instance for monitoring
resource "aws_instance" "VMmonitoring" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "VMmonitoring"
  }
}

# Output all values
output "all_public_dns" {
  value = {
    cicdcd_public_dns    = aws_instance.VMcicdcd.public_dns
    test_public_dns      = aws_instance.VMtest.public_dns
    production_public_dns = aws_instance.VMprod.public_dns
    monitoring_public_dns = aws_instance.VMmonitoring.public_dns
  }
}

# Store all content in a single file
resource "local_file" "all_public_dns" {
  content = <<-EOF
    cicdcd_public_dns = "${aws_instance.VMcicdcd.public_dns}"
    test_public_dns = "${aws_instance.VMtest.public_dns}"
    production_public_dns = "${aws_instance.VMprod.public_dns}"
    monitoring_public_dns = "${aws_instance.VMmonitoring.public_dns}"
  EOF
  filename = "all_public_dns.txt"
}
