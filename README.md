# terraform-packer-ansible-nginx-basic
Example of using Terraform, Packer and Ansible to Deploy Nginx

## About

This demonstration will use ansible for configuration management, packer to build the AMI and terraform to provision the instance from our AMI.

The steps are:

- Build a AMI with Packer
  - Uses the Ansible Provisioner to install a playbook with Nginx and places the website content on the temporary instance
  - Packer then builds the AMI and names it `packer-ansible-{{ timestamp }}`
- Terraform then spins up a EC2 instance from the latest AMI prefix of `packer-ansible`
- Terraform outputs the IP for us to test the website

## Assumptions

If you would like to follow along, these are the existing resources:

1. Default VPC with the name: `main`
2. Subnet Masks with the tag `Tier: public`

## Walkthrough

Build the image with Packer:

```
$ cd packer
$ packer validate packer.json
$ packer build packer.json

amazon-ebs: output will be in this color.

==> amazon-ebs: Prevalidating any provided VPC information
==> amazon-ebs: Prevalidating AMI Name: packer-base-1645985383
    amazon-ebs: Found Image ID: ami-xxxxxxxxx
    amazon-ebs: Found VPC ID: vpc-xxxxxxxx
    amazon-ebs: Found Subnet ID: subnet-xxxxxx
    ...
    amazon-ebs: PLAY RECAP *********************************************************************
    amazon-ebs: 127.0.0.1                  : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    amazon-ebs:
==> amazon-ebs: Stopping the source instance...
    amazon-ebs: Stopping instance
==> amazon-ebs: Waiting for the instance to stop...
==> amazon-ebs: Creating AMI packer-base-1645985383 from instance i-02bc91d40a796f819
    amazon-ebs: AMI: ami-0f3740cc954305c51
==> amazon-ebs: Waiting for AMI to become ready...
==> amazon-ebs: Adding tags to AMI (ami-0f3740cc954305c51)...
==> amazon-ebs: Tagging snapshot: snap-0c2367278db469608
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Datestamp": "2022-02-27T18:09:43Z"
    amazon-ebs: Adding tag: "UUID": "621bc02d-1065-f805-a335-f7d587a3fad5"
    amazon-ebs: Adding tag: "Name": "packer-ansible-1645985383"
    amazon-ebs: Adding tag: "Timestamp": "packer-1645985383"
    amazon-ebs: Adding tag: "BaseAmi": "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220131"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' finished after 5 minutes 27 seconds.

==> Wait completed after 5 minutes 27 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
af-south-1: ami-0f3740cc954305c51

$ cd ..
```

We should now see our AMI in our AWS EC2 Console:

![image](https://user-images.githubusercontent.com/567298/155898207-f9103dcb-1c8f-4b12-b728-869323222e8c.png)

Now since our AMI is baked with our software and website files, we will use Terraform to provision our EC2 instance from that AMI:

```bash
$ terraform -chdir=./terraform init
$ terraform -chdir=./terraform plan
$ terraform -chdir=./terraform apply

...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

ami_id = "ami-0f3740cc954305c51"
instance_id = "i-0733ac46abf0ba2ea"
public_ip = "13.245.164.255"
subnet_id = "subnet-b222c7db"
```

On our AWS EC2 console we will see our EC2 instance in a running state:

![image](https://user-images.githubusercontent.com/567298/155898176-c1f6af69-55e1-4149-be0e-62927bba4a9d.png)

And when we access our Public IP on: http://13.245.164.255 we should see our website:

![image](https://user-images.githubusercontent.com/567298/155898118-cf7a80e6-7e31-45e3-a6dd-76323ecbd456.png)

## Code Structure

The following shows packer, ansible and terraform

```bash
.
├── LICENSE
├── Makefile
├── README.md
├── ansible
│   ├── playbook.yml
│   └── roles
│       └── web
│           ├── defaults
│           │   └── main.yml
│           ├── files
│           │   ├── www
│           │   │   ├── icons
│           │   │   │   └── favicon.ico
│           │   │   ├── index.html
│           │   │   └── styles
│           │   │       ├── font-awesome.css
│           │   │       └── main.css
│           │   └── www.conf
│           ├── handlers
│           ├── meta
│           ├── tasks
│           │   └── main.yml
│           ├── templates
│           │   └── nginx.conf.j2
│           └── vars
├── dependencies
│   └── requirements.txt
├── packer
│   └── packer.json
├── scripts
│   └── bootstrap.sh
└── terraform
    ├── main.tf
    ├── modules
    │   └── compute
    │       ├── locals.tf
    │       ├── main.tf
    │       ├── networking.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```

## Credit

I have always used ansible in a remote fashion, where I had to write out the SSH details with a local-exec step using Terraform, until I met [Adan Patience](), who showed me the beauty of Packer. 

## Extras

Pre-Commit for Terraform:

- [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)

Tools:

- [checkov](https://github.com/bridgecrewio/checkov)
- [terratest](https://terratest.gruntwork.io/)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)
- [terrascan](https://github.com/accurics/terrascan)
- [infracost](https://github.com/infracost/infracost)
- [terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [terraform fmt](https://www.terraform.io/cli/commands/fmt)
- [tfsec](https://github.com/aquasecurity/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)
