variable "state_encryption_passphrase" {
  description = "Passphrase used by OpenTofu PBKDF2 key provider to encrypt terraform.tfstate with AES-GCM (minimum 16 characters)."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.state_encryption_passphrase) >= 16
    error_message = "The state_encryption_passphrase must be at least 16 characters long."
  }
}

