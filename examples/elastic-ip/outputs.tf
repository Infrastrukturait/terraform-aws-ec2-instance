output "id" {
  value       = module.ec2_instance_with_eip.id
  description = "The ID of the instance."
}

output "arn" {
  value       = module.ec2_instance_with_eip.arn
  description = "The ARN of the instance."
}

output "ami" {
  value       = module.ec2_instance_with_eip.ami
  description = "AMI ID that was used to create the instance."
}

output "availability_zone" {
  value       = module.ec2_instance_with_eip.availability_zone
  description = "The availability zone of the created instance."
}

output "root_block_device" {
  value       = module.ec2_instance_with_eip.root_block_device
  description = "Root block device information."
}

output "primary_network_interface_id" {
  value       = module.ec2_instance_with_eip.primary_network_interface_id
  description = "The ID of the instance's primary network interface."
}

output "private_dns" {
  value       = module.ec2_instance_with_eip.private_dns
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
}

output "public_dns" {
  value       = module.ec2_instance_with_eip.public_dns
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
}

output "public_ip" {
  value       = module.ec2_instance_with_eip.public_ip
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached."
}

output "private_ip" {
  value       = module.ec2_instance_with_eip.private_ip
  description = "The private IP address assigned to the instance."
}

output "ipv6_addresses" {
  value       = module.ec2_instance_with_eip.ipv6_addresses
  description = "The IPv6 address assigned to the instance, if applicable."
}
