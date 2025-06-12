#!/bin/bash

echo "[*] Installing required tools for recon..."

# Update system and install basic tools
sudo apt update
sudo apt install -y golang-go jq xsltproc nmap masscan ffuf eyewitness whois curl git python3-pip unzip

# Set Go path
export PATH=$PATH:$(go env GOPATH)/bin

# Install Go-based tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

# Install Python-based tools
pip3 install --upgrade pip
pip3 install waybackurls gau katana waymore

# Done message
echo ""
echo "[*] Done! Tools are installed."

echo ""
echo "[!] You still need to manually install these tools:"
echo " - SecretFinder  => https://github.com/m4ll0k/SecretFinder"
echo " - LinkFinder    => https://github.com/GerbenJavado/LinkFinder"
echo " - github-subdomains => https://github.com/gwen001/github-subdomains"
echo " - slurp         => https://github.com/darkbitio/slurp"
echo " - socialhunter  => https://github.com/utkusen/socialhunter"
