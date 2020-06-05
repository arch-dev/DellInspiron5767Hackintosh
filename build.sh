#!/bin/bash

# Created by arch-dev on 02/06/2020
# Copyright © 2020 ArchSoftware Inc. All rights reserved.

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

function download()
{
 DIR=$1
 FILE=$2
 while IFS= read -r line; do
  link=$(echo $line | cut -d ',' -f 1)
  name=$(echo $line | cut -d ',' -f 2)
  version=$(curl -s $link/latest | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')
  echo Downloading $name version: $version...
  if [[ $(echo $link | cut -d '/' -f 4) == "acidanthera" && $(echo $link | cut -d '/' -f 6) == "releases" ]]; then
   curl -L $link/download/$version/$name-$version-RELEASE.zip > $DIR/$name.zip &
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
mkdir -p $OUTDIR/EFI/{BOOT,OC/{ACPI,Bootstrap,Drivers,Kexts,Resources/{Audio,Font,Image,Label},Tools}}
check "curl"
echo Downloading necessary files...
mkdir $TEMP
download $TEMP "Dependencies/packages.txt"
mkdir $TOOLS
download $TOOLS "Dependencies/tools.txt"
for file in $ACPI/*
do
 $TOOLS/MaciASL/MaciASL-master/Dist/iasl-stable $file
done
echo Copying files to EFI...
find . -name \*.kext -exec cp {} $OUTDIR/EFI/OC/Kexts \;
while IFS= read -r line; do
 cp $TEMP/$(echo $line | cut -d ',' -f 1) $OUTDIR/$(echo $line | cut -d ',' -f 2)
done <"Dependencies/efi.txt"
cp $TEMP/OcBinaryData/OcBinaryData-master/Resources/Audio/OCEFIAudio_VoiceOver_Boot.wav $OUTDIR/EFI/OC/Resources/
cp $TEMP/OcBinaryData/OcBinaryData-master/Resources/Font/ $OUTDIR/EFI/OC/Resources/
cp $TEMP/OcBinaryData/OcBinaryData-master/Resources/Image/ $OUTDIR/EFI/OC/Resources/
cp $TEMP/OcBinaryData/OcBinaryData-master/Resources/Label/ $OUTDIR/EFI/OC/Resources/
mv $ACPI/*.aml $OUTDIR/EFI/OC/ACPI/
cp config.plist $OUTDIR/EFI/OC/
clean
