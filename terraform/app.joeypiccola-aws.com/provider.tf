provider "aws" {
  region = var.app.region # <-- using default here does not work, why?
}