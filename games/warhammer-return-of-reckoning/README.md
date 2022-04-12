This warhammer return of reckoning runner requires wine 6.21 available here :
https://github.com/GloriousEggroll/wine-ge-custom/releases/tag/6.20-GE-1

It's runs either with dxvk or base d3dx9

The RoRLauncher.exe doesn't work with dxvk if its `d3d9` lib override is set as native.

To use dxvk, 2 solutions :
* remove dxvk's `d3d9` from global overrides, and set a specific d3d9=native rule for WAR-64.exe
* let global d3d9 override as native and set a specific d3d9=builtin rule for RoRLauncher.exe

If you use package d3dx9 everything should work directly without specific setup.
