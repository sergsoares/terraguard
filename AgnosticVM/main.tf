terraform {
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      wireguard = var.host
      key       = var.key_name
      mobile    = var.mobile ? true : "False"
      user    = var.user
      ssh_key = var.ssh_key
    }
  )
  filename = "../ansible/hosts.cfg"
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/hosts.cfg ../ansible/main.yml"
  }
  depends_on = [
    local_file.hosts_cfg
  ]
}

resource "null_resource" "mobile_qr" {
  count = var.mobile ? 1 : 0
  provisioner "local-exec" {
    command = "qrencode -t ansiutf8 < /tmp/terraguard-mobile.conf"
  }
  depends_on = [
    null_resource.ansible
  ]
}

output "HELP" {
  value = "To start VPN run: sudo systemctl start wg-quick@wg0"
}

output "ExitIP" {
  value = var.host
}
