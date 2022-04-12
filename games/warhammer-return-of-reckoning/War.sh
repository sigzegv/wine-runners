#!/bin/bash

set -a
SELF_PATH=$(dirname $(realpath ${0}))
WINEPREFIX="$HOME/.local/.wineprefixes/war-ror"
WINEPATH="$SELF_PATH/lutris-ge-6.21-1-x86_64"
PATH="$WINEPATH/bin:$PATH"

WINEDEBUG=-all
VKD3D_DEBUG=none
DXVK_LOG_LEVEL=none

WINE_LARGE_ADDRESS_AWARE=1
WINEDLLOVERRIDES="winemenubuilder.exe=d"
#WINEESYNC=1

#DXVK_ASYNC=1
DXVK_STATE_CACHE=1
DXVK_STATE_CACHE_PATH=$WINEPREFIX/.shadercache
__GL_SHADER_DISK_CACHE=1
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
__GL_SHADER_DISK_CACHE_PATH=$DXVK_STATE_CACHE_PATH

#WINEDLLPATH="$WINEPATH/lib64/wine:$WINEPATH/lib/wine"
#LD_LIBRARY_PATH="$WINEPATH/lib:$WINEPATH/lib64:$LD_LIBRARY_PATH"
#GST_PLUGIN_SYSTEM_PATH_1_0="$WINEPATH/lib64/gstreamer-1.0/:$WINEPATH/lib/gstreamer-1.0/" #hack on MF media display issues

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return # exit if sourced
# allows to source this env on your term without executing any app

USER=wineuser

[ -z "$WINEPREFIX" ] && echo "Missing wine prefix envvar WINEPREFIX" && exit 1
[ -z "$WINEPATH" ] && echo "Missing wine runner envvar WINEPATH" && exit 1
[ ! -d "$WINEPATH" ] && echo "Missing wine runner at $WINEPATH" && exit 1
which winetricks > /dev/null || (echo "Missing winetricks in PATH"; exit 1)

[ -d "$WINEPREFIX" ] || wineboot -u
[ -s "$WINEPREFIX/dosdevices/x:" ] || ln -sf "$SELF_PATH" "$WINEPREFIX/dosdevices/x:"
[ -s "$WINEPREFIX/dosdevices/z:" ] && rm -fr "$WINEPREFIX/dosdevices/z:"
[ -d "$DXVK_STATE_CACHE_PATH" ] || mkdir -p "$DXVK_STATE_CACHE_PATH"

deps=$(winetricks list-installed)
echo $deps | grep sandbox > /dev/null || winetricks -q sandbox
echo $deps | grep nocrashdialog > /dev/null || winetricks -q nocrashdialog
echo $deps | grep dotnet40 > /dev/null || winetricks --force -q dotnet40
echo $deps | grep dxvk > /dev/null || winetricks -q dxvk
echo $deps | grep win10 > /dev/null || winetricks -q win10

rorkey="HKEY_CURRENT_USER\Software\Wine\AppDefaults\WAR-64.exe\DllOverrides"
wine reg query "$rorkey" | grep -o d3d9 > /dev/null

if [ $? == 1 ]; then
    # add override for WAR-64.exe
    wine reg add "$rorkey" /v "d3d9" /t REG_SZ /d "native" /f
    # then remove global override
    wine reg delete "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v "*d3d9" /f
fi

wine RoRLauncher.exe
