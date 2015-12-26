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
* Loadout description detailing the loadout settings is visible in-game for each loadout slot.

## Usage

After installation the soldier summary view (the view with the "Abilities", "Loadout", and "Customize" menu options) will have
two new menu options: Save Loadout and Restore Loadout. Clicking on these will display a sub-menu showing the six available slots
for that soldier class. 
    
For save, clicking a slot will record the current loadout settings of that soldier - armor, primary and secondary
weapons, pistols, and small items.

For restore, empty loadout slots will be greyed out and unselectable. Clicking on a used slot will replace a soldier's loadout with
the settings from that loadout slot. If there is not enough available equipment to completely equip the soldier, a dialog box with
a list of missing items is displayed. 

The squad selection screen is also updated to have two new menu options at the bottom for Squad Loadouts 1 and 2. Clicking these buttons
will apply the saved loadout slot 1 or 2 (respectively) to each soldier in the squad, according to each soldier's class. Like the per-soldier
loadout restore, if there is not enough equipment to completely equip the squad a dialog box will be displayed listing the missing equipment.
If there is no saved loadout in that slot number for a particular class, the soldiers of that class will keep their existing equipment. Only
the first two loadout slots have this special squad loadout behavior due to limitations in the game. So if you plan to use this functionality
reserve the first two slots for each class for the particular squad loadouts you want, and use 3-6 for others. For example, you may use slot 1
for your typical squad loadouts, and slot 2 for slightly different terror mission or EXALT mission loadouts.

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
