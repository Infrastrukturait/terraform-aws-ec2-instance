output "id" {
  value       = aws_instance.this.id
  description = "The ID of the instance."
}

output "arn" {
  value       = aws_instance.this.arn
  description = "The ARN of the instance."
}

output "ami" {
  value       = aws_instance.this.ami
  description = "AMI ID that was used to create the instance."
}

output "availability_zone" {
  value       = aws_instance.this.availability_zone
  description = "The availability zone of the created instance."
}

output "root_block_device" {
  value       = aws_instance.this.root_block_device
  description = "Root block device information."
}

output "primary_network_interface_id" {
  value       = try(aws_instance.this.primary_network_interface_id, null)
  description = "The ID of the instance's primary network interface."
}

output "private_dns" {
  value       = try(aws_instance.this.private_dns, null)
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
}

output "public_dns" {
  value       = try(aws_instance.this.public_dns, null)
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
}

output "public_ip" {
  value       = try(aws_eip_association.this[0].public_ip, aws_instance.this.public_ip, null)
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached."
}

output "private_ip" {
  value       = try(aws_instance.this.private_ip, null)
  description = "The private IP address assigned to the instance."
}

output "ipv6_addresses" {
  value       = try(aws_instance.this.ipv6_addresses, [])
  description = "The IPv6 address assigned to the instance, if applicable."
}
