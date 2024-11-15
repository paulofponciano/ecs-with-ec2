variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "domain_name" {
  description = "Domain name of the service (like service.example.com)"
  type        = string
}

variable "service_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
}

variable "project" {
  description = "Scenario name for tags"
  type        = string
}

variable "environment" {
  description = "Environment for deployment (like dev or staging)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  type        = string
}

variable "az_count" {
  description = "Describes how many availability zones are used"
  type        = number
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "ecs_task_desired_count" {
  description = "How many ECS tasks should run in parallel"
  type        = number
}

variable "ecs_task_min_count" {
  description = "How many ECS tasks should minimally run in parallel"
  type        = number
}

variable "ecs_task_max_count" {
  description = "How many ECS tasks should maximally run in parallel"
  type        = number
}

variable "ecs_task_deployment_minimum_healthy_percent" {
  description = "How many percent of a service must be running to still execute a safe deployment"
  type        = number
}

variable "ecs_task_deployment_maximum_percent" {
  description = "How many additional tasks are allowed to run (in percent) while a deployment is executed"
  type        = number
}

variable "cpu_target_tracking_desired_value" {
  description = "Target tracking for CPU usage in %"
  type        = number
}

variable "memory_target_tracking_desired_value" {
  description = "Target tracking for memory usage in %"
  type        = number
}

variable "maximum_scaling_step_size" {
  description = "Maximum amount of EC2 instances that should be added on scale-out"
  type        = number
}

variable "minimum_scaling_step_size" {
  description = "Minimum amount of EC2 instances that should be added on scale-out"
  type        = number
}

variable "target_capacity" {
  description = "Amount of resources of container instances that should be used for task placement in %"
  type        = number
}

variable "container_port" {
  description = "Port of the container"
  type        = number
}

variable "cpu_units" {
  description = "Amount of CPU units for a single ECS task"
  type        = number
}

variable "memory" {
  description = "Amount of memory in MB for a single ECS task"
  type        = number
}

variable "retention_in_days" {
  description = "Retention period for Cloudwatch logs"
  type        = number
}

variable "autoscaling_max_size" {
  description = "Max size of the autoscaling group"
  type        = number
}

variable "autoscaling_min_size" {
  description = "Min size of the autoscaling group"
  type        = number
}

variable "healthcheck_endpoint" {
  description = "Endpoint for ALB healthcheck"
  type        = string
}

variable "healthcheck_matcher" {
  description = "HTTP status code matcher for healthcheck"
  type        = string
}
