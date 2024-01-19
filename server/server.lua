local playersHealing, deadPlayers = {}, {}
local ambulancesConnected = 0

TriggerEvent('esx_phone:registerNumber', Config.JobName, ('Alerte ambulance'), true, true)
TriggerEvent('esx_society:registerSociety', Config.JobName, 'Ambulance', Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'public'})

if Config.Defibrilateur then 
	function CountAmbulances()
		local xPlayers = ESX.GetPlayers()
		ambulancesConnected = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == Config.JobName then
				ambulancesConnected = ambulancesConnected + 1
			end
		end
		SetTimeout(5000, CountAmbulances)
	end

	CountAmbulances()

	RegisterServerEvent('defib:getAmbulancesCount')
	AddEventHandler('defib:getAmbulancesCount', function()
		TriggerClientEvent('defib:useDefib', source, ambulancesConnected)
	end)
end

RegisterServerEvent('eAmbulance:revive')
AddEventHandler('eAmbulance:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if xPlayer.job.name == 'ambulance' then
        local societyAccount = nil
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
            societyAccount = account
        end)
        if societyAccount ~= nil then
            xPlayer.addMoney(Config.ReviveReward)
            TriggerClientEvent('eAmbulance:revive', target)
            societyAccount.addMoney(150)
            print('150$ ajouté')
        end
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('eAmbulance:notif', xPlayers[i])
            end
        end
    else
        print(('eAmbulance: %s attempted to revive!'):format(xPlayer.identifier))
    end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
	TriggerClientEvent('eAmbulance:setDeadPlayers', -1, deadPlayers)
end)

RegisterServerEvent('eAmbulance:svsearch')
AddEventHandler('eAmbulance:svsearch', function()
  TriggerClientEvent('eAmbulance:clsearch', -1, source)
end)

RegisterNetEvent('eAmbulance:onPlayerDistress')
AddEventHandler('eAmbulance:onPlayerDistress', function()
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		TriggerClientEvent('eAmbulance:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
		TriggerClientEvent('eAmbulance:setDeadPlayers', -1, deadPlayers)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		TriggerClientEvent('eAmbulance:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('eAmbulance:heal')
AddEventHandler('eAmbulance:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == Config.JobName then
		TriggerClientEvent('eAmbulance:heal', target, type)
	end
end)

ESX.RegisterServerCallback('eAmbulance:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('eAmbulance:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterNetEvent('eAmbulance:payFine')
	AddEventHandler('eAmbulance:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		xPlayer.removeAccountMoney('bank', fineAmount)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez payé "..fineAmount.."$ pour être réanimer.")
		eLogsDiscord("[Réanimation-Unité-X] "..xPlayer.getName().." a payé "..fineAmount.."$ pour être réanimer.", Config.logs.Reanimation)	
	end)
end

ESX.RegisterServerCallback('eAmbulance:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

if Config.Framework == "esx" then
	TriggerEvent('es:addGroupCommand', 'revive', Config.GradeForRevive, function(source, args, user)
		local src = source 
		local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] ~= nil then
			if GetPlayerName(tonumber(args[1])) ~= nil then
				eLogsDiscord("[Réanimation-staff] "..xPlayer.getName().." a réanimé "..GetPlayerName(tonumber(args[1])), Config.logs.Reanimation)		
				TriggerClientEvent('eAmbulance:revive', tonumber(args[1]))
			end
		else
			TriggerClientEvent('eAmbulance:revive', source)
		end
	end, function(source, args, user)
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end, { help = "Réanimer un joueur", params = { { name = 'id'} } })
elseif Config.Framework == "newEsx" then 
	ESX.RegisterCommand('revive', Config.GradeForRevive, function(xPlayer, args, showError)
		args.playerId.triggerEvent('eAmbulance:revive')
	end, true, {help = 'Réanimer un joueur', validate = true, arguments = {
		{name = 'playerId', help = 'The player id', type = 'player'}
	}})
end


ESX.RegisterServerCallback('eAmbulance:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
				
		if isDead then
			print(('[eAmbulance] [^2INFO^7] "%s" attempted combat logging'):format(xPlayer.identifier))
		end

		cb(isDead)
	end)
end)

RegisterNetEvent('eAmbulance:setDeathStatus')
AddEventHandler('eAmbulance:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) == 'boolean' then
		MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})
	end
end)

RegisterServerEvent('eAmbulance:firstSpawn')
AddEventHandler('eAmbulance:firstSpawn', function()
	local _source    = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier=@identifier',
	{
		['@identifier'] = identifier
	}, function(isDead)
		if isDead == 1 then
			print('eAmbulance: ' .. GetPlayerName(_source) .. ' (' .. identifier .. ') attempted combat logging!')
			TriggerClientEvent('eAmbulance:requestDeath', _source)
		end
	end)
end)

