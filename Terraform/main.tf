# Création d'une paire de clés pour SSH
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("C:/Users/g2r/Desktop/dentist_deployment/my-key.pub")
}

# Création du VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

# Création d'un sous-réseau dans le VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
  }
}

# Création d'une passerelle Internet pour donner un accès à Internet
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Association du sous-réseau à la table de routage
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "my_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Création d'un groupe de sécurité
resource "aws_security_group" "network-security-group" {
  name        = "my-security-group"
  description = "Allow inbound & outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id # Correction ici

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

  tags = {
    Name = "my-security-group"
  }
}

# Fonction pour créer une instance EC2 pour CICD
resource "aws_instance" "VMcicdcd" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  subnet_id              = aws_subnet.my_subnet.id # Correction ici

  tags = {
    Name = "VMcicdcd"
  }
}

# Fonction pour créer une instance EC2 pour Test
resource "aws_instance" "VMtest" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  subnet_id              = aws_subnet.my_subnet.id # Correction ici

  tags = {
    Name = "VMtest"
  }
}

# Fonction pour créer une instance EC2 pour Production
resource "aws_instance" "VMprod" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  subnet_id              = aws_subnet.my_subnet.id # Correction ici

  tags = {
    Name = "VMprod"
  }
}

# Fonction pour créer une instance EC2 pour Monitoring
resource "aws_instance" "VMmonitoring" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  subnet_id              = aws_subnet.my_subnet.id # Correction ici

  tags = {
    Name = "VMmonitoring"
  }
}

# Outputs des valeurs importantes
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.my_subnet.id
}

output "all_public_dns" {
  value = {
    cicdcd_public_dns     = aws_instance.VMcicdcd.public_dns
    test_public_dns       = aws_instance.VMtest.public_dns
    production_public_dns = aws_instance.VMprod.public_dns
    monitoring_public_dns = aws_instance.VMmonitoring.public_dns
  }
}

# Enregistrement des adresses dans un fichier local
resource "local_file" "all_public_dns" {
  content  = <<-EOF
    cicdcd_public_dns = "${aws_instance.VMcicdcd.public_dns}"
    test_public_dns = "${aws_instance.VMtest.public_dns}"
    production_public_dns = "${aws_instance.VMprod.public_dns}"
    monitoring_public_dns = "${aws_instance.VMmonitoring.public_dns}"
  EOF
  filename = "all_public_dns.txt"
}
