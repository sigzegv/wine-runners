This repo provides some wine runners for windows games. These runners are 
prepared to require the less dependencies as possible, you don't need to add
your game in Steam/Lutris to use these scripts and launch your games.
Also these runners are intended to be used with standalone games, usually from GOG or Humble games
without DRM.

## Prerequisite
* winetricks
Install winetricks anywhere in your $PATH.

* A wine runner, preferably a lutris' wine-ge runner from glorious eggroll
Download a wine-ge runner from https://github.com/GloriousEggroll/wine-ge-custom/releases/
and unpack it in `~/.local/share`, then create a symlink to this folder :
> ln -sf ~/.local/share/your-wine-ge-folder ~/.local/share/wine-ge

If you don't want to use `~/.local/share` folder for wine runner, you must edit WINEPATH var
in the script file to suit your needs.

## Instructions
Copy the needed runner in your game's folder. Make the script executable and execute it to launch
the game. It will create the wine prefix for you and install all the dependencies.

The script is divided in two parts, *env vars* part and *runner* part.

### Env vars
The env vars part is all the code before the line `[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return`.
If you source the sh file `source xxx.sh`, the game won't be executed, but you will get a ready to
use wine environnement in current shell for that game. You will be able to run wine commands directly
and everything will be done in that game's prefix context.
All the vars are editable to your needs. Most important are WINEPREFIX
(location of wine system files for that game) and WINEPATH (location of your wine binaries).

### Runner part
The runner part handle wine prefix creation, window system dependencies installation
(handled with winetricks), and running your game. The only thing you may need to edit
here are dependencies and game's executable. For modern games, you may need to install `vkd3d`
(dx12 dependency) and nvapi, provided in this repo, to enable DLSS on nvidia.

## Notes
As soon as a game has its own runner, that game is totally autonomous and can be moved anywere.
Wine prefixes can be safely deleted but you may need to backup custom registry entries
and game files (saves, configurations) first.

For some games you will find the desktop file and the icon, you must install dekstop file
manually in `~/.local/share/applications` and icon file in `~/.icons` or `~/.local/share/icons`
(create folders as needed if they do not exists)

For GOG, you can download and install a game directly without the setup using [lgogdownloader](https://github.com/Sude-/lgogdownloader)
> lgogdownloader --galaxy-platform windows --galaxy-install your_game_name/0

Some games may have specific instructions detailed in their folder.
