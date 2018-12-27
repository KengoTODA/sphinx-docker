workflow "Push docker image to docker hub" {
  on = "push"
  resolves = [
    "Docker Registry",
    "Tag base",
    "Push base",
    "Run actions only on master branch",
  ]
}

action "Docker Registry" {
  needs = "Run actions only on master branch"
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

action "Tag base" {
  uses = "actions/docker/tag@76ff57a"
  args = "sphinx-base kengotoda/sphinx-base"
  needs = ["Build base"]
}

action "Push base" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Tag base"]
  args = "push kengotoda/sphinx-base"
}

action "Run actions only on master branch" {
  uses = "actions/bin/filter@b2bea07"
  args = "branch master"
}
