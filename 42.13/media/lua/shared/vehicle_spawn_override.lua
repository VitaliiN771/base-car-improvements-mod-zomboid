-- Disable Base.CarNormal spawn entries and log remaining state.

local function removeBaseCarNormalFromSpawnTables()
    if not VehicleZoneDistribution then
        print("[CarSpawnDebug] VehicleZoneDistribution not ready yet.")
        return 0
    end

    local removed = 0
    for zoneName, zone in pairs(VehicleZoneDistribution) do
        if type(zone) == "table" and type(zone.vehicles) == "table" then
            if zone.vehicles["Base.CarNormal"] ~= nil then
                zone.vehicles["Base.CarNormal"] = nil
                removed = removed + 1
            end
        end
    end

    return removed
end

local function logBaseCarNormalSpawnState()
    if not VehicleZoneDistribution then
        print("[CarSpawnDebug] VehicleZoneDistribution not ready yet.")
        return
    end

    local found = 0
    for zoneName, zone in pairs(VehicleZoneDistribution) do
        if type(zone) == "table" and type(zone.vehicles) == "table" and zone.vehicles["Base.CarNormal"] ~= nil then
            print("[CarSpawnDebug] Still present in zone: " .. zoneName)
            found = found + 1
        end
    end

    if found == 0 then
        print("[CarSpawnDebug] No Base.CarNormal spawn table entries remain.")
    else
        print("[CarSpawnDebug] Base.CarNormal still present in " .. tostring(found) .. " zone(s).")
    end
end

local function initCarSpawnDebug()
    local removed = removeBaseCarNormalFromSpawnTables()
    print("[CarSpawnDebug] Removed Base.CarNormal from " .. tostring(removed) .. " spawn tables.")
    logBaseCarNormalSpawnState()
end

if VehicleZoneDistribution then
    initCarSpawnDebug()
end

Events.OnGameBoot.Add(initCarSpawnDebug)
Events.OnInitWorld.Add(initCarSpawnDebug)
