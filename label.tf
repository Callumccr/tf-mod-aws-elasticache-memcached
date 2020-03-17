module "label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  namespace          = var.namespace
  environment        = var.environment
  name               = var.name
  attributes         = concat(var.attributes, ["memcached"])
  delimiter          = "-"
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["environment", "namespace", "name", "attributes"]
}

module "sg_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  delimiter          = "-"
  attributes         = ["sg"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["environment", "namespace", "name", "attributes"]
}

module "subnet_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  delimiter          = "-"
  attributes         = ["subnet", "group"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["environment", "namespace", "name", "attributes"]
}

module "parameter_group_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  delimiter          = "-"
  attributes         = ["parameter", "group"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["environment", "namespace", "name", "attributes"]
}




