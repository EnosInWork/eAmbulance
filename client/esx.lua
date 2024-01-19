if Config.Framework == "esx" then
	ESX = nil
	Citizen.CreateThread(function()
		while ESX == nil do
		  TriggerEvent(Config.esxGet, function(obj) ESX = obj end)
		  Citizen.Wait(0)
		  PlayerData = ESX.GetPlayerData()
		end
	end)
elseif Config.Framework == "newEsx" then 
    ESX = exports["es_extended"]:getSharedObject()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)