output "xml_file_path" {
  description = "The full path to the generated XML file"
  value       = local_file.docker_unraid_xml.filename
}

output "xml_file_content" {
  description = "The content of the generated XML file"
  value       = local_file.docker_unraid_xml.content
}

output "container_name" {
  description = "The name of the container from the shared container data"
  value       = var.shared_container_data.name
}

output "xml_folder_path" {
  description = "The folder path where XML files are generated"
  value       = var.unraid_xml_folderpath
}

output "template_data" {
  description = "The complete template data object used for XML generation"
  value       = local.template_data
}