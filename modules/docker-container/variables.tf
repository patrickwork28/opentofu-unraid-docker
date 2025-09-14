variable "container_data" {
  description = "Complete container configuration object including runtime settings, networking, volumes, and environment variables"
  type = object({
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
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.container_data.name))
    error_message = "Container name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["no", "on-failure", "always", "unless-stopped"], var.container_data.restart)
    error_message = "Restart policy must be one of: no, on-failure, always, unless-stopped."
  }

  validation {
    condition     = contains(["bridge", "host", "none"], var.container_data.network)
    error_message = "Network mode must be one of: bridge, host, none."
  }

  validation {
    condition     = var.container_data.pids_limit > 0
    error_message = "PIDs limit must be greater than 0."
  }
}
