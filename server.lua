local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj  end)

ESX.RegisterServerCallback("Admin:getRankFromPlayer", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

function sendToDiscord(color, name, title, message, footer)
	local embed = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. title .."**",
			  ["description"] = message,
			  ["footer"] = {
				  ["text"] = footer,
			  },
		  }
	  }  
	PerformHttpRequest('https://discord.com/api/webhooks/800733122747695155/CBpfHtN758Y-n2C7fee3Zv740qWty3Gxnh2WpCqr_4fCyFW0Ke6HM1k5mwlZCvklJXWk', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('bringplayertome')
AddEventHandler('bringplayertome', function(target,x,y,z)
    TriggerClientEvent('teleport', target, x, y, z)
end)


RegisterServerEvent('reloadchar')
AddEventHandler('reloadchar', function(target)
    TriggerClientEvent('rw:setplayerinclouds', target)
    Wait(500)
    TriggerClientEvent('rw:endjoinsession', target)
end)

local ticketData = {}

RegisterServerEvent('rw:closeTicket')
AddEventHandler('rw:closeTicket', function(id)
    TriggerClientEvent('notifications', ticketData[id]["id"], "#1df5fc", "TICKETSYSTEM", "Dein Ticket wurde geschlossen.")
    TriggerClientEvent('notifications', source, "#1df5fc", "TICKETSYSTEM", "Du hast das Ticket geschlossen.")
    ticketData[id] = nil
end)

RegisterCommand("supportcancel", function(source, args)
    TriggerClientEvent('notifications', source, "#1df5fc", "TICKETSYSTEM", "Du hast deine Tickets geschlossen.")
    for k, v in pairs(ticketData) do
        if k ~= nil then
            if ticketData[k]["id"] == source then
                ticketData[k] = nil
            end
        end
    end
end, false)

RegisterServerEvent('rw:loadSupportAPP')
AddEventHandler('rw:loadSupportAPP', function()
    for k, v in pairs(ticketData) do
        if k ~= nil then
            TriggerClientEvent('rw:addTicket', source, ticketData[k]["name"], ticketData[k]["id"], ticketData[k]["msg"], tostring(k))
        end
    end
end)

RegisterServerEvent('sendticket')
AddEventHandler('sendticket', function(msg)
    ticketData[math.random(100,999)] = {["msg"] = msg, ["name"] = GetPlayerName(source), ["id"] = source}
    TriggerClientEvent('adminnotify', -1, msg, GetPlayerName(source) .. " | ID: " .. source)
    sendToDiscord("12745742", "Ticketsystem", GetPlayerName(source) .." | ID: ".. source .."", "\n**Grund:** "..msg, "Ticketsystem v1.0 by EvolutionLife")
    TriggerClientEvent('rw:addTicket', -1, GetPlayerName(source), source, msg, "/")
end)

RegisterServerEvent('tc')
AddEventHandler('tc', function(msg)
    TriggerClientEvent('adminnotify2', -1, msg, GetPlayerName(source) .. " | ID: " .. source)
end)


ESX.RegisterServerCallback('rw:getGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getGroup())
end)

RegisterCommand("aduty", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "support" or xPlayer.getGroup() == "_dev" then
        TriggerClientEvent('toggleAduty', source)
    else
        TriggerClientEvent('notifications', source, "#1df5fc", "Admindienst", "Du hast keine Rechte.")
    end
end, false)

TriggerEvent("es:addGroupCommand", "ad", "superadmin", function(source, args)
    TriggerClientEvent("toggleAduty", source)
end, function(source, args)
    TriggerEvent('notifications', "#1df5fc", "ENTWICKLER-MODUS", "Keine Rechte.")
end)

TriggerEvent("es:addGroupCommand", "cmduty", "mod", function(source, args)
    TriggerClientEvent("toggleAduty", source)
end, function(source, args)
    TriggerEvent('notifications', "#1df5fc", "ADMINISTRATION", "Keine Rechte.")
end)

TriggerEvent("es:addGroupCommand", "saduty", "admin", function(source, args)
    TriggerClientEvent("toggleAduty", source)
end, function(source, args)
    TriggerEvent('notifications', "#1df5fc", "ADMINISTRATION", "Keine Rechte.")
end)

