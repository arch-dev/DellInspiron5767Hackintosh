#!/bin/bash

# Created by arch-dev on 02/06/2020
# Updated by arch-dev on 23/04/2022
# Copyright © 2022 ArchSoftware Inc. All rights reserved.

TOOLS="Tools"
OUTDIR="Out"
TEMP="Temp"
ACPI="ACPI"

function check()
{
 CMD=$1
 if [[ ! $CMD > /dev/null ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
   sudo apt install curl
  elif [[ $OSTYPE == "darwin" ]]; then
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   brew install curl
  fi
 fi
}

function reset()
{
 rm -rf $OUTDIR
 rm -rf $TOOLS
}

function download()
{
 DIR=$1
 FILE=$2
 while IFS= read -r line; do
  link=$(echo $line | cut -d ',' -f 1)
  name=$(echo $line | cut -d ',' -f 2)
  version=$(curl -Ls -o /dev/null -w %{url_effective} $link/latest | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')
  echo Downloading $name version: $version...
  if [[ $(echo $link | cut -d '/' -f 4) == "acidanthera" && $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name-$version-RELEASE.zip > $DIR/$name.zip &
  elif [[ $(echo $link | cut -d '/' -f 5) == "itlwm" && $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name\_$version\_stable_Monterey.kext.zip > $DIR/$name.zip &
  elif [[ $(echo $link | cut -d '/' -f 5) == "IntelBluetoothFirmware" && $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name-$version.zip > $DIR/$name.zip &
  elif [[ $(echo $link | cut -d '/' -f 4) == "0xFireWolf" && $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name\_${version:1:5}\_b998818_RELEASE.zip > $DIR/$name.zip &
  elif [[ $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name-$version.zip > $DIR/$name.zip &
  elif [[ $(echo $link | cut -d '/' -f 6) == "archive" ]]; then
   curl -L $link/master.zip > $DIR/$name.zip &
  fi
  until [[ -z `jobs|grep -E -v 'Done|Terminated'` ]]; do
   sleep 0.05; echo -n '.'
  done
  echo Extracting $name...
  unzip -o $DIR/$name.zip -d $DIR/$name
  until [[ -z `jobs|grep -E -v 'Done|Terminated'` ]]; do
   sleep 0.05; echo -n '.'
  done
 done <$FILE
}

function clean()
{
 echo Cleaning up...
 rm -rf $TEMP
}

cd "$(dirname "$0")"
reset
mkdir -p $OUTDIR/EFI/{BOOT,OC/{ACPI,Drivers,Kexts,Resources/{Audio,Font,Image,Label},Tools}}
check "curl"
echo Downloading necessary files...
mkdir $TEMP
download $TEMP "Dependencies/packages.txt"
mkdir $TOOLS
download $TOOLS "Dependencies/tools.txt"
echo Copying files to EFI...
find $TEMP -name \*.kext -exec cp -R {} $OUTDIR/EFI/OC/Kexts \;
rm -rf $OUTDIR/EFI/OC/Kexts/AppleALCU.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmBluetoothInjector.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmBluetoothInjectorLegacy.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmFirmwareData.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmFirmwareRepo.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmNonPatchRAM.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmNonPatchRAM2.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmPatchRAM.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmPatchRAM2.kext
rm -rf $OUTDIR/EFI/OC/Kexts/BrcmPatchRAM3.kext
rm -rf $OUTDIR/EFI/OC/Kexts/IntelBluetoothInjector.kext
rm -rf $OUTDIR/EFI/OC/Kexts/SMCLightSensor.kext
rm -rf $OUTDIR/EFI/OC/Kexts/SMCProcessor.kext
rm -rf $OUTDIR/EFI/OC/Kexts/SMCSuperIO.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooInput.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooGPIO.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooI2CServices.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooI2CAtmelMXT.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooI2CELAN.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooI2CFTE.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooI2CSynaptics.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooPS2Keyboard.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooPS2Mouse.kext
rm -rf $OUTDIR/EFI/OC/Kexts/VoodooPS2Trackpad.kext
cp -R Prebuilt/*.kext $OUTDIR/EFI/OC/Kexts
while IFS= read -r line; do
 cp $TEMP/$(echo $line | cut -d ',' -f 1) $OUTDIR/$(echo $line | cut -d ',' -f 2)
done <"Dependencies/efi.txt"
cp $TEMP/OcBinaryData/OcBinaryData-master/Resources/Audio/OCEFIAudio_VoiceOver_Boot.mp3 $OUTDIR/EFI/OC/Resources/Audio/
cp -R $TEMP/OcBinaryData/OcBinaryData-master/Resources/Font $OUTDIR/EFI/OC/Resources/
cp -R $TEMP/OcBinaryData/OcBinaryData-master/Resources/Image $OUTDIR/EFI/OC/Resources/
cp -R $TEMP/OcBinaryData/OcBinaryData-master/Resources/Label $OUTDIR/EFI/OC/Resources/
cp $ACPI/*.aml $OUTDIR/EFI/OC/ACPI
cp config.plist $OUTDIR/EFI/OC
echo Completed!!
echo Run Audio/install.sh script once booted the first time and follow the instructions!!
clean
