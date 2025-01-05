#!/bin/sh

# FreeBSD Installation Script
# Version: 1.0
# Description: This script automates the installation of FreeBSD with support for full disk encryption,
#              RAID configurations (RAID 0, RAID 1, RAID-Z, RAID 10, JBOD), and SSH key-based decryption.
#              It is designed to be user-friendly and supports multiple languages (English, German, Russian).
#
# License: 2-Clause BSD License
#
# Copyright (c) 2025
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Disclaimer: This script is provided "as is" without any guarantees or warranty. 
# The author disclaims all liability for any damages, direct or indirect, that may result 
# from the use of this script. Use at your own risk. Always test in a safe environment 
# before deploying in production.

# Variables / Variablen / Переменные
DISKS=($(sysctl -n kern.disks))  # All available disks / Alle verfügbaren Festplatten / Все доступные диски
NUM_DISKS=${#DISKS[@]}
GELI_KEYFILE="/root/geli.key"
SSH_KEYFILE="/root/id_ed25519"
INITRAMFS_DIR="/boot/initramfs"
INITRAMFS_IMAGE="/boot/initramfs.cpio.gz"
LOG_FILE="/var/log/freebsd_install.log"

# Language selection / Sprachauswahl / Выбор языка
echo "Please select your language / Bitte wählen Sie Ihre Sprache / Пожалуйста, выберите ваш язык:"
echo "1. English"
echo "2. Deutsch"
echo "3. Русский"
read -p "Enter your choice (1-3): " lang_choice

case $lang_choice in
    1)
        # English
        msg_die="Error: "
        msg_log="Log: "
        msg_yes_no="Please enter y/n: "
        msg_ssh_key_gen="Generating new SSH key..."
        msg_ssh_key_exists="SSH key already exists: "
        msg_disk_setup="Available disks: "
        msg_raid1="Configuring RAID 1 (Mirroring)..."
        msg_raid0="Configuring RAID 0 (Striping)..."
        msg_raidz="Configuring RAID-Z..."
        msg_raid10="Configuring RAID 10 (Mirroring + Striping)..."
        msg_jbod="Configuring JBOD (Separate partitions)..."
        msg_encryption="Do you want to encrypt the disk(s)? (y/n): "
        msg_ssh_key_use="Do you want to use an SSH key for decryption? (y/n): "
        msg_password_use="Do you want to use a password for decryption? (y/n): "
        msg_install_freebsd="Installing FreeBSD..."
        msg_initramfs="Creating initramfs..."
        msg_bootloader="Configuring bootloader..."
        msg_complete="Installation complete. Rebooting the server..."
        msg_keymap="Setting keyboard layout..."
        msg_timezone="Setting timezone..."
        msg_hostname="Enter the hostname: "
        msg_network="Configuring network..."
        msg_root_pass="Set root password:"
        msg_user_create="Do you want to create a user? (y/n): "
        msg_user_name="Enter the username: "
        msg_user_pass="Set password for user: "
        msg_intro1="=== FreeBSD Installation Script ==="
        msg_intro2="This script sets up FreeBSD with full disk encryption."
        msg_intro3="It supports RAID 1, RAID 0, RAID-Z, RAID 10, and JBOD."
        msg_keymap_prompt="Enter the keymap (e.g., us, de, ru): "
        msg_timezone_prompt="Enter the timezone (e.g., Europe/Berlin, America/New_York): "
        ;;
    2)
        # Deutsch
        msg_die="Fehler: "
        msg_log="Protokoll: "
        msg_yes_no="Bitte geben Sie j/n ein: "
        msg_ssh_key_gen="Generiere neuen SSH-Schlüssel..."
        msg_ssh_key_exists="SSH-Schlüssel bereits vorhanden: "
        msg_disk_setup="Verfügbare Festplatten: "
        msg_raid1="Konfiguriere RAID 1 (Spiegeln)..."
        msg_raid0="Konfiguriere RAID 0 (Striping)..."
        msg_raidz="Konfiguriere RAID-Z..."
        msg_raid10="Konfiguriere RAID 10 (Spiegeln + Striping)..."
        msg_jbod="Konfiguriere JBOD (Separate Partitionen)..."
        msg_encryption="Möchtest du die Festplatte(n) verschlüsseln? (j/n): "
        msg_ssh_key_use="Möchtest du einen SSH-Key für die Entschlüsselung verwenden? (j/n): "
        msg_password_use="Möchtest du ein Passwort für die Entschlüsselung verwenden? (j/n): "
        msg_install_freebsd="Installiere FreeBSD..."
        msg_initramfs="Erstelle das initramfs..."
        msg_bootloader="Konfiguriere den Bootloader..."
        msg_complete="Installation abgeschlossen. Starte den Server neu..."
        msg_keymap="Setze Tastaturlayout..."
        msg_timezone="Setze Zeitzone..."
        msg_hostname="Gib den Hostname ein: "
        msg_network="Konfiguriere Netzwerk..."
        msg_root_pass="Root-Passwort setzen:"
        msg_user_create="Möchtest du einen Benutzer erstellen? (j/n): "
        msg_user_name="Gib den Benutzernamen ein: "
        msg_user_pass="Passwort für Benutzer setzen: "
        msg_intro1="=== FreeBSD Installationsskript ==="
        msg_intro2="Dieses Skript richtet FreeBSD mit vollständiger Festplattenverschlüsselung ein."
        msg_intro3="Es unterstützt RAID 1, RAID 0, RAID-Z, RAID 10 und JBOD."
        msg_keymap_prompt="Geben Sie das Tastaturlayout ein (z.B. us, de, ru): "
        msg_timezone_prompt="Geben Sie die Zeitzone ein (z.B. Europe/Berlin, America/New_York): "
        ;;
    3)
        # Русский
        msg_die="Ошибка: "
        msg_log="Лог: "
        msg_yes_no="Пожалуйста, введите y/n: "
        msg_ssh_key_gen="Генерация нового SSH-ключа..."
        msg_ssh_key_exists="SSH-ключ уже существует: "
        msg_disk_setup="Доступные диски: "
        msg_raid1="Настройка RAID 1 (Зеркалирование)..."
        msg_raid0="Настройка RAID 0 (Чередование)..."
        msg_raidz="Настройка RAID-Z..."
        msg_raid10="Настройка RAID 10 (Зеркалирование + Чередование)..."
        msg_jbod="Настройка JBOD (Отдельные разделы)..."
        msg_encryption="Хотите зашифровать диск(и)? (y/n): "
        msg_ssh_key_use="Хотите использовать SSH-ключ для расшифровки? (y/n): "
        msg_password_use="Хотите использовать пароль для расшифровки? (y/n): "
        msg_install_freebsd="Установка FreeBSD..."
        msg_initramfs="Создание initramfs..."
        msg_bootloader="Настройка загрузчика..."
        msg_complete="Установка завершена. Перезагрузка сервера..."
        msg_keymap="Установка раскладки клавиатуры..."
        msg_timezone="Установка временной зоны..."
        msg_hostname="Введите имя хоста: "
        msg_network="Настройка сети..."
        msg_root_pass="Установка пароля root:"
        msg_user_create="Хотите создать пользователя? (y/n): "
        msg_user_name="Введите имя пользователя: "
        msg_user_pass="Установка пароля для пользователя: "
        msg_intro1="=== Скрипт установки FreeBSD ==="
        msg_intro2="Этот скрипт настраивает FreeBSD с полным шифрованием диска."
        msg_intro3="Он поддерживает RAID 1, RAID 0, RAID-Z, RAID 10 и JBOD."
        msg_keymap_prompt="Введите раскладку клавиатуры (например, us, de, ru): "
        msg_timezone_prompt="Введите временную зону (например, Europe/Berlin, America/New_York): "
        ;;
    *)
        die "Invalid language choice. Exiting."
        ;;
