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
- Root access
- Basic knowledge of FreeBSD and RAID configurations

---

## Optional: FreeBSD Installation on Hetzner

If you are installing FreeBSD on **Hetzner** servers, you might find the following repository useful:

### [Install FreeBSD on Hetzner](https://github.com/satriani-vai/Install_FreeBSD_on_Hetzner)

This repository provides:
- Step-by-step instructions for installing FreeBSD on Hetzner hardware.
- Guidance on configuring network settings, RAID, and other system-specific options.
- Useful scripts and commands tailored for Hetzner servers.

While this script is designed for general FreeBSD installations, the Hetzner-specific guide can be a helpful resource for users working with Hetzner hardware.

## Usage
1. Download the script:
   ```bash
   fetch https://raw.githubusercontent.com/satriani-vai/freebsd-install-script/main/freebsd_install.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x freebsd_install.sh
   ```
3. Run the script as root:
   ```bash
   sudo ./freebsd_install.sh
   ```