output "linux_private_ip" {
  value = module.instances.linux_private_ip
}

output "linux_public_ip" {
  value = module.instances.linux_public_ip
}

output "windows_private_ip" {
  value = module.instances.windows_private_ip
}

output "windows_public_ip" {
  value = module.instances.windows_public_ip
}

output "password_data" {
  value = module.instances.password_data
}

output "password" {
  value = module.instances.password
}
