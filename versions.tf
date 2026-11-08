terraform {
  required_version = ">= 1.7.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  encryption {
    key_provider "pbkdf2" "state_passphrase" {
      passphrase = var.state_encryption_passphrase
    }

    method "aes_gcm" "state_aes" {
      keys = key_provider.pbkdf2.state_passphrase
    }

    state {
      method   = method.aes_gcm.state_aes
      enforced = true
    }

    plan {
      method   = method.aes_gcm.state_aes
      enforced = true
    }
  }
}

provider "github" {
  owner = "aljazkovac"
}

