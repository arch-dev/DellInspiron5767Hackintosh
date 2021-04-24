# Dell Inspiron 5767 Hackintosh (OpenCore)
macOS on Dell Inspiron 5767 (i7-7500u)

![OpenCore Version](https://img.shields.io/badge/opencore-v0.6.8-blue)

![Screenshot 1](../master/Pictures/neofetch.png?raw=true)

## Disclaimer
***Always make a backup before start*.
I'm not responsible for bricked laptops, dead USB drives, thermonuclear war, or you getting fired because the Intel processor exploded (here I'm kidding you :stuck_out_tongue_winking_eye:).**

![OpenCore logo](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Logos/OpenCore_with_text_Small.png)

## Guide

### IMPORTANT NOTE
If you are upgrading from OpenCore v0.6.2 you **MUST replace the whole OC folder with the one generated from build script (adding missing files as per guide)** and **EFI/BOOT/BOOTX64.efi** file otherwise you will not able to boot again from MacOS. You **CANNOT just replace files or add/remove missing ones** since from v0.6.2 to v0.6.7 lot of things changed as well as lot of ACPI lines changed from previous Dell BIOS version to latest one.

### Requirements
1. Running on macOS, Windows or Linux (on Windows you can use WSL https://docs.microsoft.com/it-it/windows/wsl/install-win10)
2. [MaciASL](https://github.com/acidanthera/MaciASL/releases) for macOS; [acpidump](https://www.acpica.org/downloads) for Windows
3. Curl installed (if not just run the script and complete the installation process)
4. USB 2.0 flash drive 12 GB or more (if you have **USB 3.0 plug in into USB 2.0** port during booting phase)
5. Internet connection (obviously :stuck_out_tongue_winking_eye:)

### BIOS setup
1. Make sure your BIOS is up to date. If not install latest from Dell site
2. Reboot to BIOS Setup
3. Enable Boot from USB and Legacy boot
4. Disable Fast boot and Secure boot
5. Disable Intel VT-d
6. Make sure SATA mode is set to AHCI

### Bootable USB creation
Just follow official OpenCore guide here: [Creating the USB](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)
    
### EFI Installation
1. Clone this repository
2. Run build.sh from terminal (if using WSL on Windows first install *dos2unix* and run *dos2unix build.sh* to convert the script to unix format)
3. Open *Out/EFI/OC/config.plist* and follow [this guide](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/kaby-lake.html#platforminfo) to correctly fill *"PlatformInfo">"Generic"* empty fields (**Do not change *"SystemProductName"* value, just use the given one**)
4. Then copy entire *EFI* folder to your USB flash drive EFI partition you created previously. It should look like the following

![Screenshot 2](../master/Pictures/OC_screen.png?raw=true)

5. Now it's time to boot macOS installer from your USB drive

### macOS installation
1. On OpenCore boot screen select *"Install macOS from your_usb"*

2. Assuming your are dual booting with Windows once you have reached install screen choose *"macOS Reinstallation"*

3. Select target partition created before and follow the installer

### Post installation
1. Download [MountEFI](https://github.com/corpnewt/MountEFI) script and run it

2. Select HDD macOS partition to mount EFI

3. Open your USB drive and head to EFI folder

4. Copy *BOOT* and *OC* folders to HDD EFI partition (if you've previously installed CLOVER first make a backup, then delete *CLOVER* folder and *BOOT/BOOTx64.efi* or just replace it with OC's one)

5. Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html#checking-via-verifymsre2) to disable "CFG Lock" (Remember to disable *"AppleCpuPmCfgLock"* and *"AppleXcpmCfgLock"* under *"Kernel">"Quirks"* once done)
    
6. Open System Preferences and disable PowerNap and wake on ethernet under *"Energy Saving"*

7. Run script *Audio/ComboJack_Installer/install.sh* to fix 3.5mm jack output and reboot. When you will connect a dialog asking you to select what you connected should show up

8. Fix iServices following [these instructions](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html).

## Table of contents
### ACPI

| ACPI file | Description |
| --- | --- |
| DSDT | Even if it's discouraged its use, it avoids OpenCore renames which may break other OS boot |
| SSDT-DDGP | Disables AMD Radeon M445 |
| SSDT-EC-USBX | Adds missing EC controller and inject USB power properties |
| SSDT-EXT4 | Wakes our screen up on waking |
| SSDT-GPRW | Needed by DSDT |
| SSDT-PLUG | Injects plugin-type to fix Native Power Management |
| SSDT-PNLF | Injects backlight properties to fix backlight control |
| SSDT-SBUS-MCHC | Fixes Serial BUS for correct sensors management and adds missing MCHC device |

### Kexts

| Kext file | Description |
| --- | --- |
| AirportItlwm | Fixes WiFi |
| IntelBluetoothFirmware | Fixes Bluetooth |
| IntelBluetoothInjector | Support kext for IntelBluetoothFirmware |
| AppleALC | Fixes onboard audio |
| CPUFriend | Fixes CPU power management |
| CPUFriendDataProvider | CPU power/performance profile |
| Lilu | Fixes lot of things and make laptop boot |
| VirtualSMC | Fakes our laptop as MacBook making it boot |
| SMCBatteryManager | Fixes battery percentage |
| VoodooPS2Controller | Fixes keyboard |
| WhateverGreen | Fixes Intel HD Graphics |
| VoodooI2C | Fixes trackpad |
| VoodooI2CHID | VoodooI2C plugin for Precision Trackpad |
| HibernationFixup | Fixes hibernation process |
| RealtekRTL8100 | Fixes ethernet |
| USBMap | Fixes USB power/port limit |

## Troubleshooting
To get help just open a issue or best thing head over my thread
- https://www.tonymacx86.com/threads/guide-opencore-dell-inspiron-17-5767-i7-7500u.299242
or visit hackintosh sites on the web
- https://www.tonymacx86.com
- https://www.insanelymac.com
and others

## Where can I learn more?
- https://dortania.github.io
- https://www.tonymacx86.com
- https://www.insanelymac.com

## Thanks
- @Acidanthera team for this new and more macOS friendly bootloader
- @_bplank for the updated guide for Big Sur
- @dortania team for detailed guides
- @CorpNewt for his amazing scripts, ACPIs, plugins
- @VoodooI2C for make I2C trackpad's gestures possible
- @RehabMan for his crucial role in the hackintosh world. That will never be forgotten since most of the projects above are based on his work.
- @zxystd for his work on Intel Wi-Fi cards (no anyone else wanted to work on this in the past so he's doing something deemed by all impossible)
