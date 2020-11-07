output "linux_private_ip" {
  value = module.instance["linux"].private_ip[0]
}

output "linux_public_ip" {
  value = module.instance["linux"].public_ip[0]
}

output "windows_private_ip" {
  value = module.instance["windows"].private_ip[0]
}

output "windows_public_ip" {
  value = module.instance["windows"].public_ip[0]
}

output "password_data" {
  value = module.instance["windows"].password_data[0]
}

output "password" {
  value = rsadecrypt(module.instance["windows"].password_data[0], file(var.private_key))
}
