# Recon_Automator

A fully automated reconnaissance framework for bug bounty hunting.

**Author:** Muhammad MaLik

## 🚀 Features
- Subdomain enumeration from multiple sources
- Live host discovery
- JS file & secret scraping
- Archived URL scraping & pattern matching
- Port scanning and directory brute-forcing
- ASN/IP/CIDR mapping
- Visual recon with screenshots
- Broken link & S3 bucket hunting

## 🛠 Requirements

Run this installer to set up all tools:

```bash
chmod +x install_recon_tools.sh
./install_recon_tools.sh

Note: You'll need to manually install:
SecretFinder
LinkFinder
github-subdomains
slurp
socialhunter

🚦 Usage
chmod +x reconautomator.sh
./reconautomator.sh

You'll be asked to enter the target domain.

📂 Output
Everything is saved in a dated folder:
<domain>_recon_<date>/
