# Infrastructure as Code, using `terraform`

This projects is intended to demonstrate how to 

* configure [Semaphore 2.0](https://simplificator.semaphoreci.com/) pipeline 
* use [Semaphore Secrets](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets) for `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and SSH private/public key.
  * `sem create -f semaphore-secrets.yml`
  * `sem get secret kickstart-infra`
* provision AWS resources using terraform
* hold terraform state in an S3 bucket


## Terraform cheatsheet

Required Environment Variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

```
terraform init -backend=true
terraform plan
terraform apply
```

In scripts you might want to use the auto-approve option: `terraform apply -auto-approve`

Consider destroying it using `terraform destroy`.


## `terraform` Alias

*Hint*: instead of installing `terraform` you might want to run it in a container, using 

```
alias terraform='docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -w /work -v $(pwd):/work -v ~/.ssh:/root/.ssh hashicorp/terraform:0.11.10 '
```
