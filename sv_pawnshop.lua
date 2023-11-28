local ESX = exports['es_extended']:getSharedObject()
local logit = ''-- WEBHOOK
-----------------------------------
-- # MAUNOMATO KOODIA VITTU GN # --
-----------------------------------
RegisterServerEvent('s_pawnshop_osta')
AddEventHandler('s_pawnshop_osta', function(item, hinta, maara)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= hinta then
        xPlayer.removeMoney(maara * hinta)
        xPlayer.addInventoryItem(item, maara)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ostit ' .. item .. ' hintaan ' .. maara * hinta ..'$', length = 5000, style = { ['background-color'] = '', ['color'] = '' } })
        LOGI("**Panttilainaamo**\n\n**Pelaaja:** " .. GetPlayerName(source) .. "\n**Osti:** " .. item .. "\n**Hintaan:** " ..  maara * hinta .. '$', 2854655) 
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sinulla ei ole tarpeeksi rahaa!', length = 5000, style = { ['background-color'] = '', ['color'] = '' } })
    end
end)


RegisterServerEvent('s_pawnshop_myy')
AddEventHandler('s_pawnshop_myy', function(item, hinta)
    local xPlayer = ESX.GetPlayerFromId(source)

    local inventoryItem = xPlayer.getInventoryItem(item)

    if inventoryItem.count > 0 then
        xPlayer.addMoney(hinta * inventoryItem.count)
        xPlayer.removeInventoryItem(item, inventoryItem.count)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Myit ' .. inventoryItem.count .. 'x '..item..'\nhintaan: ' ..hinta * inventoryItem.count.. '$', length = 5000, style = { ['background-color'] = '', ['color'] = '' } })
        LOGI("**Panttilainaamo**\n\n**Pelaaja:** " .. GetPlayerName(source) .. "\n**Myytiin:** " .. inventoryItem.count .. "x " .. item .. '\n **Hintaan: **' ..hinta * inventoryItem.count.. '$', 16776960) 
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sinulla ei ole tarpeeksi tavaroita!', length = 5000, style = { ['background-color'] = '', ['color'] = '' } })
    end
end)

-- ## LOG ## --
function LOGI(message, color)
	local connect = {  {  ["description"] = message, ["color"] = color, ["footer"] = { ["text"] = os.date("Info:\n📅 %d.%m.%Y \n⏰ %X"), }, } }
	PerformHttpRequest(logit, function(err, text, headers) end, 'POST', json.encode({username = 'Snooppikoira', embeds = connect, avatar_url = 'https://cdn.discordapp.com/attachments/1153618830304759849/1167479001984544920/Snooppikoira_1.png?ex=654e468c&is=653bd18c&hm=443eaa5d5e13f9199fced50c53a00c03b72ef2930a6fa32156a6db8d429709f4&'}), { ['Content-Type'] = 'application/json' })
end