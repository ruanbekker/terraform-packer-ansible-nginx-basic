output "instance_id" {
  value = aws_instance.packer_node_instance.id
}

output "public_ip" {
  value = aws_instance.packer_node_instance.public_ip
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "vpc_cidr_block" {
  value = data.aws_vpc.default.cidr_block
}

output "ami_id" {
  value = data.aws_ami.packer_node_ami.id
}

output "subnet_id" {
  value = random_shuffle.subnet_id.result[0]
}