ESX.RegisterServerCallback('eAmbulance:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('eAmbulance:putStockItems')
AddEventHandler('eAmbulance:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
			eLogsDiscord("[COFFRE] "..xPlayer.getName().." a déposé "..count.." "..inventoryItem.label.." dans le coffre", Config.logs.CoffreObjets)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('eAmbulance:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('eAmbulance:getStockItem')
AddEventHandler('eAmbulance:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
				eLogsDiscord("[COFFRE] "..xPlayer.getName().." a retiré "..count.." "..inventoryItem.label.." du coffre", Config.logs.CoffreObjets)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

RegisterServerEvent('AmbulanceDispo')
AddEventHandler('AmbulanceDispo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>Ambulance', '<C>~b~Informations', '<C>Un ambulancier a pris son service ! EMS ~g~disponible', 'CHAR_CHAT_CALL', 2)
		eLogsDiscord("[Annonce] **"..xPlayer.getName().."** a annoncer sa prise de service à l'ensemble de la ville", Config.logs.annonces)
	end
end)

RegisterServerEvent('AmbulancePasDispo')
AddEventHandler('AmbulancePasDispo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>Ambulance', '<C>~b~Informations', '<C>Un ambulancier à quitter son service ! EMS ~r~non disponible', 'CHAR_CHAT_CALL', 2)
		eLogsDiscord("[Annonce] **"..xPlayer.getName().."** a annoncer sa fin de service à l'ensemble de la ville", Config.logs.annonces)
	end
end)

RegisterServerEvent('AmbulanceRecrutement')
AddEventHandler('AmbulanceRecrutement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>Ambulance', '<C>~b~Recrutement', '<C>Le service national de santé recrute ! Presentez vous à l\'acceuil du batiment', 'CHAR_CHAT_CALL', 8)
		eLogsDiscord("[Annonce] **"..xPlayer.getName().."** a annoncer que les "..Config.PrefixName.." recrute", Config.logs.annonces)
	end
end)

RegisterCommand('ems', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == Config.JobName then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>Ambulance', '<C>~b~Informations', ''..msg..'', 'CHAR_CHAT_CALL', 0)
			eLogsDiscord("[Annonce] **"..xPlayer.getName().."** a fait une annonce perso << "..msg.." >>", Config.logs.annonces)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , '~b~EMS pour faire cette commande', 'CHAR_WENDY', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , '~b~EMS pour faire cette commande', 'CHAR_WENDY', 0)
    end
end, false)

local appelTable = {}

RegisterNetEvent('eAmbulance:envoyersingal')
AddEventHandler('eAmbulance:envoyersingal', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local NomDuMec = xPlayer.getName()
    local idDuMec = source
    table.insert(appelTable, {
        id = source,
        nom = NomDuMec,
        args = "Appel EMS",
        gps = coords
    })
end)

ESX.RegisterServerCallback('eAmbulance:infoReport', function(source, cb)
    cb(appelTable)
end)

RegisterServerEvent("eAmbulance:emsAppel")
AddEventHandler("eAmbulance:emsAppel", function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == Config.JobName then
            TriggerClientEvent("eAmbulance:envoielanotif", xPlayers[i])
        end
end
end)

RegisterServerEvent("eAmbulance:CloseReport")
AddEventHandler("eAmbulance:CloseReport", function(nom, raison)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == Config.JobName then
            TriggerClientEvent("eAmbulance:envoielanotifclose", xPlayers[i], nom)
        end
end
    table.remove(appelTable, id, nom, args, gps)
end)

ESX.RegisterServerCallback('eAmbulance:checkitem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)

    local item = item   
    
    local item_in_inventory = xPlayer.getInventoryItem(item).count

        
    if item_in_inventory > 0 then        
        cb(true)
    else
        TriggerClientEvent("esx:ShowNotification", xPlayer, "<C>~r~Vous n'en n'avez pas sur vous !")
        cb(false)
    end

end)

RegisterNetEvent("eAmbulance:delitem")
AddEventHandler("eAmbulance:delitem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)

RegisterNetEvent('eAmbulance:BuyShop')
AddEventHandler('eAmbulance:BuyShop', function(item, amount, price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)

	if Config.PharmacieSociety then 
		TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function (account)
			if account.money >= price then
			account.removeMoney(price)
			xPlayer.addInventoryItem(item, amount)
			TriggerClientEvent('esx:showNotification', source, "<C>Vous avez reçu votre "..item.." pour ~g~"..price.."$ avec l'argent de la société")
			eLogsDiscord("[Achat-Société-Pharmacie] **"..xPlayer.getName().."** a acheter **"..item.." pour ~g~"..price.."$ avec l'argent de l'entreprise EMS**", Config.logs.shop)
			else
			TriggerClientEvent('esx:showNotification', source, "<C>Il manque ~r~"..price.."~s~$ dans la société")
			end
		end)
	else
		xPlayer.addInventoryItem(item, amount)
		xPlayer.removeMoney(price)
        TriggerClientEvent('esx:showNotification', source, "<C>Vous avez retirer un "..item.." pour "..price.."$")
		eLogsDiscord("[Achat-Pharmacie] **"..xPlayer.getName().."** a acheter **"..item.." pour ~g~"..price.."$ avec son argent**", Config.logs.shop)
	end

end)

