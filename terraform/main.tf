module "compute" {
  source = "./modules/compute"
  
  aws_profile      = "terraform-personal"
  aws_region       = "af-south-1"
  team_name        = "devops"
  environment_name = "dev"
  project_name     = "webserver"
  ami_prefix       = "packer-ansible"
  instance_type    = "t3.micro"
  ssh_key_name     = "laptop"
  vpc_name         = "main"
  network_tier     = "public"
}