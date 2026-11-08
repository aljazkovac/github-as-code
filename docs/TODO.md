# TODO — Remaining Setup & Future Enhancements

## 1. Immediate Setup (Cloud CI/CD & Key Backup)

- [x] **Configure `GH_PAT` Secret for GitHub Actions:**
  1. Go to [GitHub Fine-Grained Personal Access Tokens](https://github.com/settings/personal-access-tokens/new).
  2. Set **Repository access** to **All repositories**.
  3. Grant **Repository permissions**:
     - `Administration`: **Read and write** (manages repo settings, topics, archive states, and branch rulesets)
     - `Contents`: **Read and write** (allows CI to commit updated encrypted `terraform.tfstate`)
     - `Pull requests`: **Read and write** (allows CI to post `tofu plan` comments on PRs)
  4. Save the token to the repository secrets:
     ```bash
     gh secret set GH_PAT --repo aljazkovac/github-as-code
     ```
- [x] **Back Up Encryption Passphrase in Password Manager:**
  Save the `state_encryption_passphrase` value from your local `terraform.tfvars` into your password manager so you can always decrypt `terraform.tfstate` if you switch machines.
- [ ] **Verify End-to-End PR Pipeline:**
  Create a small feature branch, open a Pull Request against `main`, verify that the `OpenTofu Plan Output` comment is posted automatically, and squash-merge to confirm `tofu apply` runs in GitHub Actions.

---

## 2. Portfolio & Profile Integration

- [ ] **Showcase on GitHub Profile ([`aljazkovac/aljazkovac`](https://github.com/aljazkovac/aljazkovac)):**
  Add `github-as-code` to the **Current Projects** section of your profile `README.md`.
- [x] **Commit Roadmap Update in `cockpit`:**
  Commit and push the completed `github-as-code` checkboxes in `cockpit/roadmap/1-short-term-now.md`.

---

## 3. Future Enhancements (2027 Roadmap & `vitalis` Alignment)

- [ ] **Provision `vitalis` Repository & Required CI Status Checks:**
  - Add `vitalis` to `local.repositories` in [`repos.tf`](../repos.tf).
  - Extend [`rulesets.tf`](../rulesets.tf) to support `required_status_checks` so AI agent PRs must pass automated test/lint workflows before merging.
- [ ] **Archive Superseded Health Prototypes:**
  - Once `eat-and-burn` and `calorie-balance` are consolidated into `vitalis`, flip `archived = true` in [`repos.tf`](../repos.tf) to archive them declaratively.
- [ ] **Scheduled Drift Detection:**
  - Add a weekly `schedule` (`cron`) trigger to [`.github/workflows/opentofu.yml`](../.github/workflows/opentofu.yml) to check for out-of-band UI changes across repositories.
- [ ] *(Optional)* **Import Historical Archived Repositories:**
  - Decide whether to import the 24 already-archived coursework/university repositories into a separate `archived_repos.tf` map for complete account-wide inventory.

