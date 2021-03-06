terraform {
  source = "/home/hultaj/dday/tf_dday_org/modules/bucket"
}

locals {
  name = lookup(yamldecode(file("${find_in_parent_folders("common_vars.yaml")}")), "name")
}

inputs = {
      bucket_name = local.name
}

remote_state {
  backend = "local"

  config = {
    path = "/home/hultaj/dday/tf_dday_org/states/buckets/${local.name}/terraform.tfstate"
  }
}

dependency "account" {
  config_path = "/home/hultaj/dday/tf_dday_org/terragrunt/${local.name}/account"
}

iam_role = "arn:aws:iam::${dependency.account.outputs.id}:role/adminAssumeRole"

