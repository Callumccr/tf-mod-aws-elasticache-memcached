module "label" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.14.1"
  context             = var.context
  delimiter           = "-"
  attributes          = [""]
  additional_tag_map  = {} /* Additional attributes (e.g. 1) */
}


module "cache_label" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.14.1"
  context             = var.context
  delimiter           = "-"
  attributes          = ["memcached"]
  label_order         = ["environment", "namespace", "attributes"] /* elasticcache only supports cluster id's up to 20 characters long */
  additional_tag_map  = {} /* Additional attributes (e.g. 1) */
}

module "subnet_label" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.14.1"
  context             = var.context
  delimiter           = "-"
  attributes          = ["subnet", "group"]
  additional_tag_map  = {} /* Additional attributes (e.g. 1) */
}

module "parameter_group_label" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.14.1"
  context             = var.context
  delimiter           = "-"
  attributes          = ["parameter", "group"]
  additional_tag_map  = {} /* Additional attributes (e.g. 1) */
}