esac

# Functions / Funktionen / Функции
die() {
    echo "${msg_die}$1" | tee -a $LOG_FILE
    exit 1
}

log() {
    echo "${msg_log}$1" | tee -a $LOG_FILE
}

ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "${msg_yes_no}" ;;
        esac
    done
}

check_commands() {
    for cmd in gpart geli zpool ssh-keygen ifconfig route; do
        if ! command -v $cmd >/dev/null 2>&1; then
            die "Command '$cmd' not found. Please install the necessary tools."
        fi
    done
}

generate_ssh_key() {
    if [ ! -f $SSH_KEYFILE ]; then
        log "${msg_ssh_key_gen}"
        ssh-keygen -t ed25519 -f $SSH_KEYFILE -N "" || die "SSH key generation failed."
    else
        log "${msg_ssh_key_exists}$SSH_KEYFILE"
    fi
    cp ${SSH_KEYFILE}.pub $GELI_KEYFILE || die "Failed to copy SSH key."
}

setup_disks() {
    log "${msg_disk_setup}${DISKS[@]}"
    echo "1. RAID 1 (Mirroring) / RAID 1 (Spiegeln) / RAID 1 (Зеркалирование)"
    echo "2. RAID 0 (Striping) / RAID 0 (Striping) / RAID 0 (Чередование)"
    echo "3. RAID-Z"
    echo "4. RAID 10 (Mirroring + Striping) / RAID 10 (Spiegeln + Striping) / RAID 10 (Зеркалирование + Чередование)"
    echo "5. JBOD (Just a Bunch of Disks) / JBOD (Separate Partitionen) / JBOD (Отдельные разделы)"
    read -p "Enter your choice (1-5): " disk_option

    case $disk_option in
        1)
            log "${msg_raid1}"
            if [ $NUM_DISKS -lt 2 ]; then
                die "RAID 1 requires at least 2 disks."
            fi
            gmirror label -v -b round-robin root ${DISKS[@]} || die "Mirroring failed."
            TARGET_DISK="/dev/mirror/root"
            ;;
        2)
            log "${msg_raid0}"
            if [ $NUM_DISKS -lt 2 ]; then
                die "RAID 0 requires at least 2 disks."
            fi
            gstripe label -v stripe ${DISKS[@]} || die "Striping failed."
            TARGET_DISK="/dev/stripe/stripe"
            ;;
        3)
            log "${msg_raidz}"
            if [ $NUM_DISKS -lt 3 ]; then
                die "RAID-Z requires at least 3 disks."
            fi
            read -p "Choose RAID-Z level (1, 2, or 3): " raidz_level
            case $raidz_level in
                1) raidz_type="raidz1" ;;
                2) raidz_type="raidz2" ;;
                3) raidz_type="raidz3" ;;
                *) die "Invalid RAID-Z level." ;;
            esac
            zpool create -f -o ashift=12 zroot $raidz_type ${DISKS[@]} || die "Failed to create ZFS pool."
            TARGET_DISK="zroot"
            ;;
        4)
            log "${msg_raid10}"
            if [ $NUM_DISKS -lt 4 ] || [ $((NUM_DISKS % 2)) -ne 0 ]; then
                die "RAID 10 requires an even number of disks (minimum 4)."
            fi
            for i in $(seq 0 2 $((NUM_DISKS - 1))); do
                gmirror label -v -b round-robin mirror$i ${DISKS[$i]} ${DISKS[$((i + 1))]} || die "Mirroring failed."
            done
            gstripe label -v stripe /dev/mirror/* || die "Striping failed."
            TARGET_DISK="/dev/stripe/stripe"
            ;;
        5)
            log "${msg_jbod}"
            for disk in ${DISKS[@]}; do
                gpart create -s gpt $disk || die "Partitioning failed."
                gpart add -t freebsd-ufs -l ${disk##*/} $disk || die "Failed to create partition."
            done
            TARGET_DISK="/dev/${DISKS[0]}"
            ;;
        *)
            die "Invalid option."
            ;;
    esac
}

