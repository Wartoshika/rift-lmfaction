local addon, context, frame, textFrame, load, parent
local frameBar = {}
local margin = 77.5

-- initialisiert die gui
function LmFaction.Ui.init(_addon)

    -- addon zwischenspeichern
    addon = _addon

    -- gui erstellen
    context = UI.CreateContext("FactionContext")
    frame =  UI.CreateFrame("Mask", "LmFactionPannel", context)
    load = UI.CreateFrame("Mask", "LmFactionLoad", frame)

    -- parent auf die bar main festlegen
    parent = UI.Native.BarMain

    -- offsets setzen
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", margin, 0)
    frame:SetWidth(parent:GetWidth() - margin * 2)
    frame:SetHeight(15)
    frame:SetLayer(1)

    -- load frame fuer den fortschritt
    load:SetPoint("TOPLEFT", frame, "TOPLEFT");
    load:SetHeight(frame:GetHeight())
    load:SetWidth(0)
    load:SetLayer(2)
    
    -- hintergrundfarbe
    local staticColorLoss = .4
    local color = LmFaction.Options.color
    local _r = color.r - staticColorLoss;
    local _g = color.g - staticColorLoss;
    local _b = color.b - staticColorLoss;

    -- negativpruefung
    if _r < 0 then _r = 0 end
    if _g < 0 then _g = 0 end
    if _b < 0 then _b = 0 end

    frame:SetBackgroundColor(_r, _g, _b, color.a)
    load:SetBackgroundColor(color.r, color.g, color.b, color.a)

    -- nun den text erstellen
    textFrame = UI.CreateFrame("Text", "LmFactionText", context)
    textFrame:SetPoint("CENTER", frame, "CENTER")

    textFrame:SetText("Noch keine Fraktion zur Rufanzeige vorhanden")
    textFrame:SetLayer(3)

    -- border zeichnen
    LmFaction.Ui.buildFrameBars(frame, color)

    -- wenn max lvl dann parent ui etwas veraendern
    LmFaction.Ui.maxLevelCorrections()

end

-- gui update mit ruf aenderungen
function LmFaction.Ui.update(factionDetails, currentNotoriety, maxNotoriety, notorityState)

    -- ok, prozent zahl berechnen
    local percent = math.floor(currentNotoriety * 100 / maxNotoriety)

    -- balken richtig anzeigen
    load:SetWidth(math.floor(frame:GetWidth() * percent / 100))

    -- fraktionsnamen und werte anzeigen
    textFrame:SetText(factionDetails.name .. " " .. currentNotoriety .. " / " .. maxNotoriety .. " [ " .. factionDetails.categoryName .. " - " .. notorityState .. " ]")

end

-- zeichnet die rahmen
function LmFaction.Ui.buildFrameBars(mainFrame, color)

    -- erstmal frames erstellen
    frameBar.left =  {
        border = UI.CreateFrame("Mask", "LmFaction_frameBarLeft", mainFrame),
        point = "TOPLEFT",
        width = 1,
        height = mainFrame:GetHeight()
    }
    frameBar.top =  {
        border = UI.CreateFrame("Mask", "LmFaction_frameBarTop", mainFrame),
        point = "TOPCENTER",
        width = mainFrame:GetWidth(),
        height = 1
    }
    frameBar.right =  {
        border = UI.CreateFrame("Mask", "LmFaction_frameBarRight", mainFrame),
        point = "CENTERRIGHT",
        width = 1,
        height = mainFrame:GetWidth()
    }
    frameBar.bottom =  {
        border = UI.CreateFrame("Mask", "LmFaction_frameBarBottom", mainFrame),
        point = "BOTTOMCENTER",
        width = mainFrame:GetWidth(),
        height = 1
    }

    -- alle elemente durchgehen
    for dir, frame in pairs(frameBar) do

        -- attribute setzen
        frame.border:SetWidth(frame.width)
        frame.border:SetHeight(frame.height)
        frame.border:SetPoint(frame.point, mainFrame, frame.point)
        frame.border:SetBackgroundColor(color.r, color.g, color.b, color.a)
    end

end

-- korregiert die offsets etwas um einer gui ohne erfahrungsleiste gerecht zu werden
function LmFaction.Ui.maxLevelCorrections()

    -- player setzen
    local player = Inspect.Unit.Lookup("player")

    -- mit vorhandenen player berechnen
    local function maxLevelCalc(player)

        -- details
        local playerDetails = Inspect.Unit.Detail(player)

        -- wenn der spieler nicht verfügbar ist dann warten
        if playerDetails == nil then

            -- abbrechen
            return
        end

        -- event entfernen
        Command.Event.Detach(Event.Unit.Add, scanUnits, "LmFaction.Event.Unit.Add")

        -- aktuell ist 65 das max level
        if playerDetails.level == 65 then

            -- ok, anpassen
            frame:SetHeight(10)
            load:SetHeight(frame:GetHeight())
        end

    end

    -- scant die units bis der "player" vorhanden ist
    local function scanUnits(_, units)

        -- alle units durchgehen und gucken wer "player" ist
        for k,v in pairs(units) do

            -- ist dies der spieler?
            if k == player then

                -- ja!
                return maxLevelCalc(player)
            end
        end
    end

    -- es muss erstmal gewartet werden bis der spieler geladen ist
    Command.Event.Attach(Event.Unit.Add, scanUnits, "LmFaction.Event.Unit.Add")
end