@echo off
cls
color 2
echo.
echo - Starting compiling process...

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
type "mods\hitmarkers.gsc" >> "build\final.gsc"
type "mods\max_ammo.gsc" >> "build\final.gsc"
type "mods\perks_on_spawn.gsc" >> "build\final.gsc"
type "mods\revive_actions.gsc" >> "build\final.gsc"
type "mods\revive_rewards.gsc" >> "build\final.gsc"
type "mods\round_salary.gsc" >> "build\final.gsc"
type "mods\small_features.gsc" >> "build\final.gsc"
type "mods\spawn_on_join.gsc" >> "build\final.gsc"
type "mods\zombie_counter.gsc" >> "build\final.gsc"
type "mods\tranzit.gsc" >> "build\final.gsc"

del /f "C:\Games\Black Ops 2\data\scripts\final.gsc"
xcopy /c /f "build\final.gsc" "C:\Games\Black Ops 2\data\scripts\" /Y
del /f "build\final.gsc"

color 7