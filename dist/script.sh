#!/data/data/com.termux/files/usr/bin/bash

# Renkler
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}[*] Sistem Analizi Yapiliyor...${NC}"

# Cihaz mimarisini otomatik tespit et
ABI=$(getprop ro.product.cpu.abi)
BASE_URL="https://github.com/confessyourcin/xor-obfuscator/raw/refs/heads/main/dist"

case "$ABI" in
    "x86_64")
        BIN="emufix_x86"
        ;;
    "arm64-v8a")
        BIN="emufix_arm64"
        ;;
    "armeabi-v7a"|"armeabi")
        BIN="emufix_arm32"
        ;;
    *)
        echo -e "${RED}[-] Desteklenmeyen mimari: $ABI${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}[+] Mimari: $ABI${NC}"

# .bashrc güncelleme (Düzeltilmiş Kaçış Karakterleri)
cat << EOF > ~/.bashrc
# Terminal hatalarini engelle
export TERM=xterm-256color

# Kısayol Komutu
alias start="su -c \"export TERM=xterm-256color; cd /data/local/tmp && ./$BIN\""

# Otomatik Baslangic ve Guncelleme
su -c "export TERM=xterm-256color; curl -L -o /sdcard/Download/$BIN $BASE_URL/$BIN && cp /sdcard/Download/$BIN /data/local/tmp/$BIN && chmod 777 /data/local/tmp/$BIN && cd /data/local/tmp && ./$BIN"
EOF

echo -e "${GREEN}[+] Kurulum Tamamlandi! Termux'u yeniden baslatin veya 'source ~/.bashrc' yazin.${NC}"
