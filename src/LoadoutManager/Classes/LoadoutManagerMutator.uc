class LoadoutManagerMutator extends XComMutator;

var LoadoutManager m_kLoadoutManager;

function EnsureLoadoutManager(PlayerController Sender)
{
    local LoadoutManager lm;
    if (m_kLoadoutManager == None) {
        foreach AllActors(class 'LoadoutManager', lm)
        {
            m_kLoadoutManager = lm;
            break;
        }

        if (m_kLoadoutManager == None) {
            m_kLoadoutManager = Spawn(class'LoadoutManager', Sender);
        }
    }
}

function Mutate(String MutateString, PlayerController Sender)
{
    if (MutateString == "XGSoldierUI.SaveRestoreLoadoutMenu") {
        `Log("Mutate: SaveRestoreLoadoutMenu");
        EnsureLoadoutManager(Sender);
        m_kLoadoutManager.UpdateMainMenu();            
    }
    else if (InStr(MutateString, "XGSoldierUI.SaveLoadout_") > -1) {
        `Log("Mutate: SaveLoadout");
        EnsureLoadoutManager(Sender);
        m_kLoadoutManager.SaveLoadout(Split(MutateString, "XGSoldierUI.SaveLoadout_", true));
    }
    else if (InStr(MutateString, "XGSoldierUI.RestoreLoadout_") > -1) {
        `Log("Mutate: RestoreLoadout");
        EnsureLoadoutManager(Sender);
        m_kLoadoutManager.RestoreLoadout(Split(MutateString, "XGSoldierUI.RestoreLoadout_", true));
    }

    super.Mutate(MutateString, Sender);
}

