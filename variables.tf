variable "fargate" {
  default = false
}

variable "ecs_cluster_type" {
  default = "ec2"
}
variable "ecs_name" {
  description = "Name of cluster"
  default     = "lorenzo_ecs"
}

variable "container_insights" {
  description = "Bool value for enable or disable container_insights"
  default     = true
}

variable "instance_type" {
  default = "t3.small"
}

variable "desired_capacity" {
  description = "Desired number of running nodes"
  default     = 1
}

variable "max_size" {
  description = "Maximum amount of running nodes allowed"
  default     = 4
}

variable "min_size" {
  description = "Minimum amount of running nodes allowed"
  default     = 0
}

variable "rolling_healthy_percentage" {
  description = "Percentage number of nodes to allow for rolling update"
  default     = 50
}

variable "services" {
  default = {
    hello_world = {
      image                              = "nginx"
      cpu                                = 0
      memory                             = 512
      desired_count                      = 2
      deployment_maximum_percent         = 100
      deployment_minimum_healthy_percent = 0
    }
  }
}

variable "repo_name" {
  default = "cloudpaasvalidacao-ecsallinone"
}