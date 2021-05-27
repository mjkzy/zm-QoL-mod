@echo off
cls
color 2
echo.
echo - Starting compiling process...

set numberOf=12
if exist "build" (
    echo - \build directory already exists, continuing...
) else (
    mkdir "build"
    echo - build\ created.
)

if exist "build\final.gsc" (
    del /f "build\final.gsc"
)

type "main.gsc" >> "build\final.gsc"
echo - Adding file 1/%numberOf%
type "mods\double_spawn_fix.gsc" >> "build\final.gsc"
echo - Adding file 2/%numberOf%
type "mods\hitmarkers.gsc" >> "build\final.gsc"
echo - Adding file 3/%numberOf%
type "mods\max_ammo.gsc" >> "build\final.gsc"
echo - Adding file 4/%numberOf%
type "mods\perks_on_spawn.gsc" >> "build\final.gsc"
echo - Adding file 5/%numberOf%
type "mods\revive_actions.gsc" >> "build\final.gsc"
echo - Adding file 6/%numberOf%
type "mods\revive_rewards.gsc" >> "build\final.gsc"
echo - Adding file 7/%numberOf%
type "mods\round_salary.gsc" >> "build\final.gsc"
echo - Adding file 8/%numberOf%
type "mods\small_features.gsc" >> "build\final.gsc"
echo - Adding file 9/%numberOf%
type "mods\spawn_on_join.gsc" >> "build\final.gsc"
echo - Adding file 10/%numberOf%
type "mods\zombie_counter.gsc" >> "build\final.gsc"
echo - Adding file 11/%numberOf%
type "mods\tranzit.gsc" >> "build\final.gsc"
echo - Adding file 12/%numberOf%
type "mods\dierise.gsc" >> "build\final.gsc"
echo - Adding file 12/%numberOf%
echo - Generated build\final.gsc file.

del /f "C:\Games\Black Ops 2\data\scripts\final.gsc"
xcopy /c /f "build\final.gsc" "C:\Games\Black Ops 2\data\scripts\" /Y
del /f "build\final.gsc"

color 7