#!/bin/sh

#set -e
set -x

ConnectUSB="/System/Library/Extensions/ConnectUSB.kext"
Pvsnet="/System/Library/Extensions/Pvsnet.kext"
hypervisor="/System/Library/Extensions/hypervisor.kext"
vmmain="/System/Library/Extensions/vmmain.kext"
StartParallelsTransporter="/Library/StartupItems/ParallelsTransporter"
StartParallels="/Library/StartupItems/Parallels"
LibParallels="/Library/Parallels"
AppParallels="/Applications/Parallels"

declare -a DISKS
RAM_DISK=

if [ "$1" ]
then
    HANGER="$1"
else
    HANGERapp="$AppParallels/Parallels Desktop.app"
    HANGERdoc="$HOME/Documents/Parallels/XP/XP.pvs"
fi

function mountRAMDisk ()
{
    MOUNT_POINT="$1"

    RAM_DISK="$(hdid -nomount ram://52428800 | awk '{print $1}')"
    newfs_hfs "$RAM_DISK" || return 1
    sudo mkdir -m 555 "$MOUNT_POINT" || chmod 555 "$MOUNT_POINT"
    sudo mount -t hfs -o nobrowse "$RAM_DISK" "$MOUNT_POINT" || return 1
}

function mountTheBits ()
{
    for i in $(hdiutil attach -nomount -nobrowse ~/Documents/ParallelsQuarantine.dmg | awk '/disk/ {print $1}')
    do
        DISKS[${#DISKS[@]}]="$i" # /dev/disk1si
    done

    mountRAMDisk "$LibParallels" || return 1
    pushd $LibParallels 2>&1 >/dev/null || return 1

    sudo mkdir -m 555 ConnectUSB.kext || return 1
    sudo mkdir -m 555 Pvsnet.kext || return 1
    sudo mkdir -m 555 hypervisor.kext || return 1
    sudo mkdir -m 555 vmmain.kext || return 1
    sudo mkdir -m 555 StartParallelsTransporter || return 1
    sudo mkdir -m 555 StartParallels || return 1
    sudo mkdir -m 555 "$AppParallels" || chmod 555 "$AppParallels"

    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[2]} ConnectUSB.kext || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[3]} Pvsnet.kext || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[4]} hypervisor.kext || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[5]} vmmain.kext || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[6]} StartParallelsTransporter || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[7]} StartParallels || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[8]} $LibParallels || return 1
    sudo mount -v -o union,nobrowse -r -t hfs ${DISKS[9]} $AppParallels || return 1

    if [ ! -e $ConnectUSB ]
    then
        sudo ln -fs "$LibParallels/ConnectUSB.kext" $ConnectUSB || return 1
    fi
    if [ ! -e $Pvsnet ]
    then
        sudo ln -fs "$LibParallels/Pvsnet.kext" $Pvsnet || return 1
    fi
    if [ ! -e $hypervisor ]
    then
        sudo ln -fs "$LibParallels/hypervisor.kext" $hypervisor || return 1
    fi
    if [ ! -e $vmmain ]
    then
        sudo ln -fs "$LibParallels/vmmain.kext" $vmmain || return 1
    fi
    if [ ! -e $StartParallelsTransporter ]
    then
        sudo ln -fs "$LibParallels/StartParallelsTransporter" $StartParallelsTransporter || return 1
    fi
    if [ ! -e $StartParallels ]
    then
        sudo ln -fs "$LibParallels/StartParallels" $StartParallels || return 1
    fi

    popd 2>&1 >/dev/null || return 1
}

function loadTheBits ()
{
    sudo /Library/StartupItems/Parallels/Parallels start || return 1
    sudo /Library/StartupItems/ParallelsTransporter/ParallelsTransporter start || return 1
}

function hangOut ()
{
    if [ "$HANGER" ]
    then
        echo "Running $HANGER"
        open -W -a "$HANGER" || echo "Hang failed..."
    else
        echo "Running $HANGERapp/$HANGERdoc"
        open -W -a "$HANGERapp" "$HANGERdoc" || echo "Hang failed..."
    fi
}

function unloadTheBits ()
{
    #exec sleep 1
    sudo /Library/StartupItems/ParallelsTransporter/ParallelsTransporter stop
    sudo /Library/StartupItems/Parallels/Parallels stop
}

function unmountRAMDisk ()
{
    hdiutil detach $RAM_DISK || hdiutil eject $LibParallels
}

function unmountTheBits ()
{
    #exec sleep 1
    hdiutil eject ${DISKS[0]} || hdiutil eject $libParallels
    
    sudo rmdir $AppParallels

    unmountRAMDisk
    
    sudo rm -rf $LibParallels
}


mountTheBits && (loadTheBits && hangOut; unloadTheBits); unmountTheBits
