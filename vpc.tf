module "network" {
  source = "./modules/network"

  name = "challenge-vpc"
  cidr = "10.1.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]

  private_subnets = [
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]

  enable_nat_gateway  = true
  single_nat_gateway  = true

  tags = {
    Owner       = "Carlos"
    Environment = "test"
    Project     = "aws-tech-challenge"
    ManagedBy   = "terraform"
  }
}

