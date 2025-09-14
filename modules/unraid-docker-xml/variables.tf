variable "shared_container_data" {
  description = "Shared container configuration data used by both docker-container and unraid-docker-xml modules"
  type = object({
    name       = string
    image      = string
    network    = string
    privileged = bool
    hostname   = optional(string)
    restart    = optional(string)
    user       = optional(string)
    command    = optional(list(string), [])
    entrypoint = optional(list(string), [])
    envs       = optional(list(object({
      name  = string
      value = string
    })), [])
    ports   = optional(list(object({
      host      = number
      container = number
      protocol  = string
    })), [])
    mounts  = optional(list(object({
      host_path      = string
      container_path = string
      mode           = string
    })), [])
    labels  = optional(list(object({
      name  = string
      value = string
    })), [])
    devices = optional(list(object({
      host_path      = string
      container_path = string
      permissions    = string
    })), [])
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.shared_container_data.name))
    error_message = "Container name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["bridge", "host", "none"], var.shared_container_data.network)
    error_message = "Network must be one of: bridge, host, none."
  }
}

variable "xml_specific_data" {
  description = "XML-specific configuration data for Unraid DockerMan template generation"
  type = object({
    name           = string
    overview       = string
    requires       = optional(string, "")
    support        = optional(string, "")
    project        = optional(string, "")
    registry       = optional(string, "")
    icon           = optional(string, "")
    webui          = optional(string, "")
    extra_params   = optional(string, "")
    postargs       = optional(string, "")
    cpuset         = optional(string, "")
    shell          = optional(string, "sh")
    category       = string
    template_url   = optional(string, "")
    date_installed = optional(string, "")
    donate_text    = optional(string, "")
    donate_link    = optional(string, "")
    myip           = optional(string, "")
  })

  validation {
    condition     = contains(["sh", "bash"], var.xml_specific_data.shell)
    error_message = "Shell must be either 'sh' or 'bash'."
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

variable "unraid_xml_folderpath" {
  type        = string
  description = "Folder location where Unraid DockerMan XML template files will be generated. Default is Unraid's user templates directory."
  default     = "/boot/config/plugins/dockerMan/templates-user"

  validation {
    condition     = can(regex("^/.*", var.unraid_xml_folderpath))
    error_message = "Unraid XML folder path must be an absolute path starting with '/'."
  }
}
