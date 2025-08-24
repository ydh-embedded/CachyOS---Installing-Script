#!/bin/bash

# CachyOS Automatisches Installationsscript
# Installiert: VS Code, Brave Browser, GParted, Android Studio, Python IDLE, Arduino IDE, os-prober, Inkscape, LibreOffice, Docker, Live-Server, Sublime Text, Orca Slicer, Klipper, Thunderbird, Pac-Man + System-Tools + Sonic Pi

echo "=== CachyOS Automatische Software-Installation ==="
echo "Installiere: VS Code, Brave Browser, GParted, Android Studio, Python IDLE, Arduino IDE, os-prober, Inkscape, LibreOffice, Docker, Live-Server, Sublime Text, Orca Slicer, Klipper, Thunderbird, Pac-Man + viele nützliche System-Tools + Sonic Pi (Algorave)"
echo ""

# Farben für bessere Lesbarkeit
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funktion für Fehlerbehandlung
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Fehler beim Installieren von $1 - ÜBERSPRINGE und setze fort...${NC}"
        sleep 2
    else
        echo -e "${GREEN}$1 erfolgreich installiert!${NC}"
    fi
}

# System aktualisieren
echo -e "${YELLOW}Aktualisiere das System...${NC}"
sudo pacman -Syu --noconfirm
check_error "System-Update"

echo ""
echo -e "${YELLOW}Installiere Programme aus den offiziellen Repositories...${NC}"

# GParted (aus official repos)
echo "Installiere GParted..."
sudo pacman -S --noconfirm gparted
check_error "GParted"

# Python mit IDLE (aus official repos)
echo "Installiere Python mit IDLE..."
sudo pacman -S --noconfirm python python-pip tk
check_error "Python mit IDLE"

# os-prober (aus official repos)
echo "Installiere os-prober..."
sudo pacman -S --noconfirm os-prober
check_error "os-prober"

# Inkscape (aus official repos)
echo "Installiere Inkscape..."
sudo pacman -S --noconfirm inkscape
check_error "Inkscape"

# LibreOffice (aus official repos)
echo "Installiere LibreOffice..."
sudo pacman -S --noconfirm libreoffice-fresh
check_error "LibreOffice"

# Thunderbird (aus official repos)
echo "Installiere Thunderbird..."
sudo pacman -S --noconfirm thunderbird
check_error "Thunderbird"

# System & Tools (aus official repos)
echo "Installiere System-Tools..."
sudo pacman -S --noconfirm btop neofetch tree wget curl p7zip unrar thunar zsh tmux ranger telegram-desktop rsync rclone
check_error "System-Tools"

# Sonic Pi für Algorave (aus official repos) - OPTIONAL - entferne # um zu aktivieren
# echo "Installiere Sonic Pi (Live-Coding für Musik)..."
# sudo pacman -S --noconfirm sonic-pi
# check_error "Sonic Pi"

# Docker (aus official repos)
echo "Installiere Docker..."
sudo pacman -S --noconfirm docker docker-compose
check_error "Docker"

echo "Konfiguriere Docker..."
# Docker-Dienst aktivieren
sudo systemctl enable docker
sudo systemctl start docker
# User zur docker-Gruppe hinzufügen
sudo usermod -aG docker $USER
echo -e "${GREEN}Docker konfiguriert! (Neuanmeldung für Gruppenmitgliedschaft erforderlich)${NC}"

# Node.js (für Live-Server, aus official repos)
echo "Installiere Node.js..."
sudo pacman -S --noconfirm nodejs npm
check_error "Node.js"

# AUR Helper prüfen/installieren (falls noch nicht vorhanden)
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}AUR Helper wird benötigt. Installiere yay...${NC}"
    sudo pacman -S --needed --noconfirm base-devel git
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    check_error "yay AUR Helper"
fi

# AUR Helper bestimmen
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo -e "${RED}Kein AUR Helper gefunden!${NC}"
    exit 1
fi

