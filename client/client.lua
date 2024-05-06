local Framework = require 'framework.client'

local npcPed = nil
local SoldPeds = {}
local npcBlip = nil
local playerInZone = false
local isInSpawnZone = false
local currentZone = nil
local zoneItems = {}
local InitiateSellProgress = false

-- Function to spawn NPCs
function CreateBuyer()
    Wait(Config.checkInterval)
    local npcs = Config.npcModel
    local npcModel = npcs[math.random(#npcs)]
    local npcHash = GetHashKey(npcModel)
    RequestModel(npcHash)
    while not HasModelLoaded(npcHash) do
        Wait(500)
    end

    local sellZone = GetRandomSellZone()
    if not sellZone then return end

    local spawnZone = sellZone.pedZones[math.random(1, #sellZone.pedZones)]
    if not spawnZone then return end

    npcPed = CreatePed(4, npcHash, spawnZone.coords.x, spawnZone.coords.y, spawnZone.coords.z, 0.0, true, true)
    SetEntityAsMissionEntity(npcPed, true, true)
    SetModelAsNoLongerNeeded(npcHash)
    TaskWanderStandard(npcPed, 10.0, 10)

    npcBlip = AddBlipForEntity(npcPed)
    SetBlipSprite(npcBlip, Config.npcBlipSprite)
    SetBlipColour(npcBlip, Config.npcBlipColor)
    SetBlipScale(npcBlip, Config.npcBlipScale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.npcBlipLabel)
    EndTextCommandSetBlipName(npcBlip)
    createTarget()
    FollowPlayer(npcPed)
    Framework:Notify(Lang:t("buyer_ready"))
end

-- Function to remove targets
function removeTarget()
    Framework:RemoveGlobalPed({'Vestle kliendiga', 'drugTalkPed'})
end

-- Function to delete the created ped and its blip
function DeleteCreatedPed()
    local npc = npcPed
    if DoesEntityExist(npc) then
        SetPedKeepTask(npc, false)
        TaskSetBlockingOfNonTemporaryEvents(npc, false)
        ClearPedTasks(npc)
        TaskWanderStandard(npc, 10.0, 10)
        SetPedAsNoLongerNeeded(npc)
        RemoveBlip(npcBlip)
        removeTarget()
        npcBlip = nil
        npcPed = nil
        Citizen.Wait(1000)
    end
end

-- Function to create targets
function createTarget()
    local randamt = math.random(20, 500)
    Framework:AddGlobalPed(Config.npcModel, {
        {
            name = 'drugTalkPed',
            label = Lang:t("interact"),
            icon = 'fas fa-comments',
            distance = 4,
            onSelect = function(data)
                initiateSales(data.entity)
            end,
            canInteract = canTarget,
        }
    })
end

-- Function to add a ped to the SoldPeds table
function addSoldPed(entity)
    SoldPeds[entity] = true
end

-- Function to check if a ped has been sold to before
function hasSoldPed(entity)
    return SoldPeds[entity] ~= nil
end

-- Function to initiate sales with a ped
function initiateSales(entity)
    local isSoldtoPed = hasSoldPed(entity)
    if isSoldtoPed then
        Framework:Notify(Lang:t("spoked"))
        return false
    end
    addSoldPed(entity)
    showSellMenu(entity)
    if Config.Debug then
        print('Drug Sales Initiated, now proceeding to interact')
    end
end

-- Function to show sell menu
function showSellMenu(ped)
    InitiateSellProgress = true
    local randomIndex = math.random(1, #zoneItems)
    local randomItem = zoneItems[randomIndex]

    local price = lib.callback.await('redux_drugsell:generatePrice', source, randomItem)

    local amount = randomItem.needed

    lib.registerContext({
        id = 'redux_menu',
        title = Lang:t("menutitle"),
        options = {
            {
                title = Framework:GetItemLabel(randomItem.item).. "- " .. Lang:t("buyer"),
                disabled = true,
                description = (Lang:t("needs")):format(amount, Framework:GetItemLabel(randomItem.item), price),
            },
            {
                title = Lang:t("selltitle"),
                icon = 'circle-check',
                onSelect = function()
                    TriggerEvent('redux_drugsell:initiate', { type = 'sell', items = {randomItem}, price = price, tped = ped})
                end
            },
            {
                title = Lang:t("declinetitle"),
                icon = 'circle-xmark',
                onSelect = function()
                    TriggerEvent('redux_drugsell:initiate', { type = 'close', tped = ped })
                end
            },
        }
    })
    lib.showContext('redux_menu')

    SetTimeout(Config.SellTimeout * 1000, function()
        if InitiateSellProgress then
            InitiateSellProgress = false
            lib.hideContext()
            Framework:Notify(Lang:t("time_waste"))
            SetPedAsNoLongerNeeded(npcPed)
            DeleteCreatedPed()
            removeTarget()
           
        end
    end)
end


-- Function to make NPC follow player
function FollowPlayer(npcPed)
    local playerPed = PlayerPedId()
    if npcPed and DoesEntityExist(npcPed) and playerPed then
        TaskFollowToOffsetOfEntity(npcPed, playerPed, 0.0, 0.0, 0.0, 4.0, -1, 0.5, true)
    end
end

-- Function to check if player is within any spawn zone
function IsPlayerInSpawnZone()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, sellZone in pairs(Config.SellZones) do
        local distance = #(playerCoords - sellZone.coords)
        if distance <= sellZone.size.x then
            currentZone = sellZone
            return true
        end
    end
    return false
end

-- This should work ?????
Citizen.CreateThread(function()
    while true do
        local curzone = IsPlayerInSpawnZone() -- Should return any bool
        if curzone then
            if not isInZone then -- checks if not bool then makes it true
                isInZone = true
                CreateBuyer()
            end
        else 
            if isInZone then 
                isInZone = false
                DeleteCreatedPed()
            end

        end
        Wait(Config.checkInterval)
    end
end)



-- Function to get a random sell zone
function GetRandomSellZone()
    local zones = {}
    for _, sellZone in pairs(Config.SellZones) do
        table.insert(zones, sellZone)
    end
    if #zones > 0 then
        return zones[math.random(1, #zones)]
    end
    return nil
end

-- Play give animation
function playGiveAnim(tped)
    local pid = PlayerPedId()
    lib.requestAnimDict('mp_common')
    FreezeEntityPosition(pid, true)
    TaskPlayAnim(pid, "mp_common", "givetake2_a", 8.0, -8, 2000, 0, 1, 0,0,0)
    TaskPlayAnim(tped, "mp_common", "givetake2_a", 8.0, -8, 2000, 0, 1, 0,0,0)
    FreezeEntityPosition(pid, false)
end

-- Event handler for initiating drug sales
RegisterNetEvent('redux_drugsell:initiate', function(cad)
    print(json.encode(cad))
    if cad.type == 'close' then
        InitiateSellProgress = false
        lib.hideMenu()
        Framework:Notify(Lang:t("reject"))
        SetPedAsNoLongerNeeded(cad.tped)
        DeleteCreatedPed()
        removeTarget()

        Wait(500)
        CreateBuyer()
    elseif cad.type == 'sell' then
        InitiateSellProgress = false
        playGiveAnim(cad.tped)
        TriggerServerEvent("redux_drugsell:initiatedrug", cad.items, cad.price)
        print("The price send : "..json.encode(cad.price))
        SetPedAsNoLongerNeeded(cad.tped)
        DeleteCreatedPed()
        removeTarget()

        Wait(500)
        CreateBuyer()
    end
end)


for zoneName, sellZone in pairs(Config.SellZones) do
    lib.zones.box({
        name = "SpawnZone_" .. zoneName,
        coords = sellZone.coords,
        size = sellZone.size,
        debug = true,
        onEnter = function()
            currentZone = sellZone
            zoneItems = {}

            for _, itemData in pairs(sellZone.items) do 
                local data = {
                    item = itemData.item,
                    price = itemData.price,
                    needed = itemData.needed
                }
                table.insert(zoneItems, data)
            end
            
            if Config.Debug then
                print("Player entered the spawn zone: " .. zoneName)
            end
            CreateBuyer()
        end,
        onExit = function()
            zone:remove()
           
            if Config.Debug then
                print("Player exited the spawn zone: " .. zoneName)
            end
            DeleteCreatedPed()
            removeTarget()
        end
    })
end
