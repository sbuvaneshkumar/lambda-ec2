resource "aws_security_group" "bastion-sg" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.lambdatest-vpc.id

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
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
    Name = "lambdatest-bastion-sg"
  }
}

resource "aws_security_group" "priv-sg" {
  name   = "allow-bastion-host"
  vpc_id = aws_vpc.lambdatest-vpc.id

  ingress {
    description     = "Allow SSH access for bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambdatest-allow-bastion-to-priv-sg"
  }
}
