# Infrastructure as Code, using `terraform`

Required Environment Variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

```
terraform init -backend=true
terraform plan
terraform apply
```

In scripts you might want to use the auto-approve option: `terraform apply -auto-approve`

*Warning*: the created ElasticSearch service and Kibana will be open to the world!

Consider destroying it using `terraform destroy`.


## `terraform` Alias

*Hint*: instead of installing `terraform` you might want to run it in a container, using 

```
alias terraform='docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -w /work -v $(pwd):/work hashicorp/terraform:0.11.10 '
```
