class LoadoutManager extends XGStrategyActor;

const SAVE_LOADOUT_VIEW = 9;
const RESTORE_LOADOUT_VIEW = 10;
const NUM_SLOTS = 6;

struct CheckpointRecord
{
};

function XGSoldierUI SoldierUI()
{
    local XGSoldierUI kUI;

    foreach AllActors(class 'XGSoldierUI', kUI)
    {
        return kUI;
    }

    `Log("Failed to locate an XGSoldierUI instance");
    return None;
}

function UpdateMainMenu()
{
    local XGSoldierUI kUI;
    local TMenuOption kOption;
    local TMenu kMainMenu;
    local int i;

    kUI = SoldierUI();
    `Log("Current menu length is " $ kUI.m_kMainMenu.arrOptions.Length);
    kUI.m_kMainMenu.arrOptions.Length = 0;
    `Log("New menu length is " $ kUI.m_kMainMenu.arrOptions.Length);

    for (i = 0; i < NUM_SLOTS; ++i) {
       kOption.strText = "Loadout Slot " $ string(i + 1);
       kOption.iState = 0;
       kOption.strHelp = "TODO: Contents";
        `Log("Adding option " $ kOption.strText);
       kUI.m_kMainMenu.arrOptions.AddItem(i);
        `Log("New menu length is " $ kUI.m_kMainMenu.arrOptions.Length);
       kMainMenu.arrOptions.AddItem(kOption);
    }

    kUI.m_kMainMenu.mnuOptions = kMainMenu;
}

function SaveLoadout(String slot)
{
    local XGSoldierUI kUI;
    `Log("SaveLoadout: " $ slot);
    kUI = SoldierUI();
    kUI.GoToView(0);
}

function RestoreLoadout(String slot)
{
    local XGSoldierUI kUI;
    `Log("RestoreLoadout: " $ slot);
    kUI = SoldierUI();
    kUI.GoToView(0);
}
