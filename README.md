# XCOM Loadout Manager for Long War

*See Installation instructions below. This is a fairly complex mod, please follow the instructions carefully to ensure it's installed
correctly*

Loadout Manager is a mod to help eliminate the repetative tasks of equipping soldiers for missions. The mod adds save/restore
loadout functionality to the soldier menu with per-class loadout slots, as well as new buttons on the squad select screen to
quickly apply a particular loadout slot to each selected soldier. The loadout settings save in your campaign save file, no need
to re-create them each session.

## Features

* 102 individual saved loadout slots (6 per class, including MEC classes, plus 6 slots for PFCs).
* New squad loadout buttons on the squad select to apply loadout slot #1 or slot #2 to each selected soldier for the mission.
* Dialog box feedback on failure to fully equip a soldier/squad if insufficient items are available.
* Loadout settings persist in the save file.


## Installation

Installation of this mod depends on whether or not you have the Campaign Summary mod also installed.

### Without Campaign Summary

1. Apply the patch file LoadoutManager.txt with PatcherGUI
2. Copy LoadoutManager.u to your XEW packages folder (e.g. C:\Program Files (x86)\Steam\SteamApps\Common\XCom Enemy Within\XEW\XComGame\CookedPCConsole)
3. Copy DefaultCheckpoint.ini to your XEW config folder (e.g. C:\Program Files (x86)\Steam\SteamApps\Common\XCom Enemy Within\XEW\XComGame\Config)
4. Add the following line to the bottom of the DefaultMutatorLoader.ini file in your XEW Config folder:
    arrStrategicMutators="LoadoutManager.LoadoutManagerMutator"

### With Campaign Summary

1. Apply the patch file LoadoutManager_With_CampaignSummary.txt with PatcherGUI
2. Copy LoadoutManager.u to your XEW packages folder (e.g. C:\Program Files (x86)\Steam\SteamApps\Common\XCom Enemy Within\XEW\XComGame\CookedPCConsole)
3. Add the following line to the bottom of the DefaultCheckpoint.ini file in your XEW Config folder:
    ActorClassesToRecord=LoadoutManager.LoadoutManager
4. Add the following line to the bottom of the DefaultMutatorLoader.ini file in your XEW Config folder:
    arrStrategicMutators="LoadoutManager.LoadoutManagerMutator"

## Troubleshooting

*I get a blank menu after clicking the new Save or Restore Loadout menu options*

Usually indicates the mutator is not installed correctly. See step 4 of the installation instructions.

*Saving and restoring loadouts works, but all loadout slots are empty after loading a save*

Usually indicates the checkpoint configuration is not set up correctly. See step 3 of the installation instructions.
