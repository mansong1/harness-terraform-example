export HARNESS_ACCOUNT_ID=
export HARNESS_ENDPOINT=
export HARNESS_PLATFORM_API_KEY=

export TF_VAR_platform_api_key=
export TF_VAR_account_id=
export TF_VAR_endpoint=

terraform apply -var-file="secret.tfvars"
