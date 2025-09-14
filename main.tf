module "containers" {
  source = "./modules/docker-container"
  for_each = var.containers

  container_data = {
    name       = each.value.name
    hostname   = each.value.hostname
    image      = each.value.image
    network    = each.value.network
    restart    = each.value.restart
    pids_limit = each.value.pids_limit

    user       = try(each.value.user, null)
    privileged = each.value.privileged
    command    = try(each.value.command, [])
    entrypoint = try(each.value.entrypoint, [])
    envs       = try(each.value.envs, [])
    ports      = try(each.value.ports, [])
    mounts     = try(each.value.mounts, [])
    labels     = try(each.value.labels, [])
    devices    = try(each.value.devices, [])
  }
}

module "containers_xml" {
  source = "./modules/docker-unraid-xml"
  for_each = var.containers

  template_data = {
    container_name = each.value.name
    repository     = each.value.template_data.repository
    registry       = each.value.image
    network        = each.value.network
    shell          = try(each.value.template_data.shell, "false")
    privileged     = tostring(each.value.privileged)
    support        = each.value.template_data.support
    project        = each.value.template_data.project
    overview       = each.value.template_data.overview
    category       = each.value.template_data.category
    webui          = each.value.template_data.webui
    template_url   = each.value.template_data.template_url
    icon           = each.value.template_data.icon
    extra_params   = each.value.template_data.extra_params
    date_installed = each.value.template_data.date_installed
    donate_text    = each.value.template_data.donate_text
    donate_link    = each.value.template_data.donate_link
    myip       = try(each.value.myip, "")
    postargs   = try(each.value.postargs, "")
    cpuset     = try(each.value.cpuset, "")
    requires   = try(each.value.requires, "")
    configs = concat(
      [
        for env in try(each.value.envs, []) : {
          name        = "env:${env.name}"
          target      = env.name
          default     = ""
          mode        = "rw"
          description = "Environment variable"
          type        = "Variable"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = env.value
        }
      ],
      [
        for port in try(each.value.ports, []) : {
          name        = "port:${port.host}"
          target      = tostring(port.container)
          default     = ""
          mode        = "rw"
          description = "Port mapping"
          type        = "Port"
          display     = "advanced"
          required    = "false"
          mask        = "false"
          value       = "${port.host}:${port.container}/${port.protocol}"
        }
      ],
      [
        for mount in try(each.value.mounts, []) : {
          name        = "mount:${mount.host_path}"
          target      = mount.container_path
          default     = ""
          mode        = mount.mode
          description = "Bind mount"
          type        = "Path"
          display     = "advanced"
          required    = "false"
          mask        = "false"
          value       = mount.host_path
        }
      ],
      [
        for label in try(each.value.labels, []) : {
          name        = "label:${label.name}"
          target      = label.name
          default     = ""
          mode        = "rw"
          description = "Container label"
          type        = "Label"
          display     = "advanced"
          required    = "false"
          mask        = "false"
          value       = label.value
        }
      ],
      [
        for device in try(each.value.devices, []) : {
          name        = "device:${device.host_path}"
          target      = device.container_path
          default     = ""
          mode        = device.permissions
          description = "Device mapping"
          type        = "Device"
          display     = "advanced"
          required    = "false"
          mask        = "false"
          value       = device.host_path
        }
      ]
    )
  }
}
