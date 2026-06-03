local function GivePlayerAxe()
    local player = getPlayer()

    if player then
        player:getInventory():AddItem("Base.Axe")
    end
end

Events.OnGameStart.Add(GivePlayerAxe)