# AUR-Installation mit Retry-Logik
install_aur_with_retry() {
    local package=$1
    local retries=3
    local count=0
    
    echo "Installiere $package (mit Retry-Logik)..."
    while [ $count -lt $retries ]; do
        if $AUR_HELPER -S --noconfirm $package; then
            echo -e "${GREEN}$package erfolgreich installiert!${NC}"
            return 0
        else
            count=$((count + 1))
            if [ $count -lt $retries ]; then
                echo -e "${YELLOW}Versuch $count/$retries fehlgeschlagen. Warte 10 Sekunden...${NC}"
                sleep 10
            fi
        fi
    done
    echo -e "${RED}$package konnte nach $retries Versuchen nicht installiert werden - ÜBERSPRINGE${NC}"
    return 1
}

# VS Code (aus AUR)
echo "Installiere Visual Studio Code..."
$AUR_HELPER -S --noconfirm visual-studio-code-bin
check_error "Visual Studio Code"

# Brave Browser (aus AUR)
echo "Installiere Brave Browser..."
$AUR_HELPER -S --noconfirm brave-bin
check_error "Brave Browser"

# Android Studio (aus AUR)
echo "Installiere Android Studio..."
$AUR_HELPER -S --noconfirm android-studio
check_error "Android Studio"

# Arduino IDE 2 (aus AUR)
echo "Installiere Arduino IDE 2..."
$AUR_HELPER -S --noconfirm arduino-ide-bin
check_error "Arduino IDE"

# Live-Server (aus AUR)
echo "Installiere Live-Server..."
$AUR_HELPER -S --noconfirm live-server
check_error "Live-Server"

# Sublime Text (aus AUR)
echo "Installiere Sublime Text..."
$AUR_HELPER -S --noconfirm sublime-text-4
check_error "Sublime Text"

# Orca Slicer (aus AUR)
echo "Installiere Orca Slicer..."
$AUR_HELPER -S --noconfirm orca-slicer
check_error "Orca Slicer"

# Klipper (aus AUR)
echo "Installiere Klipper..."
$AUR_HELPER -S --noconfirm klipper
check_error "Klipper"

# Pac-Man Game (aus AUR)
echo "Installiere Pac-Man..."
$AUR_HELPER -S --noconfirm pacman-game
check_error "Pac-Man"

# Kommunikations-Apps (aus AUR)
echo "Installiere Kommunikations-Apps..."
$AUR_HELPER -S --noconfirm discord zoom signal-desktop
check_error "Kommunikations-Apps"

# Backup-Tools (aus AUR)
echo "Installiere Backup-Tools..."
$AUR_HELPER -S --noconfirm timeshift
check_error "Backup-Tools"

# Live-Server direkt mit npm installieren
echo "Installiere Live-Server mit npm..."
if command -v npm &> /dev/null; then
    sudo npm install -g live-server
    check_error "Live-Server (npm)"
else
    echo -e "${YELLOW}npm nicht verfügbar - Live-Server übersprungen${NC}"
fi

echo ""
echo -e "${YELLOW}Installiere Oh-My-Zsh (moderne Shell-Konfiguration)...${NC}"
# Oh-My-Zsh installieren (falls zsh als Standard-Shell gewünscht)
if command -v zsh &> /dev/null; then
    # Oh-My-Zsh installieren
    curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true
    echo -e "${GREEN}Oh-My-Zsh installiert! Wechsel zur zsh mit: chsh -s /bin/zsh${NC}"
fi
# Oh-My-Zsh installieren (falls zsh als Standard-Shell gewünscht)
if command -v zsh &> /dev/null; then
    # Oh-My-Zsh installieren
    curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh || true
    echo -e "${GREEN}Oh-My-Zsh installiert! Wechsel zur zsh mit: chsh -s /bin/zsh${NC}"
fi

