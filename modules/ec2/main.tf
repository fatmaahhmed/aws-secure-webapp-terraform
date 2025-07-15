resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids

  key_name      = var.key_name

  user_data     = var.user_data

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  count              = var.attach_to_alb ? var.instance_count : 0
  target_group_arn   = var.target_group_arn
  target_id          = aws_instance.this[count.index].id
  port               = var.app_port
}
