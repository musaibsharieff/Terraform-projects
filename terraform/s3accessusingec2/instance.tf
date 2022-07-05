resource "aws_instance" "web" {

  ami                    = "ami-0cff7528ff583bf9a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.SSMRoleForEC2.name
  user_data              = <<EOF

      #!/bin/bash
      sudo su
      yum update -y
      yum install httpd -y
      aws s3 cp s3://${aws_s3_bucket.blog.id}/index.html /var/www/html/index.html
      systemctl start httpd
      systemctl enable httpd
      EOF

  tags = {
    Name = "terraform-testing-musaib"
  }
}
