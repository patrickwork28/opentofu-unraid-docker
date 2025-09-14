variable "containers" {
  description = "Map of container configurations with unique keys for stable resource addressing. Each container includes Docker runtime settings and Unraid template metadata."
  type = map(object({
    name       = string
    hostname   = string
    image      = string
    network    = string
    restart    = string
    pids_limit = number
    user = optional(string)
    privileged = optional(bool, false)
    command    = optional(list(string), [])
    entrypoint = optional(list(string), [])

    envs = optional(list(object({
      name  = string
      value = string
    })), [])

    ports = optional(list(object({
      host      = number
      container = number
      protocol  = string
    })), [])

    mounts = optional(list(object({
      host_path      = string
      container_path = string
      mode           = string  # "ro" or "rw"
    })), [])

    labels = optional(list(object({
      name  = string
      value = string
    })), [])

    devices = optional(list(object({
      host_path      = string
      container_path = string
      permissions    = string
    })), [])

    template_data = object({
      shell = string
      repository     = string
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
      myip       = optional(string, "")
      postargs   = optional(string, "")
      cpuset     = optional(string, "")
      requires   = optional(string, "")
    })
  }))

  validation {
    condition = alltrue([
      for key, container in var.containers : can(regex("^[a-z0-9-]+$", key))
    ])
    error_message = "Container keys must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : can(regex("^[a-z0-9-]+$", container.name))
    ])
    error_message = "Container names must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : contains(["no", "on-failure", "always", "unless-stopped"], container.restart)
    ])
    error_message = "Restart policy must be one of: no, on-failure, always, unless-stopped."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : contains(["bridge", "host", "none"], container.network)
    ])
    error_message = "Network mode must be one of: bridge, host, none."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : contains(["sh", "bash"], container.template_data.shell)
    ])
    error_message = "Shell must be either 'sh' or 'bash'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for port in try(container.ports, []) :
        contains(["tcp", "udp"], port.protocol)
      ])
    ])
    error_message = "Port protocols must be either 'tcp' or 'udp'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for mount in try(container.mounts, []) :
        can(regex("^/.*", mount.host_path))
      ])
    ])
    error_message = "Host paths must be absolute paths starting with '/'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for mount in try(container.mounts, []) :
        contains(["ro", "rw"], mount.mode)
      ])
    ])
    error_message = "Mount modes must be either 'ro' (read-only) or 'rw' (read-write)."
  }
}

variable "unraid_xml_folderpath" {
  description = "The folder path where Unraid XML files will be generated"
  type        = string
  default     = "./unraid-xml"
}
