local Core = exports['rs_base']:GetCoreObject()
local Framework = require 'framework.server'
local ox = exports.ox_inventory

RegisterNetEvent('redux_drugsell:initiatedrug', function(items, price)
    local src = source
    local player = Core.Functions.GetPlayer(src)
    local confitems = items

    local inventory = {}
    local itemInfo = {}
    
    -- Choose a random item from the confitems table
    local randomIndex = math.random(1, #confitems)
    local randomItem = confitems[randomIndex]

    -- Check the player's inventory for the random item
    itemInfo = ox:GetItem(src, randomItem.item, nil, false)
    
    if itemInfo and itemInfo.count > 0 then
        inventory[randomItem.item] = itemInfo.count
    else
        inventory[randomItem.item] = 0
    end
    
    local hasItems = inventory[randomItem.item] >= randomItem.needed

    if not hasItems then 
        SellLast(src, randomItem, price, randomItem.needed)
        return
    end

    -- If the player has enough items, proceed with selling
    if hasItems then
        -- Remove the random item from the player's inventory
        if ox:RemoveItem(src, randomItem.item, randomItem.needed) then 
            
            ox:AddItem(player.PlayerData.source, Config.RewardItem, price)
        end

        TriggerClientEvent("DoLongHudText", src, Lang:t("sell_success"), "success")
    end
end)

-- Function to generate a random price for items
lib.callback.register('redux_drugsell:generatePrice', function(source, items)
    local generatedprice = math.random(items.price)
    return math.ceil(generatedprice)
end)

-- Function to sell the last item if the player doesn't have enough
function SellLast(src, randomItem, price, amount)
    local player = Core.Functions.GetPlayer(src)
    local items = Framework:GetItem(src, randomItem.item, nil, false)
    
    -- Check if the item even exists in the player's inventory
    if items.count == 0 then 
        TriggerClientEvent("DoLongHudText", src, Lang:t("no_item"), "error") 
        return
    end
    
    -- Check if the player has fewer items than needed
    if items.count < amount then 
        -- Remove the remaining items from the player's inventory
        if ox:RemoveItem(src, randomItem.item, items.count) then 
            ox:AddItem(player.PlayerData.source, 'rolled_cash', price)
        end

        TriggerClientEvent("DoLongHudText", src, Lang:t("sell_last"), "success")
    end
end

