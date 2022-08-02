ESX = nil

TriggerEvent(Config.esxGet, function(obj) ESX = obj end)

RegisterServerEvent('eAmbulance:recruter')
AddEventHandler('eAmbulance:recruter', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob(Config.JobName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été recruté")
  	TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue chez les EMS !")
	  eLogsDiscord("[RECRUTEMENT] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron...")
end
  else
  	if xPlayer.job2.grade_name == 'boss' then
  	xTarget.setJob2(Config.JobName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été recruté")
  	TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue chez les EMS !")
	  eLogsDiscord("[RECRUTEMENT] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron...")
end
  end
end)

RegisterServerEvent('eAmbulance:promouvoir')
AddEventHandler('eAmbulance:promouvoir', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.JobName, tonumber(xTarget.job.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été promu")
  	TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été promu chez les EMS!")
	  eLogsDiscord("[PROMOTION] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être promu")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.JobName, tonumber(xTarget.job2.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été promu")
  	TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été promu chez les EMS!")
	  eLogsDiscord("[PROMOTION] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être promu")
end
  end
end)

RegisterServerEvent('eAmbulance:descendre')
AddEventHandler('eAmbulance:descendre', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.JobName, tonumber(xTarget.job.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été rétrogradé")
  	TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été rétrogradé des "..Config.PrefixName.."!")
	  eLogsDiscord("[RETROGRADE] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être promu")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.JobName, tonumber(xTarget.job2.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été rétrogradé")
  	TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été rétrogradé des "..Config.PrefixName.."!")
	  eLogsDiscord("[RETROGRADE] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être promu")
end
  end
end)

RegisterServerEvent('eAmbulance:virer')
AddEventHandler('eAmbulance:virer', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)
  
  if job2 == false then
        if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
            xTarget.setJob("unemployed", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été viré")
            TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été viré des "..Config.PrefixName.."!")
            eLogsDiscord("[VIREMENT] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être viré")
        end
    else
        if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
            xTarget.setJob2("unemployed2", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>Le joueur a été viré")
            TriggerClientEvent('esx:showNotification', target, "<C>Vous avez été viré des "..Config.PrefixName.."!")
            eLogsDiscord("[VIREMENT] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
  	    else
	        TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>t'es pas patron ou alors le joueur ne peut pas être viré")
        end
    end
end)

RegisterServerEvent("eAmbulance:retraitentreprise")
AddEventHandler("eAmbulance:retraitentreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getAccount("bank").money
	
	TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, '<C>Banque Société', '<C>~b~L.S.P.D', "<C>~g~Vous avez retiré "..total.." $ de votre entreprise", 'CHAR_BANK_FLEECA', 10)
		else
			TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d\'argent dans votre entreprise!")
		end
	end)
end) 
  
RegisterServerEvent("eAmbulance:depotentreprise")
AddEventHandler("eAmbulance:depotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
    
    TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
            TriggerClientEvent('esx:showAdvancedNotification', source, '<C>Banque Société', '<C>~b~L.S.P.D', "<C>~g~Vous avez déposé "..total.." $ dans votre entreprise", 'CHAR_BANK_FLEECA', 10)
        else
            TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d\'argent !")
        end
    end)   
end)

ESX.RegisterServerCallback('eAmbulance:getSocietyMoney', function(source, cb, societyName)
	if societyName ~= nil then
	  local society = Config.SocietyName
	  TriggerEvent('esx_addonaccount:getSharedAccount', "society_ambulance", function(account)
		cb(account.money)
	  end)
	else
	  cb(0)
	end
end)