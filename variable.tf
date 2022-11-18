variable name {}

variable github_token {
	default="GITHUB_TOKEN"
}

variable harness_github_repo {
	default="delegate-template"
}

variable harness_delegate_template {
	default="immutable-harness-delegate.yaml"
}

variable accountId {
	default="ACCOUNT_ID"
}

variable token {
	default="TOKEN" 
}

variable host {
	default="MANAGER_HOST"
}

variable replica {
	default=1
}

variable tags {
	default=""
}

variable namespace {
	default="harness-delegate-ng"
}

variable image {
	default="IMAGE"
}

variable memory {
	default="2048Mi"
}

variable cpu {
	default="1"
}

variable init_script {
	default=""
}
