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

## Instructions
Copy the needed runner in your game's folder. Make the script executable and execute it to launch
the game. It will create the wine prefix for you and install all the dependencies.

The script is divided in two parts, env vars part and runner part.
The env vars part is all the code before the line `[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return`.
If you source the sh file `source xxx.sh`, the game won't be executed, but you will get a ready to
run wine environnement for that game. You will be able to run directly wine command from your shell,
and everything will be ran in that game's prefix.

For some games I can provide the desktop file and the icon, you must install dekstop file
manually in `~/.local/share/applications` and icon file in `~/.icons` or `~/.local/share/icons`
(create folders as needed if they do not exists)

For GOG, you can download and install a game directly without the setup using [lgogdownloader](https://github.com/Sude-/lgogdownloader)
> lgogdownloader --galaxy-platform windows --galaxy-install your_game_name/0

Some games may have specific instructions detailed in their folder.
