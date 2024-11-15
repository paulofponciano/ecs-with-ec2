namespace = "pegasus"
domain_name = "ecs-demo.pauloponciano.digital"
service_name = "pegasus-service"
project = "ecs-demo"
environment = "qas"
region = "us-east-2"
az_count = 2
vpc_cidr_block = "10.1.0.0/16"
instance_type = "t3a.medium"
ecs_task_desired_count = 2
ecs_task_min_count = 2
ecs_task_max_count = 20
ecs_task_deployment_minimum_healthy_percent = 50
ecs_task_deployment_maximum_percent = 100
cpu_target_tracking_desired_value = 60
memory_target_tracking_desired_value = 60
maximum_scaling_step_size = 5
minimum_scaling_step_size = 1
target_capacity = 100
container_port = 80
cpu_units = 100
memory = 256
retention_in_days = 7
autoscaling_max_size = 2
autoscaling_min_size = 1
healthcheck_endpoint = "/"
healthcheck_matcher = "200,302"