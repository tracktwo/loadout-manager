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
    var TSaveSlots kSaveSlots[NUM_CLASSES];
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

function XGChooseSquadUI GetChooseSquadMgr()
{
    local XGChooseSquadUI kMgr;
    foreach AllActors(class 'XGChooseSquadUI', kMgr)
    {
        return kMgr;
    }

    `Log("Failed to locate an XGChooseSquadUI instance");
    return None;
}

function XGSoldierUI GetSoldierMgr()
{
    local XGSoldierUI kMgr;

    foreach AllActors(class 'XGSoldierUI', kMgr)
    {
        return kMgr;
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
    local XGSoldierUI kMgr;
    local TMenuOption kOption;
    local TMenu kMainMenu;
    local int i;
    local XGStrategySoldier kSoldier;
    local int iBank;

    kMgr = GetSoldierMgr();
    kMgr.m_kMainMenu.arrOptions.Length = 0;

    kSoldier = kMgr.m_kSoldier;

    iBank = GetBank(kSoldier);
    `Log("Using bank " $ iBank $ " for class " $ kSoldier.GetEnergy());

    for (i = 0; i < NUM_SLOTS; ++i) {
        kOption.strText = "Loadout Slot " $ string(i + 1);
        if (kMgr.m_iCurrentView == RESTORE_LOADOUT_VIEW) {
            kOption.iState = IsSlotEmpty(iBank, i) ? 1 : 0;
        } else {
            kOption.iState = 0;
        }
        kOption.strHelp = GetLoadoutSummary(iBank, i);
        kMgr.m_kMainMenu.arrOptions.AddItem(i);
        kMainMenu.arrOptions.AddItem(kOption);
    }

    kMgr.m_kMainMenu.mnuOptions = kMainMenu;
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
    local XGSoldierUI kMgr;
    local XGStrategySoldier kSoldier;
    local int iBank;
    local int iSlot;

    `Log("SaveLoadout: " $ slot);
    kMgr = GetSoldierMgr();
    kSoldier = kMgr.m_kSoldier;
    iBank = GetBank(kSoldier);
    iSlot = GetSlotNumber(slot);
    kSaveSlots[iBank].kLoadout[iSlot] = kSoldier.m_kChar.kInventory;
    kMgr.PlayGoodSound();
    kMgr.GoToView(0);
}

function String ApplySoldierLoadout(XGStrategySoldier kSoldier, TInventory kInventory)
{
    local bool success;
    local string failStr;
    local int i;
    local int j;

    success = true;
    failStr = "";

    if (kInventory.iArmor != 0 && kInventory.iArmor != kSoldier.m_kChar.kInventory.iArmor) {
        if (!LOCKERS().EquipArmor(kSoldier, kInventory.iArmor)) {
            success = false;
            failStr $= "- " $ GetLocalizedItemName(kInventory.iArmor) $ "\n";
        }
    }

    // Set the correct number of large/small slots for their armor
    TACTICAL().TInventoryLargeItemsClear(kSoldier.m_kChar.kInventory);
    TACTICAL().TInventorySmallItemsClear(kSoldier.m_kChar.kInventory);
    TACTICAL().TInventoryLargeItemsAdd(kSoldier.m_kChar.kInventory, LOCKERS().GetLargeInventorySlots(kSoldier, kSoldier.m_kChar.kInventory.iArmor));
    TACTICAL().TInventorySmallItemsAdd(kSoldier.m_kChar.kInventory, LOCKERS().GetSmallInventorySlots(kSoldier, kSoldier.m_kChar.kInventory.iArmor));

    if (kInventory.iPistol != 0 && kInventory.iPistol != kSoldier.m_kChar.kInventory.iPistol && kSoldier.GetClass() != 2) {
        if (!LOCKERS().EquipPistol(kSoldier, kInventory.iPistol)) {
            success = false;
            failStr $= "- " $ GetLocalizedItemName(kInventory.iPistol) $ "\n";
        }
    }

    j = 0;
    for (i = 0; i < kInventory.iNumLargeItems; ++i) {
        if (j >= kSoldier.m_kChar.kInventory.iNumLargeItems || !LOCKERS().EquipLargeItem(kSoldier, kInventory.arrLargeItems[i], j)) {
            success = false;
            failStr $= "- " $ GetLocalizedItemName(kInventory.arrLargeItems[i]) $ "\n";
        }
        else {
            j++;
        }
    }

    j = 0;
    for (i = 0; i < kInventory.iNumSmallItems; ++i) {
        if (j >= kSoldier.m_kChar.kInventory.iNumSmallItems || !LOCKERS().EquipSmallItem(kSoldier, kInventory.arrSmallItems[i], j)) {
            success = false;
            failStr $= "- " $ GetLocalizedItemName(kInventory.arrSmallItems[i]) $ "\n";
        } else {
            j++;
        }
    }

    j = 0;
    for (i = 0; i < kInventory.iNumCustomItems; ++i) {
        if (!LOCKERS().EquipCustomItem(kSoldier, kInventory.arrCustomItems[i], j)) {
            success = false;
            failStr $= "- " $ GetLocalizedItemName(kInventory.arrCustomItems[i]) $ "\n";
        } else {
            j++;
        }
    }

    return success ? "" : failStr;
}

function string DoLoadout(XGStrategySoldier kSoldier, int iBank, int iSlot)
{
    local string failStr;
    local int i;

    // Release most items. Leaves default items & small items that aren't infinite.
    STORAGE().BackupAndReleaseInventory(kSoldier);

    // Remove all small items. This ensures items that can't be duplicated (e.g. alien trophies)
    // are all removed before trying to add a new one. E.g. if the current loadout has a trophy in slot 2 and
    // you try to apply a loadout with one in slot 1, it'll fail unless they're all removed.
    for (i = 0; i < kSoldier.m_kChar.kInventory.iNumSmallItems; ++i) {
        LOCKERS().UnequipSmallItem(kSoldier, i);
    }

    for (i = 0; i < kSoldier.m_kChar.kInventory.iNumLargeItems; ++i) {
        LOCKERS().UnequipLargeItem(kSoldier, i);
    }

    for (i = 0; i < kSoldier.m_kChar.kInventory.iNumCustomItems; ++i) {
        LOCKERS().UnequipCustomItem(kSoldier, i);
    }

    failStr = ApplySoldierLoadout(kSoldier, kSaveSlots[iBank].kLoadout[iSlot]);     
    kSoldier.OnLoadoutChange();

    return failStr;
}

function RestoreLoadout(String slot)
{
    local XGSoldierUI kMgr;
    local XGStrategySoldier kSoldier;
    local int iBank;
    local int iSlot;
    local string failStr;
    local UIDialogueBox.TDialogueBoxData kDialog;

    `Log("RestoreLoadout: " $ slot);
    kMgr = GetSoldierMgr();
    kSoldier = kMgr.m_kSoldier;
    iBank = GetBank(kSoldier);
    iSlot = GetSlotNumber(slot);

    // If this slot is empty, play the bad sound but stay in the view.
    if (IsSlotEmpty(iBank, iSlot)) {
        kMgr.PlayBadSound();
        return;
    }
    else {
        failStr = DoLoadout(kSoldier, iBank, iSlot);
        PRES().m_kSoldierSummary.UpdatePanels();
        if (PRES().m_kSoldierLoadout != none) {
            PRES().m_kSoldierLoadout.UpdatePanels();
        }

        if (Len(failStr) == 0) {
            // Pretend we've just left the loadout UI. Plays a "close" sound and updates all the UI elements
            kMgr.OnLeaveGear(false);
        } else {
            kMgr.PlayBadSound();
            kDialog.strTitle = "Restore Loadout Failed";
            kDialog.strText = "Not enough equipment to re-equip soldier:\n" $ failStr;
            kDialog.strAccept = "OK";
            kDialog.fnCallback = OnCloseLoadoutDialog;
            XComHQPresentationLayer(XComHeadquartersController(XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).PlayerController).m_Pres).UIRaiseDialog(kDialog);
        }
    }
}

