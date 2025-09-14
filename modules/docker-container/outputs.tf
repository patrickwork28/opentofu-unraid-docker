output "container_id" {
  description = "The ID of the created Docker container"
  value       = docker_container.this.id
}

output "container_name" {
  description = "The name of the created Docker container"
  value       = docker_container.this.name
}

output "image_name" {
  description = "The name of the Docker image used"
  value       = docker_image.this.name
}

output "container_ip" {
  description = "The IP address of the Docker container"
  value       = docker_container.this.ip_address
}

output "container_network_mode" {
  description = "The network mode of the Docker container"
  value       = docker_container.this.network_mode
}