setup_encryption() {
    if ask_yes_no "${msg_encryption}"; then
        geli init -l 256 -s 4096 $TARGET_DISK || die "Failed to initialize encryption."

        if ask_yes_no "${msg_ssh_key_use}"; then
            generate_ssh_key
            geli setkey -k $GELI_KEYFILE $TARGET_DISK || die "Failed to set SSH key."
        fi

        if ask_yes_no "${msg_password_use}"; then
            geli attach -p $TARGET_DISK || die "Failed to set password."
        fi

        TARGET_DISK="${TARGET_DISK}.eli"
    fi
}

install_freebsd() {
    log "${msg_install_freebsd}"
    bsdinstall scripted || die "Installation failed."
}

setup_initramfs() {
    log "${msg_initramfs}"
    mkdir -p $INITRAMFS_DIR || die "Failed to create initramfs directory."
    cp -r /boot/kernel $INITRAMFS_DIR/
    cp -r /boot/zfs $INITRAMFS_DIR/
    cp -r /boot/geom_eli.ko $INITRAMFS_DIR/
    cp /bin/sh $INITRAMFS_DIR/
    cp /sbin/geli $INITRAMFS_DIR/
    cp /sbin/ifconfig $INITRAMFS_DIR/
    cp /usr/sbin/sshd $INITRAMFS_DIR/
    cp /etc/ssh/sshd_config $INITRAMFS_DIR/

    cat > $INITRAMFS_DIR/init.sh <<EOF
#!/bin/sh
# Configure network / Netzwerk konfigurieren / Настройка сети
ifconfig vtnet0 up
ifconfig vtnet0 inet $(hostname -I | awk '{print $1}') netmask 255.255.255.0
route add default $(ip route | grep default | awk '{print $3}')

# Start SSH service / SSH-Dienst starten / Запуск SSH-сервиса
mkdir -p /var/empty
/usr/sbin/sshd -f $INITRAMFS_DIR/sshd_config

# Decryption / Entschlüsselung / Расшифровка
if [ -f $GELI_KEYFILE ]; then
    echo "Trying to decrypt the disk with the SSH key..."
    geli attach -k $GELI_KEYFILE $TARGET_DISK
fi

if [ \$? -ne 0 ]; then
    echo "SSH key not available or failed. Please enter the password:"
    read -s password
    echo -n "\$password" | geli attach -j - $TARGET_DISK
fi

if [ \$? -eq 0 ]; then
    echo "Disk successfully decrypted."
    mount /dev/${TARGET_DISK} /mnt
    exit 0
else
    echo "Failed to decrypt the disk."
    exit 1
fi
EOF
    chmod +x $INITRAMFS_DIR/init.sh

    (cd $INITRAMFS_DIR && find . | cpio -o -H newc | gzip > $INITRAMFS_IMAGE) || die "Failed to create initramfs image."
}

