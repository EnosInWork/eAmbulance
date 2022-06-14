ESX = nil

TriggerEvent(Config.esxGet, function(obj) ESX = obj end)

ESX.RegisterServerCallback('eAmbulance:getVehGarage', function(source, cb, carName)
	MySQL.Async.fetchAll("SELECT * FROM stockambulance WHERE type = @type AND model = @model", {['@type'] = "car", ['@model'] = carName}, function(data)
        cb(#data)
    end)
end)

ESX.RegisterServerCallback('eAmbulance:getVehGarageN', function(source, cb, carName)
	MySQL.Async.fetchAll("SELECT * FROM stockambulanceN WHERE type = @type AND model = @model", {['@type'] = "car", ['@model'] = carName}, function(data)
        cb(#data)
    end)
end)

RegisterServerEvent('eAmbulance:addVehInGarage')
AddEventHandler('eAmbulance:addVehInGarage', function(carName)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.job.name == 'ambulance' then
		MySQL.Async.execute('INSERT INTO stockambulance (type, model) VALUES (@type, @model)', {
			['@type'] = "car",
			['@model'] = carName
		})


		rxeLogsDiscord("[AJOUT VEHICULE] **"..xPlayer.getName().."** a ajouté un véhicule **"..carName.."** au garage", Config.logs.Boss)
	end
end)

RegisterServerEvent('eAmbulance:addVehInGarageN')
AddEventHandler('eAmbulance:addVehInGarageN', function(carName)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.job.name == 'ambulance' then
		MySQL.Async.execute('INSERT INTO stockambulanceN (type, model) VALUES (@type, @model)', {
			['@type'] = "car",
			['@model'] = carName
		})


		rxeLogsDiscord("[AJOUT VEHICULE] **"..xPlayer.getName().."** a ajouté un véhicule **"..carName.."** au garage", Config.logs.Boss)
	end
end)

RegisterServerEvent('eAmbulance:removeVehInGarage')
AddEventHandler('eAmbulance:removeVehInGarage', function(carName)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.job.name == 'ambulance' then
	    MySQL.Async.fetchAll("SELECT * FROM stockambulance WHERE type = @type AND model = @model", {['@type'] = "car", ['@model'] = carName}, function(data)
		MySQL.Async.execute('DELETE FROM stockambulance WHERE type = @type AND model = @model AND id = @id', {
			['@id'] = data[1].id,
			['@type'] = "car",
			['@model'] = carName
		})
		end)

		rxeLogsDiscord("[SUPP VEHICULE] **"..xPlayer.getName().."** a supprimé un véhicule **"..carName.."** du garage", Config.logs.Boss)
    end
end)

RegisterServerEvent('eAmbulance:removeVehInGarageN')
AddEventHandler('eAmbulance:removeVehInGarageN', function(carName)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.job.name == 'ambulance' then
	    MySQL.Async.fetchAll("SELECT * FROM stockambulanceN WHERE type = @type AND model = @model", {['@type'] = "car", ['@model'] = carName}, function(data)
		MySQL.Async.execute('DELETE FROM stockambulanceN WHERE type = @type AND model = @model AND id = @id', {
			['@id'] = data[1].id,
			['@type'] = "car",
			['@model'] = carName
		})
		end)

		rxeLogsDiscord("[SUPP VEHICULE] **"..xPlayer.getName().."** a supprimé un véhicule **"..carName.."** du garage", Config.logs.Boss)
    end
end)