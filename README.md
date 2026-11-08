# `github-as-code` — Declarative GitHub Governance with OpenTofu

Declarative Infrastructure-as-Code (IaC) repository that manages all active **`aljazkovac`** GitHub repositories, descriptions, topics, visibility, archive states, and branch protection rulesets using **OpenTofu (`tofu`)**, the **`integrations/github`** provider, and **GitHub Actions**.

> **Deep Dive:** See **[`ARCHITECTURE.md`](./ARCHITECTURE.md)** for a full walkthrough of how **PBKDF2 + AES-GCM** state encryption works, how the AI-agent branch protection ruleset tiers are designed, and how to configure `GH_PAT` for CI/CD. See **[`TODO.md`](./TODO.md)** for remaining follow-up tasks and future enhancements.

---

## Architecture Highlights

1. **Single Declarative Catalog ([`repos.tf`](./repos.tf)):**
   All repository metadata (descriptions, topics, visibility, merge settings, archive state, and branch protection tier) lives in a single `local.repositories` map.
2. **Zero External Cloud Accounts (Native AES-GCM State Encryption in [`versions.tf`](./versions.tf)):**
   Uses OpenTofu's built-in **PBKDF2 + AES-GCM** state and plan encryption. `terraform.tfstate` is encrypted client-side before touching disk and safely committed directly to Git.
3. **AI-Agent-Ready Branch Protection Rulesets ([`rulesets.tf`](./rulesets.tf)):**
   Enforces tiered `github_repository_ruleset` policies on `~DEFAULT_BRANCH` (`main`):
   - **`pr-required` (Code repositories: `github-as-code`, `eat-and-burn`, `calorie-balance`):** Blocks branch deletion and force-pushes, enforces linear history, and requires Pull Requests (`required_approving_review_count = 0` so solo/agent PRs can be merged after CI checks without needing a second human account). Includes **Repository Admin** bypass (`actor_id = 5`).
   - **`direct-push` (Content repositories: `aljazkovac`, `aljazkovac.github.io`):** Blocks branch deletion and force-pushes while allowing direct pushes (e.g., automated daily RSS feed updates and blog posts).
   - **`none` (Private repositories: `cockpit`, `playground`):** Manages repository settings and visibility without attaching public-only GitHub Free rulesets.
4. **GitOps CI/CD Pipeline ([`.github/workflows/opentofu.yml`](./.github/workflows/opentofu.yml)):**
   - **Pull Requests:** Runs `tofu fmt -check`, `tofu validate`, and `tofu plan`, posting the plan diff as a sticky PR comment.
   - **Merge to `main`:** Runs `tofu apply -auto-approve` and commits the updated encrypted `terraform.tfstate`.

---

## Day-to-Day Usage

### 1. Local Setup

```bash
# 1. Copy .env.example to .env and set your encryption passphrase
cp .env.example .env

# 2. Initialize OpenTofu
make init

# 3. Preview or apply changes (uses `gh auth token` automatically)
make plan
make apply
```

### 2. Common Operations

- **Update topics or description:** Edit the entry in [`repos.tf`](./repos.tf) and open a PR (or run `make apply`).
- **Archive a retired project:** Change `archived = true` on the repository in [`repos.tf`](./repos.tf).
- **Add a new repository:** Add a new block to `local.repositories` in [`repos.tf`](./repos.tf) and OpenTofu will create and protect it automatically.

---

## Required GitHub Actions Secrets

| Secret Name | Purpose |
| :--- | :--- |
| `GH_PAT` | Fine-Grained Personal Access Token (`All repositories` access with `Administration: Read & Write`, `Contents: Read & Write`, `Pull requests: Read & Write`) |
| `TF_VAR_state_encryption_passphrase` | Passphrase used by OpenTofu PBKDF2 + AES-GCM to decrypt/encrypt `terraform.tfstate` |

