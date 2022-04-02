#!/bin/bash

set -a
SELF_PATH=$(dirname $(realpath ${0}))
WINEPREFIX="$HOME/.local/.wineprefixes/cyberpunk2077"
WINEPATH="$HOME/.local/share/wine-ge"
PATH="$WINEPATH/bin:$PATH"

WINEDEBUG=-all
VKD3D_DEBUG=none
DXVK_LOG_LEVEL=none

NVAPI_VERB=$SELF_PATH/.wine/nvapi.verb
WINEDLLOVERRIDES="winemenubuilder.exe=d"
WINEESYNC=1
DXVK_ENABLE_NVAPI=1
VKD3D_CONFIG=dxr
DXVK_STATE_CACHE=1
DXVK_STATE_CACHE_PATH=$WINEPREFIX/.shadercache
__GL_SHADER_DISK_CACHE=1
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
__GL_SHADER_DISK_CACHE_PATH=$DXVK_STATE_CACHE_PATH

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return # exit if sourced
# allows to source this env on your term without executing any app
USER=wineuser

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
echo $deps | grep dxvk > /dev/null || winetricks -q dxvk
echo $deps | grep vkd3d > /dev/null || winetricks -q vkd3d
echo $deps | grep nvapi > /dev/null || winetricks -q "$NVAPI_VERB"

cd bin/x64
wine Cyberpunk2077.exe -skipStartScreen
