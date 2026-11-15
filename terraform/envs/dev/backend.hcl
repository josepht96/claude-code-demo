# bucket = the state_bucket output of terraform/bootstrap.
bucket       = "demo-tfstate-REPLACE_WITH_ACCOUNT_ID"
key          = "envs/dev/terraform.tfstate"
region       = "us-east-2"
encrypt      = true
use_lockfile = true
# profile    = "my-aws-profile"
