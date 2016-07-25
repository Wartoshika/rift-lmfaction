-- update event fuer ruf veraenderungen
function LmFaction.Notoriety.update(_, notorietyUpdate)

    -- wenn das update alle fraktione beinhaltet, muss dieses ignoriert werden
    local allFractionList = Inspect.Faction.List()
    if LmFaction.Util.tableLength(notorietyUpdate) == LmFaction.Util.tableLength(allFractionList) then

        -- nichts machen
        return
    end

    -- die fraktion
    local factionSelected, factionDetails

    -- es kann sein, dass es mehrere ruf updates gibt
    -- also kann immer nur einer angezeigt werden
    for faction, notoriety in pairs(notorietyUpdate) do

        -- diese nehmen!
        factionSelected = faction

        -- wir wollen nur die erste
        break
    end

    -- details holen
    factionDetails = Inspect.Faction.Detail(factionSelected)

    -- optionen speichern
    LmFaction.Options.currentFaction = factionDetails

    -- berechnen!
    local current, max, stateText = LmFaction.Notoriety.calculateNotoriety(factionDetails.notoriety)

    -- gui updaten
    LmFaction.Ui.update(
        factionDetails,
        current,
        max,
        stateText
    )

end

-- updated die gui und das addon system mit dem zuletzt gesetzten ruf ereignis aus dem speicher
function LmFaction.Notoriety.updateWithFaction(factionDetails)

        -- fortschritt berechnen
        local current, max, stateText = LmFaction.Notoriety.calculateNotoriety(factionDetails.notoriety)

        -- gui updaten
        LmFaction.Ui.update(
            factionDetails,
            current,
            max,
            stateText
        )
end

-- berechnet die aktuelle bekanntheit
function LmFaction.Notoriety.calculateNotoriety(notorietyAmount)

    -- neutral ist ab 23000 also abziehen
    notorietyAmount = notorietyAmount - 23000

    -- maximaler ruf pro status
    local maxValues = {3000, 10000, 20000, 35000, 60000, 90000, 120000}
    local maxState = {"Neutral", "Verbuendet", "Dekoriert", "Geschaetzt", "Verehrt", "Verherrlicht", "Hochgeachtet"}

    -- stateCounter fuer die schleife
    local stateCounter;

    -- alle status durchgehen
    for stateCounter = 1, 7 do

        -- kleiner?
        if notorietyAmount < maxValues[stateCounter] then

            -- ja!, dies ist der status und der max ruf
            return notorietyAmount, maxValues[stateCounter], maxState[stateCounter]
        else

            -- nein, also weitersuchen
            notorietyAmount = notorietyAmount - maxValues[stateCounter]
        end
    end

    -- nichts gefunden, sollte nicht passieren
    return 0, 0, "N/A" 

end