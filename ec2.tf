#create ec2 instance for Lamp stack

resource "aws_instance" "lamp_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.lamp-subnet.id
  vpc_security_group_ids = [aws_security_group.lamp-sg.id]
  key_name               = aws_key_pair.lamp_key.key_name
  user_data              = file("install_lamp.sh")
   
  tags = {
    Name = "Lamp stack"
    Environment = "dev"
  }
}
# an empty resource block
resource "null_resource" "name" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(local_file.ssh_key.filename)
    host        = aws_instance.lamp_server.public_ip
  }
  # wait for ec2 to be created
  depends_on = [aws_instance.lamp_server]
}