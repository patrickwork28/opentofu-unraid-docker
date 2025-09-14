variable "template_data" {
  description = "Complete template data object for generating Unraid DockerMan XML configuration files following Unraid UI input order"
  type = object({
    container_name = string
    repository     = string
    registry       = string
    network        = string
    shell          = string
    privileged     = string
    support        = string
    project        = string
    overview       = string
    category       = string
    webui          = string
    template_url   = string
    icon           = string
    extra_params   = string
    date_installed = string
    donate_text    = string
    donate_link    = string
    myip           = string
    postargs       = string
    cpuset         = string
    requires       = string

    configs = list(object({
      name        = string
      target      = string
      default     = string
      mode        = string
      description = string
      type        = string
      display     = string
      required    = string
      mask        = string
      value       = string
    }))
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.template_data.container_name))
    error_message = "Container name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["bridge", "host", "none"], var.template_data.network)
    error_message = "Network must be one of: bridge, host, none."
  }

  validation {
    condition     = contains(["true", "false"], var.template_data.privileged)
    error_message = "Privileged must be either 'true' or 'false'."
  }

  validation {
    condition     = contains(["sh", "bash"], var.template_data.shell)
    error_message = "Shell must be either 'sh' or 'bash'."
  }

  validation {
    condition     = alltrue([
      for config in var.template_data.configs :
      contains(["Variable", "Port", "Path", "Device", "Label"], config.type)
    ])
    error_message = "Config types must be one of: Variable, Port, Path, Device, Label."
  }

  validation {
    condition     = alltrue([
      for config in var.template_data.configs :
      contains(["always", "advanced", "hide"], config.display)
    ])
    error_message = "Display values must be one of: always, advanced, hide."
  }
}

variable "unraid_xml_folderpath" {
  type        = string
  description = "Folder location where Unraid DockerMan XML template files will be generated. Default is Unraid's user templates directory."
  default     = "/boot/config/plugins/dockerMan/templates-user"

  validation {
    condition     = can(regex("^/.*", var.unraid_xml_folderpath))
    error_message = "Unraid XML folder path must be an absolute path starting with '/'."
  }
}
