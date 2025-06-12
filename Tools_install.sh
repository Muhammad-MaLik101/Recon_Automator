#!/bin/bash

echo " "
echo "            *** Created By Muhammad_MaLik ***    "
echo " "

# Update system
sudo apt update -y
sudo apt upgrade -y

# Create tools directory
mkdir -p ~/Tools
cd ~/Tools

echo "----------------------------------------------"
echo "[*] Installing APT packages..."

sudo apt install -y python3-pip unzip pipx golang sublist3r gobuster eyewitness tor torbrowser-launcher naabu httprobe dirb dirbuster assetfinder konsole nmap massdns

echo "----------------------------------------------"
echo "[*] Installing Python packages..."

pip3 install --upgrade pip
sudo pipx install eyewitness
sudo pipx install jsbeautifier

echo "----------------------------------------------"
echo "[*] Installing Go-based tools..."

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/lc/subjs@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/gruntwork-io/git-xargs@latest
go install github.com/edoardottt/cariddi/cmd/cariddi@latest

echo "----------------------------------------------"
echo "[*] Cloning manual tools..."

git clone https://github.com/m4ll0k/SecretFinder.git
git clone https://github.com/GerbenJavado/LinkFinder.git
git clone https://github.com/NitinYadav00/Bug-Bounty-Search-Engine.git
git clone https://github.com/LukaSikic/subzy.git
git clone https://github.com/tdubs/crt.sh.git
git clone https://github.com/htr-tech/zphisher.git
git clone https://github.com/1N3/Sn1per.git
git clone https://github.com/tomnomnom/gf.git
git clone https://github.com/shmilylty/OneForAll.git
git clone https://github.com/nahamsec/JSParser.git
git clone https://github.com/tomdev/teh_s3_bucketeers.git
git clone https://github.com/wpscanteam/wpscan.git
git clone https://github.com/maurosoria/dirsearch.git
git clone https://github.com/nahamsec/lazys3.git
git clone https://github.com/jobertabma/virtual-host-discovery.git
git clone https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
git clone https://github.com/guelfoweb/knock.git
git clone https://github.com/nahamsec/lazyrecon.git
git clone https://github.com/yassineaboukir/asnlookup.git
git clone https://github.com/nahamsec/bbht.git
git clone https://github.com/mrco24/OK-VPS.git

echo "----------------------------------------------"
echo "[*] Setting permissions and building some tools..."

cd subzy && go build main.go && mv main subzy && sudo cp subzy /usr/bin/ && cd ..
cd anew && go build && sudo cp anew /usr/bin/ && cd ..
cd ffuf && go get && go build && sudo cp ffuf /usr/bin/ && cd ..
cd gf && go build main.go && mv main gf && sudo cp gf /usr/bin && cd ..

# Optional: massdns build
cd massdns && make && cd ..

echo "----------------------------------------------"
echo "[*] Installing Burp Suite (unofficial script)..."
curl https://raw.githubusercontent.com/xiv3r/Burpsuite-Professional/main/install.sh | sudo bash

echo "----------------------------------------------"
echo "             ✅ All tools installed!"
echo "            *** Created By Muhammad_MaLik ***"
