local config = require("config")

local entitiesWithReverse = {}
local entitiesWithHorn = {}
local entitiesWithFlasher = {}
local reverseHornKeybind = lib.addKeybind({
    name = "reverse_horn",
    description = "Plays the reverse horn",
    defaultKey = "0",
    defaultMapper = "keyboard",
    disabled = true,
    onPressed = function()
        if not cache.vehicle then return end
        local plate = GetVehicleNumberPlateText(cache.vehicle)
        if not config.ReverseHorns[plate] then return end
        if not GetIsVehicleEngineRunning(cache.vehicle) then return end
        TriggerServerEvent("filo_reversehorn:server:playReverseHorn", NetworkGetNetworkIdFromEntity(cache.vehicle))
    end,
    onReleased = function()
        TriggerServerEvent("filo_reversehorn:server:stopReverseHorn")
    end
})

local hornKeybind = lib.addKeybind({
    name = "horn",
    description = "Plays the horn",
    defaultKey = "9",
    defaultMapper = "keyboard",
    disabled = true,
    onPressed = function()
        if not cache.vehicle then return end
        local plate = GetVehicleNumberPlateText(cache.vehicle)
        if not config.Horns[plate] then return end
        if not GetIsVehicleEngineRunning(cache.vehicle) then return end
        TriggerServerEvent("filo_reversehorn:server:playHorn", NetworkGetNetworkIdFromEntity(cache.vehicle))
    end,
    onReleased = function()
        TriggerServerEvent("filo_reversehorn:server:stopHorn")
    end
})

local lightsState, highbeamsState = nil, nil
local flasherKeybind = lib.addKeybind({
    name = "flasher",
    description = "Plays the flasher",
    defaultKey = "8",
    defaultMapper = "keyboard",
    disabled = true,
    onPressed = function(self)
        if not cache.vehicle then return end
        local plate = GetVehicleNumberPlateText(cache.vehicle)
        if not config.Flashers[plate] then return end
        if not GetIsVehicleEngineRunning(cache.vehicle) then return end
        TriggerServerEvent("filo_reversehorn:server:playFlasher", NetworkGetNetworkIdFromEntity(cache.vehicle))

        local _, lightsOn, highbeamsOn = GetVehicleLightsState(cache.vehicle)
        lightsState, highbeamsState = lightsOn, highbeamsOn

        local count = 0
        while self.isPressed do
            Wait(50)
        end

        SetVehicleLights(cache.vehicle, lightsState == 1 and 3 or 4)
        SetVehicleFullbeam(cache.vehicle, highbeamsState == 1 and true or false)
    end,
    onReleased = function()
        TriggerServerEvent("filo_reversehorn:server:stopFlasher")
    end
})

lib.onCache("vehicle", function(vehicle)
    TriggerServerEvent("filo_reversehorn:server:stopReverseHorn")
    TriggerServerEvent("filo_reversehorn:server:stopHorn")
    if not vehicle then
        reverseHornKeybind.disabled = true
        hornKeybind.disabled = true
        return
    end

    local model = GetEntityModel(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    if config.ReverseHorns[plate] then
        reverseHornKeybind.disabled = false
    end

    if config.Horns[plate] then
        hornKeybind.disabled = false
    end

    if config.Flashers[plate] then
        flasherKeybind.disabled = false
    end
end)

RegisterNetEvent("filo_reversehorn:client:playReverseHorn", function(name, path, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)

    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)
    entitiesWithReverse[#entitiesWithReverse + 1] = playerPed

    local coords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(cache.ped)
    local distance = #(pedCoords - coords)
    local volume = lib.math.interp(1.0, 0.1, math.min(distance / 50.0, 1.0))

    exports.xsound:PlayUrlPos(name, path, volume, coords, true)
    exports.xsound:setSoundDynamic(name, true)
    exports.xsound:setVolumeMax(name, volume)
    exports.xsound:Distance(name, 100.0)

    CreateThread(function()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        while lib.table.contains(entitiesWithReverse, playerPed) do
            Wait(100)
            coords = GetEntityCoords(playerPed)
            pedCoords = GetEntityCoords(cache.ped)
            distance = #(pedCoords - coords)
            volume = lib.math.interp(1.0, 0.1, math.min(distance / 50.0, 1.0))

            if not GetIsVehicleEngineRunning(vehicle) then
                break
            end

            if exports.xsound:soundExists(name) then
                exports.xsound:Position(name, coords)
                exports.xsound:setVolumeMax(name, volume)
            end
        end
        exports.xsound:Destroy(name)
    end)
end)

RegisterNetEvent("filo_reversehorn:client:stopReverseHorn", function(name, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)
    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)
    for k, v in pairs(entitiesWithReverse) do
        if v == playerPed then
            entitiesWithReverse[k] = nil
        end
    end
end)

