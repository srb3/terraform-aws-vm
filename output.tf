output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = flatten(module.ec2_instance.*.public_dns)
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = flatten(module.ec2_instance.*.public_ip)
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = flatten(module.ec2_instance.*.private_dns)
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = flatten(module.ec2_instance.*.private_ip)
}
