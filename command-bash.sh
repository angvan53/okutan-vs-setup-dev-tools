🚀 Kullanım Adımları:
Script’i oluştur:

bash
nano setup-dev-tools.sh
# setup-dev-tools.sh
# Bu script, geliştiriciler için gerekli araçları kurar ve yapılandırır.
# Gerekli araçlar: Ansible, NGINX, Bicep CLI, jq, yq, k9s, kubectx, kubens, terraform-docs
# Bu script, Ubuntu tabanlı sistemlerde çalışmak üzere tasarlanmıştır.
# Gerekli izinleri ver:

İçeriği yapıştır (yukarıdan).
# Ardından, script’i kaydedip çıkın (Ctrl + X, Y, Enter).
# Script’i çalıştırılabilir yapın:
chmod +x setup-dev-tools.sh
# Kurulumu başlatın:
./setup-dev-tools.sh    
# Kurulum tamamlandığında, kullanıcıya kurulumun başarıyla tamamlandığını bildiren bir mesaj gösterir.
#!/bin/bash
# setup-dev-tools.sh - Geliştirici Araçları Kurulumu    