RegisterNetEvent("filo_reversehorn:client:playHorn", function(name, path, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)

    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)
    entitiesWithHorn[#entitiesWithHorn + 1] = playerPed

    local coords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(cache.ped)
    local distance = #(pedCoords - coords)
    local volume = lib.math.interp(1.0, 0.1, math.min(distance / 50.0, 1.0))

    exports.xsound:PlayUrlPos(name, path, volume, coords, true)
    exports.xsound:setSoundDynamic(name, true)
    exports.xsound:setVolumeMax(name, volume)
    exports.xsound:Distance(name, 100.0)

    CreateThread(function()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        while lib.table.contains(entitiesWithHorn, playerPed) do
            Wait(100)
            coords = GetEntityCoords(playerPed)
            pedCoords = GetEntityCoords(cache.ped)
            distance = #(pedCoords - coords)
            volume = lib.math.interp(1.0, 0.1, math.min(distance / 50.0, 1.0))

            if not GetIsVehicleEngineRunning(vehicle) then
                break
            end

            if exports.xsound:soundExists(name) then
                exports.xsound:Position(name, coords)
                exports.xsound:setVolumeMax(name, volume)
            end
        end
        exports.xsound:Destroy(name)
    end)
end)

RegisterNetEvent("filo_reversehorn:client:stopHorn", function(name, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)
    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)
    for k, v in pairs(entitiesWithHorn) do
        if v == playerPed then
            entitiesWithHorn[k] = nil
        end
    end
end)

RegisterNetEvent("filo_reversehorn:client:playFlasher", function(name, path, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)

    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)
    entitiesWithFlasher[#entitiesWithFlasher + 1] = playerPed

    local coords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(cache.ped)
    local distance = #(pedCoords - coords)

    CreateThread(function()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local count = 0
        local _, lightsOn, highbeamsOn = GetVehicleLightsState(cache.vehicle)

        while lib.table.contains(entitiesWithFlasher, playerPed) do
            Wait(50)
            coords = GetEntityCoords(playerPed)
            pedCoords = GetEntityCoords(cache.ped)
            distance = #(pedCoords - coords)

            if not GetIsVehicleEngineRunning(vehicle) then
                break
            end

            if distance >= 100.0 then break end

            count += 1
            SetVehicleLights(vehicle, count % 2 == 0 and 1 or 2)
            SetVehicleFullbeam(vehicle, count % 2 == 0 and false or true)
            StartVehicleHorn(vehicle, 125, `HELDDOWN`, false)
        end

        SetVehicleLights(vehicle, lightsOn == 1 and 3 or 4)
        SetVehicleFullbeam(vehicle, highbeamsOn == 1 and true or false)
    end)
end)

RegisterNetEvent("filo_reversehorn:client:stopFlasher", function(name, playerSource)
    if GetResourceState("xsound") ~= "started" then return end
    if playerSource == true then playerSource = 1 end
    playerSource = tonumber(playerSource)
    local player = GetPlayerFromServerId(playerSource)
    local playerPed = GetPlayerPed(player)

    for k, v in pairs(entitiesWithFlasher) do
        if v == playerPed then
            entitiesWithFlasher[k] = nil
        end
    end
end)