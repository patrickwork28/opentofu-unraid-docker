locals {
  # Transform shared and XML-specific data into template format
  template_data = {
    container_name = var.shared_container_data.name
    repository     = var.shared_container_data.image
    registry       = try(var.xml_specific_data.registry, "")
    network        = var.shared_container_data.network
    shell          = var.xml_specific_data.shell
    privileged     = var.shared_container_data.privileged ? "true" : "false"
    support        = var.xml_specific_data.support
    project        = var.xml_specific_data.project
    overview       = var.xml_specific_data.overview
    category       = var.xml_specific_data.category
    webui          = var.xml_specific_data.webui
    template_url   = var.xml_specific_data.template_url
    icon           = var.xml_specific_data.icon
    extra_params   = var.xml_specific_data.extra_params
    date_installed = var.xml_specific_data.date_installed
    donate_text    = var.xml_specific_data.donate_text
    donate_link    = var.xml_specific_data.donate_link
    myip           = var.xml_specific_data.myip
    postargs       = var.xml_specific_data.postargs
    cpuset         = var.xml_specific_data.cpuset
    requires       = var.xml_specific_data.requires

    # Generate configs from shared data following Unraid UI order
    configs = concat(
      # Environment variables (Type: Variable)
      [
        for env in try(var.shared_container_data.envs, []) : {
          name        = env.name
          target      = env.name
          default     = ""
          mode        = ""
          description = ""
          type        = "Variable"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = env.value
        }
      ],
      # Port mappings (Type: Port)
      [
        for port in try(var.shared_container_data.ports, []) : {
          name        = "Port ${port.container}"
          target      = "${port.container}"
          default     = "${port.host}"
          mode        = ""
          description = ""
          type        = "Port"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = "${port.host}:${port.container}/${port.protocol}"
        }
      ],
      # Volume mounts (Type: Path)
      [
        for mount in try(var.shared_container_data.mounts, []) : {
          name        = "Path ${mount.container_path}"
          target      = mount.container_path
          default     = mount.host_path
          mode        = mount.mode
          description = ""
          type        = "Path"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = mount.host_path
        }
      ],
      # Device mappings (Type: Device)
      [
        for device in try(var.shared_container_data.devices, []) : {
          name        = "Device ${device.container_path}"
          target      = device.container_path
          default     = device.host_path
          mode        = device.permissions
          description = ""
          type        = "Device"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = device.host_path
        }
      ],
      # Labels (Type: Label)
      [
        for label in try(var.shared_container_data.labels, []) : {
          name        = "Label ${label.name}"
          target      = label.name
          default     = ""
          mode        = ""
          description = ""
          type        = "Label"
          display     = "always"
          required    = "false"
          mask        = "false"
          value       = label.value
        }
      ]
    )
  }
}

resource "local_file" "docker_unraid_xml" {
  content = templatefile("${path.module}/template.xml.tpl", local.template_data)

  filename = "${var.unraid_xml_folderpath}/my-${var.shared_container_data.name}.xml"
}
