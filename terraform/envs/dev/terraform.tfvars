project = "demo"
region  = "us-east-2"

# aws_profile         = "my-aws-profile"
# allowed_account_ids = ["123456789012"]

vpc_cidr           = "10.0.0.0/16"
az_count           = 2
enable_nat_gateway = false

# Demo convenience: lets `terraform destroy` clean up a bucket with objects.
bucket_force_destroy = true

instance_type = "t3.micro"
# Lock this down to your own IP for a real demo: curl -s https://checkip.amazonaws.com
allowed_http_cidrs = ["0.0.0.0/0"]
instance_running   = true
