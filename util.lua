-- gibt die laenge der tabelle zurueck
function LmFaction.Util.tableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end