ESX.RegisterServerCallback('eAmbulance:getEnosStatus', function(source, cb, id, statusName)
	local xPlayer = ESX.GetPlayerFromId(id)
	local status  = xPlayer.get('status')
	print(id)

	for i=1, #status, 1 do
			if status[i].name == statusName then
			cb(status[i])
			break
			end
	end
end)

RegisterNetEvent("ambu:ficheGet")
AddEventHandler("ambu:ficheGet", function()
    local _src = source
    local table = {}
    MySQL.Async.fetchAll('SELECT * FROM fiche_medical', {}, function(result)
        for k,v in pairs(result) do
            table[v.id] = v
        end
        TriggerClientEvent("ambu:ficheGet", _src, table)
    end)
end)

RegisterNetEvent("ambu:ficheDel")
AddEventHandler("ambu:ficheDel", function(id)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local name = xPlayer.getName(_src)
    MySQL.Async.execute('DELETE FROM fiche_medical WHERE id = @id',
    { ['id'] = id },
    function(affectedRows)
        TriggerClientEvent("ambu:ficheDel", _src)
		eLogsDiscord("[Fiche-Medic] "..name.." a **supprimer** une fiche médicale dans la base de données", Config.logs.FicheMedical)
    end
    )
end)

RegisterNetEvent("ambu:ficheAdd")
AddEventHandler("ambu:ficheAdd", function(builder)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local name = xPlayer.getName(_src)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO fiche_medical (author,date,firstname,lastname,reason) VALUES (@a,@b,@c,@d,@e)',

    { 
        ['a'] = name,
        ['b'] = date,
        ['c'] = builder.firstname,
        ['d'] = builder.lastname,
        ['e'] = builder.reason
    },

    function(affectedRows)
        TriggerClientEvent("ambu:ficheAdd", _src)
		eLogsDiscord("[Fiche-Medic] "..name.." a **ajouter** une fiche médicale dans la base de données", Config.logs.FicheMedical)
    end
    )
end)

RegisterNetEvent("ambu:FicheModify")
AddEventHandler("ambu:FicheModify", function(builder, id, newreason)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local name = xPlayer.getName(_src)

	MySQL.Async.execute('UPDATE fiche_medical SET reason = @reason WHERE id = @id', {
		['@id'] = id,
		['@reason'] = builder.newreason
	},
    function(affectedRows)
        TriggerClientEvent("ambu:FicheModify", _src)
		eLogsDiscord("[Fiche-Medic] "..name.." a **modifier** une fiche médicale dans la base de données", Config.logs.FicheMedical)
    end
	)
end)

if Config.Defibrilateur then 
	ESX.RegisterUsableItem('medikit', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		CountAmbulances()
		CountAmbulances = ambulancesConnected
		TriggerClientEvent('defib:useDefib', source, ambulancesConnected)
	end)
end

function eLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.logs.NameLogs, content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('eEMS:logsEvent')
AddEventHandler('eEMS:logsEvent', function(message, url)
	eLogsDiscord(message,url)
end)

ESX.RegisterServerCallback('eAmbulance:getMoneySociety', function(source, cb, priceCar)
	local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
		societyAccount = account
	end)
	if societyAccount ~= nil then
		if societyAccount.money >= priceCar then
			societyAccount.removeMoney(priceCar)
			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
end)

RegisterNetEvent("eAmbulance:sendcall")
AddEventHandler("eAmbulance:sendcall", function()

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == Config.JobName then
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "<C>Central "..Config.PrefixName, nil, "<C>Un Citoyen demande un "..Config.PrefixName.." à l'hopital", "CHAR_CALL911", 8)
			eLogsDiscord("[INTERACTION] Un Citoyen demande un "..Config.PrefixName.." à l'hopital", Config.logs.AcceuilAmbulance)
		end
	end
end)

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "eAmbulance by Enøs",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


RegisterNetEvent("eAmbulance:sendDemande")
AddEventHandler("eAmbulance:sendDemande", function(lastname, firstname,phone, subject, desc)

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == Config.JobName then
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "<C>~r~Central "..Config.PrefixName, nil, "<C>Une Plainte à était déposer", "CHAR_CHAT_CALL", 8)
		end
	end
	sendToDiscordWithSpecialURL("Central "..Config.PrefixName,"Demande émise par: __"..lastname.." "..firstname.. "__ \n\nTél: **__"..phone.."__**\n\nSujet: **__"..subject.."__**\n\nDemande: "..desc, 2061822, Config.logs.AcceuilAmbulance)
end)


RegisterServerEvent('eAmbulance:PriseEtFinservice')
AddEventHandler('eAmbulance:PriseEtFinservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local identifier = GetPlayerIdentifier(_source)
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('eAmbulance:InfoService', xPlayers[i], _raison, name)
		end
	end
end)

RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords)
		end
	end
end)