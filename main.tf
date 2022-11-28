resource "null_resource" "get_harness_delegate_template" {
	triggers = {
    delegate_name = "${var.name}"
  	}
	provisioner "local-exec" {
    command = "curl  https://raw.githubusercontent.com/harness-apps/delegate-template/main/harness-delegate.yaml > harness-delegate.yaml"
  }
}

data "local_file" "harness_delegate" {
	depends_on = [null_resource.get_harness_delegate_template]
    filename = "harness-delegate.yaml"
}

resource "null_resource" "get_delegate_image_tag" {
	depends_on = [data.local_file.harness_delegate]
	triggers = {
    delegate_name = "${var.name}"
  	}
	provisioner "local-exec" {
    command = "curl  https://stress.harness.io/api/version/delegate/immutable/ring4 > image-tag.json"
  }
}

data "local_file" "image_tag" {
	depends_on = [null_resource.get_delegate_image_tag]
    filename = "image-tag.json"
}

locals {    
    response_data = jsondecode(data.local_file.image_tag.content)
    image_tag = local.response_data.resource
}

resource "local_file" "delegate_name" {
    content  = "${replace(data.local_file.harness_delegate.content,"delegate_name", "${var.name}")}"
    filename = "harness.yaml"
}

resource "local_file" "host" {
    content  = "${replace(resource.local_file.delegate_name.content,"delegate_manager_host", "${var.host}")}"
    filename = "harness.yaml"
}

resource "local_file" "accountId" {
    content  = "${replace(resource.local_file.host.content,"delegate_accountId", "${var.accountId}")}"
    filename = "harness.yaml"
}

resource "local_file" "token" {
    content  = "${replace(resource.local_file.accountId.content,"delegate_token", "${var.token}")}"
    filename = "harness.yaml"
}

resource "local_file" "replica" {
    content  = "${replace(resource.local_file.token.content,"delegate_replica", "${var.replica}")}"
    filename = "harness.yaml"
}

resource "local_file" "tags" {
    content  = "${replace(resource.local_file.replica.content,"delegate_tags", "${var.tags}")}"
    filename = "harness.yaml"
}

resource "local_file" "namespace" {
    content  = "${replace(resource.local_file.tags.content,"delegate_ns", "${var.namespace}")}"
    filename = "harness.yaml"
}

resource "local_file" "image" {
    content  = "${replace(resource.local_file.namespace.content,"delegate_image", local.image_tag)}"
    filename = "harness.yaml"
}

resource "local_file" "memory" {
    content  = "${replace(resource.local_file.image.content,"delegate_memory", "${var.memory}")}"
    filename = "harness.yaml"
}

resource "local_file" "cpu" {
    content  = "${replace(resource.local_file.memory.content,"delegate_cpu", "${var.cpu}")}"
    filename = "harness.yaml"
}

resource "local_file" "init_script" {
    content  = "${replace(resource.local_file.cpu.content,"delegate_init_script", "${var.init_script}")}"
    filename = "harness.yaml"
}

resource "null_resource" "cluster-login" {
  
  triggers = {
    delegate_name = "${var.name}"
  }
  provisioner "local-exec" {
      command = "kubectl apply -f harness.yaml"
  }
  
}
