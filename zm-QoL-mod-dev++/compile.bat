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
type "mods\tranzit.gsc" >> "build\final.gsc"
type "mods\health+zombiecounter.gsc">> "build\final.gsc"
echo - Generated build\final.gsc file.

if exist "resources\compiler\Compiler.exe" (
    if exist "resources\compiler\Irony.dll" (
        echo - Compiling build\final.gsc...
        echo.
        "resources\compiler\Compiler.exe" "build\final.gsc"
        xcopy /c /f "final-compiled.gsc" "build\" /Y
        del /f "final-compiled.gsc"
        ren "build\final-compiled.gsc" "_scoreboard.gsc"
        del /f "build\final.gsc"
        if exist "build\maps\mp\gametypes_zm" (
            if exist "build\maps\mp\gametypes_zm\_scoreboard.gsc" (
                del /f "build\maps\mp\gametypes_zm\_score.gsc"
            )
            xcopy /c /f "build\_scoreboard.gsc" "build\maps\mp\gametypes_zm" /Y
            del /f "build\_scoreboard.gsc"
        ) else (
            mkdir "build\maps\mp\gametypes_zm"
            if exist "build\maps\mp\gametypes_zm\_scoreboard.gsc" (
                del /f "build\maps\mp\gametypes_zm\_score.gsc"
            )
            xcopy /c /f "build\_scoreboard.gsc" "build\maps\mp\gametypes_zm" /Y
            del /f "build\_scoreboard.gsc"
        )
        echo.
        color 2
        echo - Compiled finished! The output file is in build\maps\mp\gametypes_zm\_scoreboard.gsc.
        echo.
    ) else (
        echo.
        color 1
        echo - Cannot find resources\compiler\Irony.dll, the compiling process will stop here.
        echo - You can find the uncompiled, merged file in build\final.gsc.
        echo.
    )
) else (
    echo.
    color 1
    echo Cannot find resources\compiler\Compiler.exe, the compiling process will stop here.
    echo You can find the uncompiled, merged file in build\final.gsc.
    echo.
)

pause
color 7