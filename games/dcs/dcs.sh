#!/bin/bash

set -a
SELF_PATH=$(dirname $(realpath ${0}))
WINEPREFIX="$HOME/.local/.wineprefixes/dcs"
WINEPATH="$HOME/.local/share/wine-ge"
PATH="$WINEPATH/bin:$PATH"

WINEDEBUG=-all
DXVK_LOG_LEVEL=none

WINEDLLOVERRIDES="winemenubuilder.exe=d;d3d11=n;d3d10=n;d3d10core=n;d3d10_1=n;d3d9=n;dxgi=n;webmprox=n;msdmo=n"
WINEESYNC=1
DXVK_STATE_CACHE=1
DXVK_STATE_CACHE_PATH=$WINEPREFIX/.shadercache
__GL_SHADER_DISK_CACHE=1
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
__GL_SHADER_DISK_CACHE_PATH=$DXVK_STATE_CACHE_PATH

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return # exit if sourced
# allows to source this env on your term without executing any app
USER=carlos

[ -z "$WINEPREFIX" ] && echo "Missing wine prefix envvar WINEPREFIX" && exit 1
[ -z "$WINEPATH" ] && echo "Missing wine runner envvar WINEPATH" && exit 1
[ ! -d "$WINEPATH" ] && echo "Missing wine runner at $WINEPATH" && exit 1

[ -d "$WINEPREFIX" ] || wineboot -u
[ -s "$WINEPREFIX/dosdevices/x:" ] || ln -sf "$SELF_PATH" "$WINEPREFIX/dosdevices/x:"
[ -s "$WINEPREFIX/dosdevices/z:" ] && rm -fr "$WINEPREFIX/dosdevices/z:"
[ -d "$DXVK_STATE_CACHE_PATH" ] || mkdir -p "$DXVK_STATE_CACHE_PATH"

deps=$(winetricks list-installed)

echo $deps | grep sandbox > /dev/null || winetricks -q sandbox
echo $deps | grep nocrashdialog > /dev/null || winetricks -q nocrashdialog
echo $deps | grep vcrun2019 > /dev/null || winetricks -q vcrun2019
echo $deps | grep corefonts > /dev/null || winetricks -q corefonts
echo $deps | grep xact > /dev/null || winetricks -q xact
echo $deps | grep d3dcompiler_43 > /dev/null || winetricks -q d3dcompiler_43
echo $deps | grep dxvk > /dev/null || winetricks -q dxvk
echo $deps | grep win10 > /dev/null || winetricks -q win10

wine bin/DCS_updater.exe $@
sleep 1
pid=$(pidof -s "DCS_updater.exe")
[[ ! -z "$pid" ]] && tail --pid=$pid -f /dev/null

echo "Starting DCS..."
pid=$(pidof -s "DCS.exe")
[[ ! -z "$pid" ]] && tail --pid=$pid -f /dev/null
killall TrackIR.exe