function OnCloseLoadoutDialog(UIDialogueBox.EUIAction eAction)
{
    local XGSoldierUI kMgr;
    kMgr = GetSoldierMgr();
    kMgr.OnLeaveGear(false);
}

function SquadLoadout(int iSlot)
{
    local XGChooseSquadUI kMgr;
    local XGShip_DropShip kDropship;
    local XGStrategySoldier kSoldier;
    local int iBank;
    local string failStr;
    local UIDialogueBox.TDialogueBoxData kDialog;

    kMgr = GetChooseSquadMgr();
    kDropship = HANGAR().GetDropship();

    foreach kDropship.m_arrSoldiers(kSoldier) {
        iBank = GetBank(kSoldier);
        if (!IsSlotEmpty(iBank, iSlot)) {
            failStr $= DoLoadout(kSoldier, iBank, iSlot);
            if (PRES().m_kSoldierLoadout != none) {
                PRES().m_kSoldierLoadout.UpdatePanels();
            }
        }
    }

    if (Len(failStr) > 0) {
        kMgr.PlayBadSound();
        kDialog.strTitle = "Squad Loadout Incomplete";
        kDialog.strText = "Not enough equipment to fully re-equip squad:\n" $ failStr;
        kDialog.strAccept = "OK";
        kDialog.fnCallback = OnCloseSquadDialog;
        XComHQPresentationLayer(XComHeadquartersController(XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).PlayerController).m_Pres).UIRaiseDialog(kDialog);
    }
    kMgr.UpdateView();
}

function OnCloseSquadDialog(UIDialogueBox.EUIAction eAction)
{
  
}


