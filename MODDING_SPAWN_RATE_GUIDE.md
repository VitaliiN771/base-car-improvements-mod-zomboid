# Project Zomboid: Modding Vehicle Spawn Rates

A guide to modifying spawn rates for custom vehicle mods, using the 87buickRegal mod as an example.

## Overview

Vehicle spawning in Project Zomboid is controlled by `VehicleZoneDistribution` tables defined in each zone type. Modded vehicles can be added to these tables to spawn in the world at configurable frequencies.

## Key Concepts

### Spawn Chance
Each vehicle in a zone has a `spawnChance` value (an integer). The actual spawn probability is calculated as:
```
vehicle spawn probability = spawnChance / (sum of all spawnChance values in zone)
```

Higher values = more frequent spawns.

### Zone Types
Common zones where vehicles spawn:
- `parkingstall` - Parking lots
- `trailerpark` - Trailer parks
- `bad` - Abandoned/poor areas
- `medium` - Residential areas
- `good` - Wealthy neighborhoods
- `sport` - Car enthusiast areas
- `junkyard` - Junk yards
- `trafficjamw/e/n/s` - Traffic jams (west/east/north/south)
- `police` - Police stations

### Base Game Reference Values

**Example: Base.CarNormal spawn weights**
- parkingstall: 20
- trailerpark: 25
- bad: 25
- medium: 30
- junkyard: 18
- trafficjams: 20

## How to Modify Modded Vehicle Spawn Rates

### Step 1: Locate the Spawn Configuration File

For build 42.13 (current), modded vehicle spawns are typically in:
```
mods/<mod_name>/42.13/media/lua/shared/<mod_name>_SpawnList.lua
```

**Important:** Project Zomboid uses version-specific folders. If your mod has a `42.13/` folder, that takes priority over the root `media/lua/` folder.

### Step 2: Find the Base Vehicle Definition

Check what vehicle entries are already in the spawn list:
```lua
VehicleZoneDistribution.parkingstall.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 1};
```

The format is:
```lua
VehicleZoneDistribution.<zone>.vehicles["<vehicle_class>"] = {index = -1, spawnChance = <number>};
```

### Step 3: Decide Which Zones to Add

Consider where your vehicle fits thematically:
- **Common vehicles** → parkingstall, trailerpark, bad, medium, junkyard
- **Traffic jams** → trafficjamw, trafficjame, trafficjamn, trafficjams
- **High-end vehicles** → good, sport
- **Specialty vehicles** → specific zones only

### Step 4: Determine Appropriate Spawn Chance Values

**Method 1: Match an Existing Vehicle (Recommended)**

If replacing a removed vehicle, use its former weights:
```lua
-- Before: Base.CarNormal had these values:
-- parkingstall: 20, trailerpark: 25, bad: 25, medium: 30, junkyard: 18

-- After: Apply to new vehicle:
VehicleZoneDistribution.parkingstall.vehicles["Base.MyCustomCar"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.trailerpark.vehicles["Base.MyCustomCar"] = {index = -1, spawnChance = 25};
-- etc...
```

**Method 2: Scale from Existing Values**

If adding a variant, use a fraction of the main vehicle:
```lua
-- Main vehicle: spawnChance = 30
-- Variant (less common): spawnChance = 15 (50% as common)
```

### Step 5: Update the Spawn List File

Edit the appropriate spawn list file. Example for 87buickRegal:

**File:** `mods/87buickRegal/42.13/media/lua/shared/87buickRegal_SpawnList.lua`

```lua
if VehicleZoneDistribution then

VehicleZoneDistribution.parkingstall.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.trailerpark.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 25};
VehicleZoneDistribution.bad.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 25};
VehicleZoneDistribution.medium.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 30};
VehicleZoneDistribution.good.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 2};
VehicleZoneDistribution.sport.vehicles["Base.87buickRegalGNX"] = {index = -1, spawnChance = 3};
VehicleZoneDistribution.junkyard.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 18};
VehicleZoneDistribution.trafficjamw.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.trafficjame.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.trafficjamn.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.trafficjams.vehicles["Base.87buickRegalTurboT"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.police.vehicles["Base.87buickRegalTurboTfbi"] = {index = -1, spawnChance = 4};

end
```

### Step 6: Sync Root and Version Folders (Optional but Recommended)

Keep both locations in sync for compatibility:
- `mods/<mod_name>/42.13/media/lua/shared/<mod_name>_SpawnList.lua` (active)
- `mods/<mod_name>/media/lua/shared/<mod_name>_SpawnList.lua` (backup/compatibility)

### Step 7: Test in Game

1. Start or load a world where your mod is active
2. Use the Lua console to verify spawn tables (if override commands are available)
3. Travel to different zones and observe vehicle spawning
4. Adjust spawn chance values if needed

## Common Issues

### Vehicle Not Spawning
- **Check:** Is the mod folder version-correct? (Build 42.13 uses `42.13/` folder)
- **Check:** Is the vehicle class name correct? (e.g., `Base.87buickRegalTurboT` not just `87buickRegalTurboT`)
- **Check:** Is the spawn chance value > 0?
- **Check:** Are there other mods overriding or removing the vehicle?

### Vehicle Spawning Too/Too Little
- **Adjust:** The `spawnChance` value. Higher = more common, lower = less common
- **Reference:** Compare to similar base game vehicles and scale accordingly

### Broken Mod Path Reference
- **Fix:** Typo in vehicle class name (e.g., `Base.Base.VehicleName` has double "Base.")
- **Fix:** Wrong path separator or file location

## Reference: Base Game Spawn Values

```lua
-- Parking lots (residential)
Base.CarNormal = 20
Base.SmallCar = 15
Base.PickUpTruck = 5

-- Trailer parks (rural)
Base.CarNormal = 25
Base.SmallCar = 29

-- Bad/Poor areas
Base.CarNormal = 25
Base.SmallCar = 27

-- Medium residential
Base.CarNormal = 30
Base.CarStationWagon = 8

-- Good/Wealthy
Base.ModernCar = 20
Base.SUV = 20

-- Junkyard
Base.CarNormal = 18
Base.SmallCar = 15

-- Traffic jams
Base.CarNormal = 20
Base.SmallCar = 15

-- Sport zone
Base.CarLuxury = 50
Base.SportsCar = 50
```

## Quick Checklist

- [ ] Locate mod's spawn list file in `42.13/media/lua/shared/`
- [ ] Identify the vehicle class name (e.g., `Base.MyVehicle`)
- [ ] Decide which zones the vehicle should spawn in
- [ ] Choose spawn chance values (reference base game or other mods)
- [ ] Add/update each zone entry with the vehicle and spawnChance
- [ ] Sync root `media/lua/shared/` file if needed
- [ ] Test in game
- [ ] Adjust spawn chances if needed

## Example: Adding a New Variant Vehicle

```lua
-- Original vehicle spawning 30 times per zone
-- Add variant at 50% spawn rate

VehicleZoneDistribution.parkingstall.vehicles["Base.MyVehicle"] = {index = -1, spawnChance = 30};
VehicleZoneDistribution.parkingstall.vehicles["Base.MyVehicleVariant"] = {index = -1, spawnChance = 15};

-- Now Base.MyVehicle spawns 30/45 = 67% of the time
-- And Base.MyVehicleVariant spawns 15/45 = 33% of the time
```

---

**Last Updated:** June 8, 2026  
**Game Version:** Project Zomboid Build 42.13
