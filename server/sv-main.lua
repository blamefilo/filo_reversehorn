local config = require("config")

RegisterNetEvent("filo_reversehorn:server:playReverseHorn", function(netId)
    if GetResourceState("xsound") ~= "started" then return end
    local src = source
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local players = GetActivePlayers()
    local entity = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(entity)

    if not config.ReverseHorns[plate] then return end

    for _, player in pairs(players) do
        local playerPed = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(playerPed)
        if #(playerCoords - pedCoords) < 25.0 then
            lib.triggerClientEvent("filo_reversehorn:client:playReverseHorn", player,
                "reversehorn_" .. src,
                "nui://" .. cache.resource .. "/sounds/" .. config.ReverseHorns[plate],
                tostring(src)
            )
        end
    end
end)

RegisterNetEvent("filo_reversehorn:server:stopReverseHorn", function()
    TriggerClientEvent("filo_reversehorn:client:stopReverseHorn", -1, "reversehorn_" .. source)
end)

RegisterNetEvent("filo_reversehorn:server:playHorn", function(netId)
    if GetResourceState("xsound") ~= "started" then return end
    local src = source
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local players = GetActivePlayers()
    local entity = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(entity)
    if not config.Horns[plate] then return end

    for _, player in pairs(players) do
        local playerPed = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(playerPed)
        if #(playerCoords - pedCoords) < 25.0 then
            lib.triggerClientEvent("filo_reversehorn:client:playHorn", player,
                "horn_" .. src,
                "nui://" .. cache.resource .. "/sounds/" .. config.Horns[plate],
                tostring(src)
            )
        end
    end
end)

RegisterNetEvent("filo_reversehorn:server:stopHorn", function()
    TriggerClientEvent("filo_reversehorn:client:stopHorn", -1, "horn_" .. source)
end)

RegisterNetEvent("filo_reversehorn:server:playFlasher", function(netId)
    if GetResourceState("xsound") ~= "started" then return end
    local src = source
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local players = GetActivePlayers()
    local entity = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(entity)
    if not config.Flashers[plate] then return end

    for _, player in pairs(players) do
        local playerPed = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(playerPed)
        if #(playerCoords - pedCoords) < 25.0 then
            lib.triggerClientEvent("filo_reversehorn:client:playFlasher", player,
                "flasher_" .. src,
                "nui://" .. cache.resource .. "/sounds/" .. config.Flashers[plate],
                tostring(src)
            )
        end
    end
end)

RegisterNetEvent("filo_reversehorn:server:stopFlasher", function()
    TriggerClientEvent("filo_reversehorn:client:stopFlasher", -1, "flasher_" .. source)
end)