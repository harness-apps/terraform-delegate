resource "null_resource" "get_harness_delegate_template" {
	provisioner "local-exec" {
    command = "curl  https://raw.githubusercontent.com/harness-apps/delegate-template/main/harness-delegate.yaml > harness-delegate.yaml"
  }
}

data "local_file" "harness_delegate" {
	depends_on = [null_resource.get_harness_delegate_template]
    filename = "harness-delegate.yaml"
}

resource "local_file" "delegate_name" {
    content  = "${replace(data.local_file.harness_delegate.content,"<DELEGATE_NAME>", "${var.name}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "host" {
    content  = "${replace(resource.local_file.delegate_name.content,"<DELEGATE_MANAGER_HOST>", "${var.host}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "accountId" {
    content  = "${replace(resource.local_file.host.content,"<DELAGATE_ACCOUNT_ID>", "${var.accountId}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "token" {
    content  = "${replace(resource.local_file.accountId.content,"<DELEGATE_TOKEN>", "${var.token}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "replica" {
    content  = "${replace(resource.local_file.token.content,"<DELEGATE_REPLICA>", "${var.replica}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "tags" {
    content  = "${replace(resource.local_file.replica.content,"<DELEGATE_TAGS>", "${var.tags}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "namespace" {
    content  = "${replace(resource.local_file.tags.content,"<DELEGATE_NAMESPACE>", "${var.namespace}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "image" {
    content  = "${replace(resource.local_file.namespace.content,"<DELEGATE_IMAGE>", "${var.image}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "memory" {
    content  = "${replace(resource.local_file.image.content,"<DELEGATE_MEMORY>", "${var.memory}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "cpu" {
    content  = "${replace(resource.local_file.memory.content,"<DELEGATE_CPU>", "${var.cpu}")}"
    filename = "harness-${var.name}.yaml"
}

resource "local_file" "init_script" {
    content  = "${replace(resource.local_file.cpu.content,"<DELEGATE_INIT_SCRIPT>", "${var.init_script}")}"
    filename = "harness-${var.name}.yaml"
}

resource "null_resource" "cluster-login" {
  triggers = {
    delegate_name = "${var.name}"
  }

  provisioner "local-exec" {
      command = "kubectl apply -f harness-${var.name}.yaml"
  }
}
