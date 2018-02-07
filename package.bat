@echo off
mkdir %1

copy %~dp0\Patches\UpdateMainMenu.txt %1\LoadoutManager.txt || (
    echo Failed to copy UpdateMainMenu.txt
    exit /b 1
    )

type %~dp0\Patches\GoToView.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnLeaveSoldierUI.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnMainMenuOption.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnMouseSimMission.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnSimMission.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnUnrealCommand.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\UpdateButtonHelp.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\UpdateData.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\UpdateView.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\OnInit.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\UISquadSelect.OnUnrealCommand.txt >> %1\LoadoutManager.txt
type %~dp0\Patches\gfxSoldierSummary.txt >> %1\LoadoutManager.txt

copy %1\LoadoutManager.txt %1\LoadoutManager_With_CampaignSummary.txt || (
    echo Failed to copy LoadoutManager.txt to CS version
    exit /b 1
    )

type %~dp0\Patches\CustomCheckpoints.txt >> %1\LoadoutManager.txt

copy %~dp0\README.md %1\README.md || (
    echo "Failed to copy README.md
    exit /b 1
    )

copy %~dp0\CHANGELOG.txt %1 || (
    echo Failed to copy CHANGELOG.txt
    exit /b 1
    )

copy D:\UDK\UDK-2011-09\UDKGame\CookedPC\LoadoutManager.u %1 || (
    echo Failed to copy LoadoutManager.u
    exit /b 1
    )

copy %~dp0\DefaultCheckpoint.ini %1 || (
    echo Failed to copy DefaultCheckpoint.ini
    exit /b 1
    )

copy %~dp0\loc\LoadoutManager.int %1 || (
    echo Failed to copy LoadoutManager.RUS
    exit /b 1
    )

copy %~dp0\loc\LoadoutManager.rus %1 || (
    echo Failed to copy LoadoutManager.RUS
    exit /b 1
    )

