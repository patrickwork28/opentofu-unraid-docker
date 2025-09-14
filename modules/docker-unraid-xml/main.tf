resource "local_file" "docker_unraid_xml" {
  content = templatefile("${path.module}/template.xml.tpl", var.template_data)

  filename = "${var.unraid_xml_folderpath}/my-${var.template_data.container_name}.xml"
}
