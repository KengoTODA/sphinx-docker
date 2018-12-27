workflow "Push docker image to docker hub" {
  on = "push"
  resolves = ["Docker Registry", "Tag base-pdf", "Tag base"]
}

action "Docker Registry" {
  uses = "actions/docker/login@76ff57a"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build base" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Docker Registry"]
  args = "build -t sphinx-base base"
}

action "Build base-pdf" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Docker Registry"]
  args = "build -t sphinx-base-pdf base-pdf"
}

action "Tag base-pdf" {
  uses = "actions/docker/tag@76ff57a"
  args = "sphinx-base-pdf kengotoda/sphinx-base-pdf"
  needs = ["Build base-pdf"]
}

action "Tag base" {
  uses = "actions/docker/tag@76ff57a"
  args = "sphinx-base kengotoda/sphinx-base"
  needs = ["Build base"]
}
