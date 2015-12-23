class LoadoutManager extends XGStrategyActor;

const SAVE_LOADOUT_VIEW = 9;
const RESTORE_LOADOUT_VIEW = 10;
const NUM_SLOTS = 6;
const NUM_CLASSES = 17; //8 classes + 8 mecs + PFC

struct TSaveSlots
{
    var TInventory kLoadout[NUM_SLOTS];
};

struct CheckpointRecord
{
};

var TSaveSlots kSaveSlots[NUM_CLASSES];

function int GetBank(XGStrategySoldier kSoldier)
{
    switch(kSoldier.GetEnergy())
    {
        // Bio classes
        case 11: return 0;
        case 21: return 1;
        case 12: return 2;
        case 22: return 3;
        case 13: return 4;
        case 23: return 5;
        case 14: return 6;
        case 24: return 7;

        //MEC classes
        case 31: return 8;
        case 41: return 9;
        case 32: return 10;
        case 42: return 11;
        case 33: return 12;
        case 43: return 13;
        case 34: return 14;
        case 44: return 15;

        // PFC or supraclass assigned but class not yet chosen
        default:
            return 16;
    }
}

function XGSoldierUI GetSoldierUI()
{
    local XGSoldierUI kUI;

    foreach AllActors(class 'XGSoldierUI', kUI)
    {
        return kUI;
    }

    `Log("Failed to locate an XGSoldierUI instance");
    return None;
}

function bool IsSlotEmpty(int iBank, int iSlot)
{
    return kSaveSlots[iBank].kLoadout[iSlot].iArmor == 0;
}

function String GetLocalizedItemName(int ItemType)
{
    return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kGameCore.GetLocalizedItemName(EItemType(ItemType));
}

function String GetLoadoutSummary(int iBank, int iSlot)
{
    local String str;
    local int i;
    if (IsSlotEmpty(iBank, iSlot)) {
        return "<Empty>";
    } else {
        str = GetLocalizedItemName(kSaveSlots[iBank].kLoadout[iSlot].iArmor);
        if (kSaveSlots[iBank].kLoadout[iSlot].iPistol != 0) {
            str $= "\n" $ GetLocalizedItemName(kSaveSlots[iBank].kLoadout[iSlot].iPistol);
        }
        for (i = 0; i < kSaveSlots[iBank].kLoadout[iSlot].iNumLargeItems; ++i) {
            if (i % 2 == 0) {
                str $= "\n";
            } else {
                str $= " / ";
            }
            str $= GetLocalizedItemName(kSaveSlots[iBank].kLoadout[iSlot].arrLargeItems[i]);
        }
        for (i = 0; i < kSaveSlots[iBank].kLoadout[iSlot].iNumSmallItems; ++i) {
            if (i % 2 == 0) {
                str $= "\n";
            } else {
                str $= " / ";
            }
            str $= GetLocalizedItemName(kSaveSlots[iBank].kLoadout[iSlot].arrSmallItems[i]);
        }

        return str;
    }
}

function UpdateMainMenu()
{
    local XGSoldierUI kUI;
    local TMenuOption kOption;
    local TMenu kMainMenu;
    local int i;
    local XGStrategySoldier kSoldier;
    local int iBank;

    kUI = GetSoldierUI();
    kUI.m_kMainMenu.arrOptions.Length = 0;

    kSoldier = kUI.m_kSoldier;

    iBank = GetBank(kSoldier);
    `Log("Using bank " $ iBank $ " for class " $ kSoldier.GetEnergy());

    for (i = 0; i < NUM_SLOTS; ++i) {
        kOption.strText = "Loadout Slot " $ string(i + 1);
        if (kUI.m_iCurrentView == RESTORE_LOADOUT_VIEW) {
            kOption.iState = IsSlotEmpty(iBank, i) ? 1 : 0;
        } else {
            kOption.iState = 0;
        }
        kOption.strHelp = GetLoadoutSummary(iBank, i);
        kUI.m_kMainMenu.arrOptions.AddItem(i);
        kMainMenu.arrOptions.AddItem(kOption);
    }

    kUI.m_kMainMenu.mnuOptions = kMainMenu;
}

function int GetSlotNumber(String str)
{
    local int i;
    for (i = 0; i < NUM_SLOTS; ++i) {
        if (str == string(i)) {
            return i;
        }
    }
    `Log("Error: Invalid slot number: " $ str);
    return 0;
}

function SaveLoadout(String slot)
{
    local XGSoldierUI kUI;
    local XGStrategySoldier kSoldier;
    local int iBank;
    local int iSlot;

    `Log("SaveLoadout: " $ slot);
    kUI = GetSoldierUI();
    kSoldier = kUI.m_kSoldier;
    iBank = GetBank(kSoldier);
    iSlot = GetSlotNumber(slot);
    kSaveSlots[iBank].kLoadout[iSlot] = kSoldier.m_kChar.kInventory;
    kUI.PlayGoodSound();
    kUI.GoToView(0);
}

function RestoreLoadout(String slot)
{
    local XGSoldierUI kUI;
    local XGStrategySoldier kSoldier;
    local int iBank;
    local int iSlot;

    `Log("RestoreLoadout: " $ slot);
    kUI = GetSoldierUI();
    kSoldier = kUI.m_kSoldier;
    iBank = GetBank(kSoldier);
    iSlot = GetSlotNumber(slot);

    // If this slot is empty, play the bad sound but stay in the view.
    if (IsSlotEmpty(iBank, iSlot)) {
        kUI.PlayBadSound();
        return;
    }
    else {
        STORAGE().BackupAndReleaseInventory(kSoldier);
        LOCKERS().ApplySoldierLoadout(kSoldier, kSaveSlots[iBank].kLoadout[iSlot]);     
        kSoldier.OnLoadoutChange();
        PRES().m_kSoldierSummary.UpdatePanels();
        if (PRES().m_kSoldierLoadout != none) {
            PRES().m_kSoldierLoadout.UpdatePanels();
        }
        // Pretend we've just left the loadout UI. Plays a "close" sound and updates all the UI elements
        kUI.OnLeaveGear(false);
    }
}

