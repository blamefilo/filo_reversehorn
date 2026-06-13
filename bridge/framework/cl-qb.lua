if GetResourceState("qb-core") ~= "started" then return end

QBCore = exports["qb-core"]:GetCoreObject()

function GetPlayerLicense()
    local player = QBCore.Functions.GetPlayerData()
    if not player then return end
    return player.license
end