#!/bin/bash

echo -e "\033[1;34m🔧 ReconAutomator - Written by Muhammad MaLik\033[0m"

# === [Input] ===
read -p "[+] Enter domain (e.g., example.com): " DOMAIN
ORG=$(echo $DOMAIN | awk -F. '{print $(NF-1)"."$NF}')
DATE=$(date +%Y-%m-%d)
OUTPUT="${DOMAIN}_recon_${DATE}"
mkdir -p "$OUTPUT"/{subs,ips,nmap,js,urls,portscan,vuln,screenshots,tmp,logs,gf}

echo "[*] Recon started on $DOMAIN | Output: $OUTPUT"
cd "$OUTPUT" || exit

# === GitHub Token (hardcoded as requested) ===
export GITHUB_TOKEN="Add_Your_Secret_Github_token"

# === [0] WHOIS & DNS Info ===
echo "[*] WHOIS & DNS Info..."
whois $DOMAIN | tee tmp/whois.txt
nslookup $DOMAIN | tee tmp/nslookup.txt
host $DOMAIN | tee tmp/host.txt

# === [1] Passive Subdomain Enumeration ===
echo "[*] Subdomain Enumeration..."
subfinder -d $DOMAIN | anew subs/subfinder.txt
amass enum -passive -d $DOMAIN | anew subs/amass.txt
assetfinder --subs-only $DOMAIN | anew subs/assetfinder.txt
findomain -t $DOMAIN -q | anew subs/findomain.txt
curl -s "https://crt.sh/?q=%.$DOMAIN&output=json" | jq -r '.[].name_value' | anew subs/crtsh.txt

# GitHub subdomain leaks
echo "[*] GitHub leak check..."
github-subdomains -d $DOMAIN -t $GITHUB_TOKEN | anew subs/github.txt

cat subs/*.txt | sort -u > subs/all.txt

# === [2] Live Host Discovery ===
echo "[*] HTTP Probing..."
httpx -l subs/all.txt -title -status-code -tech-detect -web-server -ip -location \
  -ports 80,443,8080,8443,8000,3000,5000,9090,9200 | tee vuln/httpx_hosts.txt

cut -d ' ' -f1 vuln/httpx_hosts.txt > subs/live.txt
grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' vuln/httpx_hosts.txt | sort -u > ips/active_ips.txt

# === [3] ASN / Infra Recon ===
echo "[*] ASN Recon..."
curl -s "https://api.bgpview.io/search?query_term=$DOMAIN" | jq | tee tmp/asn.json
ASN=$(jq -r '.data.autonomous_systems[0].asn' tmp/asn.json)
asnmap -t $ASN | anew tmp/asnmap.txt
mapcidr -cidr tmp/asnmap.txt -o ips/asn_ips.txt
cat ips/asn_ips.txt >> ips/active_ips.txt
sort -u ips/active_ips.txt -o ips/active_ips.txt

# === [4] Port Scanning ===
echo "[*] Masscan + Nmap scanning..."
masscan -p1-65535 -iL ips/active_ips.txt --rate=1000 -oL portscan/masscan.txt
awk '{print $4}' portscan/masscan.txt | sort -u > portscan/open_ports.txt
nmap -Pn -iL ips/active_ips.txt -p$(paste -sd, portscan/open_ports.txt) \
  --script "discovery,vulners,http-vuln*,ftp*,ssh*,mysql*,imap*,pop3*" \
  -oX nmap/nmap.xml
xsltproc nmap/nmap.xml -o nmap/nmap.html

# === [5] Directory Bruteforcing on Live Hosts ===
echo "[*] Directory bruteforce with ffuf..."
while read url; do
  ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
       -u "$url/FUZZ" -mc all -fs 0 -t 100 \
       -o "vuln/ffuf-$(echo $url | sed 's/https\?:\/\///').txt"
done < subs/live.txt

# === [6] JS & Secrets Recon ===
echo "[*] JS & SecretFinder Recon..."
subjs -i subs/live.txt | anew js/jsfiles.txt
cat js/jsfiles.txt | while read url; do
  python3 ~/tools/LinkFinder/linkfinder.py -i $url -o cli | anew js/links.txt
  python3 ~/tools/SecretFinder/SecretFinder.py -i $url -o cli | anew js/secrets.txt
done

# === [7] URL Collection & Filtering ===
echo "[*] Collecting archived URLs..."
waybackurls $DOMAIN | anew urls/wayback.txt
gau $DOMAIN | anew urls/gau.txt
katana -u $DOMAIN | anew urls/katana.txt
waymore -i $DOMAIN -mode U -o urls/waymore.txt
cat urls/*.txt | sort -u > urls/all_urls.txt
grep -Ei 'token|api|auth|email|user|pass|secret|key|phone' urls/all_urls.txt > urls/juicy.txt

# === [8] GF Pattern Matching ===
echo "[*] Grepping URLs with gf..."
gf xss urls/all_urls.txt | anew gf/xss.txt
gf ssrf urls/all_urls.txt | anew gf/ssrf.txt
gf redirect urls/all_urls.txt | anew gf/redirect.txt
gf sqli urls/all_urls.txt | anew gf/sqli.txt
gf lfi urls/all_urls.txt | anew gf/lfi.txt

# === [9] S3 & Broken Link Hunting ===
echo "[*] Checking for open buckets and broken links..."
slurp -t $DOMAIN | anew tmp/s3.txt
socialhunter -d $DOMAIN | anew tmp/broken.txt

# === [10] Visual Recon ===
echo "[*] Screenshotting live hosts..."
eyewitness --web -f vuln/httpx_hosts.txt -d screenshots/

# === [11] Manual Intelligence ===
echo -e "\n[+] Manual Dorks:"
echo "site:$DOMAIN ext:log | ext:sql | inurl:admin | intitle:index.of"
echo "ssl:\"$DOMAIN\""
echo "ssl.cert.subject.CN:\"$DOMAIN\""
echo "asn:$ASN"

echo -e "\n✅ Recon complete. Data stored in: $OUTPUT/"


