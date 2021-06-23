# ecs_terraform

This terraform ecs module build ecs on ec2 (with capacity provider) or fargate.

This template uses a pre-built vpc module. You can update your vpc configs in the Variables file if you have a pre-existing vpc you want to use, and additional vpc will not be created if the variable is configured.

2 example services are created, 1 on EC2, the other on Fargate.

Update the variables.tf and run

`$ terraform plan`
to validate your build


then

`$ terraform apply` to deploy


if you choose to run this cluster as `"fargate_only" = true` , no ec2 resources will be created.