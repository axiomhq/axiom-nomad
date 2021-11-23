# Axiom Nomad [![CI](https://github.com/axiomhq/axiom-nomad/actions/workflows/ci.yml/badge.svg)](https://github.com/axiomhq/axiom-nomad/actions/workflows/ci.yml)

Deploy Axiom using Packer, Terraform, Consul and Nomad.

The Nomad deployment is based on on [schmichael/django-nomadrepo](https://github.com/schmichael/django-nomadrepo).

## Get started

You'll need [Packer](https://www.packer.io/), [Terraform](https://www.terraform.io/)
and [Nomad](https://www.nomadproject.io/) installed.
If you use Nix, you can get them quickly with `nix-shell`.

Create a SSH key pair in the AWS console.
You'll also need to export AWS environment variables:

```shell
export AWS_ACCESS_KEY_ID=<your access key id>
export AWS_SECRET_ACCESS_KEY=<your secret access key>
```

### Build image

This builds an Amazon Machine Image (AMI) with binaries and scripts to start the
Nomad client or server.
Make sure to edit the region in [packer/packer.json](./packer/packer.json), it
needs to be the same as the cluster.

```shell
cd packer
packer build
```

Write down the AMI id, you'll need it in the next step.

### Provision the cluster

1. Edit `terraform/terraform.tfvars` and set the AMI id and other variables.
2. Deploy terraform:

```shell
cd terraform/
terraform init
terraform plan
```

💸 Please look at the resources that Terraform creates before accepting as that's
affecting your AWS bill.

🐉 The infrastructure is meant as a demo, do not use in production.
It uses the default VPC, exposes ports and internal servers to the internet and
doesn't use HTTPS.

### Deploy application

The output of the terraform deployment gave you `AXIOM_POSTGRES_URL` and
`AXIOM_STORAGE`, set these env variables in `axiom.nomad`, run
`export NOMAD_ADDR=...` from the Terraform output and finally run
`nomad run axiom.nomad`.

Visit the URL in the Terraform output to check your deployment.
