provider "github" {
	token = "${var.github_token}"
}

data "github_repository_file" "harness_delegate_template" {
	provider   = github
  	repository          = "${var.harness_github_repo}"
  	file                = "${var.harness_delegate_template}"
}

resource "local_file" "delegate_name" {
    content  = "${replace(data.github_repository_file.harness_delegate_template.content,"delegate_name", "${var.name}")}"
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
    content  = "${replace(resource.local_file.namespace.content,"delegate_image", "${var.image}")}"
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

  provisioner "local-exec" {
      command = "kubectl apply -f harness.yaml"
  }
}