-- addon env holen
local addon = ...

-- main init funktion nach addon load
local function init()

    -- event listener entfernen
    Command.Event.Detach(Event.Addon.Load.End, init, "init")

    -- gui bauen
    LmFaction.Ui.init(addon)

    -- variablen laden
    if LmFactionGlobal then

        -- variablen laden wenn definiert
        for k,v in pairs(LmFactionGlobal) do

            -- einzelnd updaten
            LmFaction.Options[k] = v;
        end
    end

    -- event fuer rufveraenderungen registrieren
    Command.Event.Attach(Event.Faction.Notoriety, LmFaction.Notoriety.update, "LmFaction.Notoriety.update")

    -- erfolgreichen start ausgeben
    print("erfolgreich geladen (v " .. addon.toc.Version .. ")")

    -- wenn bereits eine fraktion gesetzt ist dann diese anzeigen
    if LmFaction.Options.currentFaction ~= nil then

        -- anzeigen
        LmFaction.Notoriety.updateWithFaction(LmFaction.Options.currentFaction)
    end

    -- start zeit holen
    LmFaction._StartTime = Inspect.Time.Server()

end

-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmFactionGlobal = LmFaction.Options
end

-- event registrieren
Command.Event.Attach(Event.Addon.Load.End, init, "init")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")

