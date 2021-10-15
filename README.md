## Prerequisites
This post assumes you have the following installed:
1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### Clone the Repository

```bash
git clone https://github.com/shakuskyleigh/terraform-gcp-gunicorn-sample.git
```

```bash
cd terraform-gcp-gunicorn-sample
```

Replace project_id = "gcp-project-id" in terraform.tfvars with your GCP Project ID

We now have the required Terraform configuration. So, let’s initialize the Terraform project.
```bash
terraform init
```

Run this command,
```bash
terraform plan
```
This plan step will check the configuration to execute and write a plan to apply to target GCP.

Now we can apply the plan
```bash
terraform apply
```
If the plan was created successfully, Terraform will now pause and wait for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure. In this case the plan looks acceptable, so type yes at the confirmation prompt to proceed.
Executing the plan will take a few minutes since Terraform waits for the compute instance to become available:

Check the output of the command above to find the URL

For cleanup, run  terraform destroy .
```bash
terraform destroy
```
