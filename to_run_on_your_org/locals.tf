locals {
  
  l7ilb_subnets = {
    for env, v in var.l7ilb_subnets : env => [
      for s in v : merge(s, {
        active = true
        name   = "${env}-l7ilb-${s.region}"
    })]
  }
  
}