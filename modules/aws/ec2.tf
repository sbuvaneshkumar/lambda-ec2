data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./key.pem && chmod 400 ./key.pem"
  }
}

resource "aws_iam_instance_profile" "ssm-iam-profile" {
  name = "ssm-iam-profile"
  role = aws_iam_role.ssm-iam-role.name
}

resource "aws_iam_role" "ssm-iam-role" {
  name               = "ssm-iam-role"
  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": {
           "Effect": "Allow",
        "Principal": {
           "Service": "ec2.amazonaws.com"
           },
        "Action": "sts:AssumeRole"
        }
}
EOF

  tags = {
    stack = "lambda-test-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.ssm-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "bastion-lambdatest-ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.micro"
  iam_instance_profile   = aws_iam_instance_profile.ssm-iam-profile.name
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = aws_subnet.lambdatest-pub-subnet.id

  tags = {
    Name = "bastion-lambdatest-ec2"
  }
}

resource "aws_instance" "lambdatest-ec2" {
  count                  = var.number_of_instances
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ssm-iam-profile.name
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.priv-sg.id]
  subnet_id              = aws_subnet.lambdatest-priv-subnet.id

  tags = {
    Name = "lambdatest ec2 ${count.index}"
  }
}