setup_bootloader() {
    log "${msg_bootloader}"
    cat > /boot/loader.conf <<EOF
geom_eli_load="YES"
vfs.root.mountfrom="ufs:/dev/${TARGET_DISK}"
initrd_load="YES"
initrd_name="$INITRAMFS_IMAGE"
EOF
}

main() {
    echo "${msg_intro1}"
    echo "${msg_intro2}"
    echo "${msg_intro3}"
    echo "-----------------------------------"

    check_commands

    # Keyboard layout / Tastaturlayout / Раскладка клавиатуры
    log "${msg_keymap}"
    read -p "${msg_keymap_prompt}" keymap
    echo "keymap=\"$keymap\"" >> /etc/rc.conf

    # Timezone / Zeitzone / Временная зона
    log "${msg_timezone}"
    read -p "${msg_timezone_prompt}" timezone
    tzsetup $timezone

    # Hostname
    read -p "${msg_hostname}" hostname
    echo "hostname=\"$hostname\"" >> /etc/rc.conf

    # Network configuration / Netzwerkkonfiguration / Настройка сети
    log "${msg_network}"
    echo "ifconfig_vtnet0=\"DHCP\"" >> /etc/rc.conf
    echo "ifconfig_vtnet0_ipv6=\"inet6 accept_rtadv\"" >> /etc/rc.conf

    # Root password / Root-Passwort / Пароль root
    log "${msg_root_pass}"
    passwd root

    # Create user / Benutzer erstellen / Создание пользователя
    if ask_yes_no "${msg_user_create}"; then
        read -p "${msg_user_name}" username
        pw useradd -n $username -m -s /bin/sh
        log "${msg_user_pass}$username"
        passwd $username
    fi

    # Disk setup / Festplattenkonfiguration / Настройка дисков
    setup_disks
    setup_encryption

    # Install FreeBSD / FreeBSD installieren / Установка FreeBSD
    install_freebsd

    # Initramfs setup / Initramfs erstellen / Создание initramfs
    setup_initramfs

    # Bootloader setup / Bootloader konfigurieren / Настройка загрузчика
    setup_bootloader

    log "${msg_complete}"
    reboot
}

# Run the script / Skript ausführen / Запуск скрипта
main