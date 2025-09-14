data "docker_registry_image" "this" {
  name = var.container_data.image
}

resource "docker_image" "this" {
  name          = data.docker_registry_image.this.name
  pull_triggers = [data.docker_registry_image.this.sha256_digest]
}

resource "docker_container" "this" {
  name         = var.container_data.name
  hostname     = var.container_data.hostname
  image        = docker_image.this.name
  restart      = var.container_data.restart
  network_mode = var.container_data.network
  pid_mode     = "host"
  user         = try(var.container_data.user, null)
  privileged   = try(var.container_data.privileged, false)
  command      = try(var.container_data.command, [])
  entrypoint   = try(var.container_data.entrypoint, [])

  env = [
    for env in try(var.container_data.envs, []) : "${env.name}=${env.value}"
  ]

  dynamic "ports" {
    for_each = try(var.container_data.ports, [])
    content {
      internal = ports.value.container
      external = ports.value.host
      protocol = ports.value.protocol
    }
  }

  dynamic "mounts" {
    for_each = try(var.container_data.mounts, [])
    content {
      target    = mounts.value.container_path
      source    = mounts.value.host_path
      type      = "bind"
      read_only = mounts.value.mode == "ro"
    }
  }

  dynamic "labels" {
    for_each = try(var.container_data.labels, [])
    content {
      label = labels.value.name
      value = labels.value.value
    }
  }

  dynamic "devices" {
    for_each = try(var.container_data.devices, [])
    content {
      host_path          = devices.value.host_path
      container_path     = devices.value.container_path
      permissions        = devices.value.permissions
    }
  }
}
