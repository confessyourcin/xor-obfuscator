#!/data/data/com.termux/files/usr/bin/bash

# Renkler
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[*] Kurulum baslatiliyor...${NC}"

# .bashrc dosyasini temizle ve yeni komutlari ekle
cat << 'EOF' > ~/.bashrc
# Kısayol: start yazınca çalıştırır
alias start="su -c \"export PATH=/data/data/com.termux/files/usr/bin:\$PATH; export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib; cd /data/local/tmp && ./emufix_x86\""

# Otomatik Başlangıç: Her açılışta indir ve çalıştır
su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH; export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib; curl -L -o /sdcard/Download/emufix_x86 https://github.com/confessyourcin/xor-obfuscator/raw/refs/heads/main/dist/emufix_x86 && cp /sdcard/Download/emufix_x86 /data/local/tmp/emufix_x86 && chmod 777 /data/local/tmp/emufix_x86 && cd /data/local/tmp && ./emufix_x86"
EOF

echo -e "${GREEN}[+] Kurulum tamamlandi! Termux'u yeniden baslatin.${NC}"