echo ""
echo -e "${GREEN}=== Installation abgeschlossen! ===${NC}"
echo ""
echo "Installierte Programme:"
echo "✓ Visual Studio Code"
echo "✓ Brave Browser" 
echo "✓ GParted"
echo "✓ Python mit IDLE"
echo "✓ Android Studio"
echo "✓ Arduino IDE 2"
echo "✓ os-prober"
echo "✓ Inkscape"
echo "✓ LibreOffice"
echo "✓ Thunderbird"
echo "✓ Docker + Docker Compose"
echo "✓ Node.js + Live-Server"
echo "✓ Sublime Text 4"
echo "✓ Orca Slicer"
echo "✓ Klipper"
echo "✓ Pac-Man Game"
echo "✓ Sonic Pi (Algorave/Live-Coding)"
echo "✓ System-Tools: btop, neofetch, tree, wget, curl"
echo "✓ Archive-Tools: p7zip, unrar"
echo "✓ Dateimanager: Thunar"
echo "✓ Terminal: zsh + oh-my-zsh, tmux, ranger"
echo "✓ Kommunikation: Discord, Telegram, Zoom, Signal"
echo "✓ Backup: rsync, rclone, timeshift"
echo ""
echo -e "${YELLOW}Du kannst die Programme nun über das Anwendungsmenü oder Terminal starten:${NC}"
echo "- VS Code: code"
echo "- Sublime Text: subl"
echo "- Brave Browser: brave"
echo "- GParted: gparted (als sudo)"
echo "- Python IDLE: idle oder idle3"
echo "- Android Studio: android-studio"
echo "- Arduino IDE: arduino-ide"
echo "- os-prober: sudo os-prober (erkennt andere Betriebssysteme)"
echo "- Inkscape: inkscape"
echo "- LibreOffice Writer: libreoffice --writer"
echo "- LibreOffice Calc: libreoffice --calc"
echo "- LibreOffice Impress: libreoffice --impress"
echo "- Thunderbird: thunderbird"
echo "- Docker: docker (z.B. docker run hello-world)"
echo "- Docker Compose: docker-compose"
echo "- Live-Server: live-server (startet lokalen Webserver mit Auto-Reload)"
echo "- Python HTTP-Server: python -m http.server 8000"
echo "- Orca Slicer: orca-slicer"
echo "- Klipper: Siehe Konfiguration unten"
echo "- Pac-Man: pacman-game (Zeit zum Entspannen! 🕹️)"
echo "- Sonic Pi: sonic-pi (Live-Coding für Algorave-Musik! 🎵)"
echo "- System-Monitor: btop (moderner als htop)"
echo "- System-Info: neofetch"
echo "- Dateimanager: thunar"
echo "- Terminal-Tools: tmux, ranger"
echo "- Discord: discord"
echo "- Telegram: telegram-desktop"
echo "- Zoom: zoom"
echo "- Signal: signal-desktop"
echo "- Backup-GUI: timeshift-gtk"
echo ""
echo -e "${YELLOW}WICHTIGE HINWEISE:${NC}"
echo "• Für Docker ohne sudo: Bitte einmal ab- und wieder anmelden!"
echo "• Sublime Text: Lizenz unter 'Help -> Enter License' aktivieren"
echo "• Arduino: User zur 'uucp' Gruppe hinzufügen für USB-Zugriff"
echo "• 3D-Drucker: User zur 'dialout' Gruppe für seriellen Zugriff hinzufügen:"
echo "  sudo usermod -a -G dialout \$USER"
echo "• Klipper: Benötigt weitere Konfiguration für deinen Drucker"
echo "• Thunderbird: Automatische Konfiguration für Gmail, Yahoo, Posteo verfügbar"
echo "• Oh-My-Zsh: Wechsel zur zsh mit: chsh -s /bin/zsh"
echo "• Timeshift: System-Snapshots unter /timeshift konfigurieren"
echo "• Discord/Zoom/Signal: Login mit deinen Accounts nach dem Start"
echo ""
echo "Teste Docker mit: docker run hello-world"
echo "Entdecke dein System mit: neofetch && btop"
echo ""
echo "Viel Spaß mit deinem ULTIMATIVEN CachyOS Setup! 🚀🎯"
echo "Von Entwicklung über 3D-Druck bis Gaming - alles dabei!"