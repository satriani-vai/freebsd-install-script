# FreeBSD Installation Script

![License](https://img.shields.io/badge/License-BSD%202--Clause-blue.svg)

This script automates the installation of FreeBSD with support for:
- Full disk encryption (GELI)
- RAID configurations (RAID 0, RAID 1, RAID-Z, RAID 10, JBOD)
- SSH key-based decryption
- Multiple languages (English, German, Russian)

## Features
- **Easy-to-use**: Interactive prompts guide you through the installation process.
- **Flexible RAID setup**: Choose from RAID 0, RAID 1, RAID-Z, RAID 10, or JBOD.
- **Encryption**: Encrypt your disks with GELI and use SSH keys or passwords for decryption.
- **Multi-language support**: The script is available in English, German, and Russian.

## Requirements
- A FreeBSD installation medium (USB, CD, etc.)
- Root access
- Basic knowledge of FreeBSD and RAID configurations

## Usage
1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/your-username/freebsd-install-script/main/freebsd_install.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x freebsd_install.sh
   ```
3. Run the script as root:
   ```bash
   sudo ./freebsd_install.sh
   ```