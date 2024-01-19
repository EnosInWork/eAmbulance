local firstSpawn = true

local lit_1 = {
    {anim = "savecouch@",lib = "t_sleep_loop_couch",name = Config.Language.anim.lie_back, x = 0, y = 0, z = 0.7, r = 180.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_right, x = 0.3, y = -0.2, z =0.15, r = -90.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_left, x = -0.25, y = -0.2, z =0.15, r = 90.0},
	{anim = "missheistfbi3b_ig8_2",lib = "cpr_loop_victim",name = Config.Language.anim.convulse, x = -0.1, y = 0, z = 1.2, r = 180.0},
	{anim = "amb@world_human_bum_slumped@male@laying_on_right_side@base",lib = "base",name = Config.Language.anim.pls, x = 0.2, y = 0.1, z = 1.2, r = 90.0},
}

local lit_2 = {
    {anim = "savecouch@",lib = "t_sleep_loop_couch",name = Config.Language.anim.lie_back, x = 0, y = 0, z = 0.9, r = 180.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_right, x = 0.2, y = -0.2, z =0.35, r = -90.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_left, x = -0.3, y = -0.2, z =0.35, r = 90.0},
	{anim = "missheistfbi3b_ig8_2",lib = "cpr_loop_victim",name = Config.Language.anim.convulse, x = -0.1, y = 0, z = 1.35, r = 180.0},
	{anim = "amb@world_human_bum_slumped@male@laying_on_right_side@base",lib = "base",name = Config.Language.anim.pls, x = 0.2, y = 0.1, z = 1.35, r = 90.0},
}

local lit_3 = {
    {anim = "savecouch@",lib = "t_sleep_loop_couch",name = Config.Language.anim.lie_back, x = 0, y = 0, z = 0.9, r = 180.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_right, x = 0.2, y = -0.2, z =0.35, r = -90.0},
	{anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_left, x = -0.3, y = -0.2, z =0.35, r = 90.0},
	{anim = "missheistfbi3b_ig8_2",lib = "cpr_loop_victim",name = Config.Language.anim.convulse, x = -0.1, y = 0, z = 1.35, r = 180.0},
	{anim = "amb@world_human_bum_slumped@male@laying_on_right_side@base",lib = "base",name = Config.Language.anim.pls, x = 0.2, y = 0.1, z = 1.35, r = 90.0},
}

local lit = {
	{lit = "v_med_emptybed", distance_stop = 3.4, name = lit_1, title = Config.Language.lit_1},
	{lit = "v_med_bed1", distance_stop = 3.4, name = lit_2, title = Config.Language.lit_2},
	{lit = "v_med_bed2", distance_stop = 3.4, name = lit_3, title = Config.Language.lit_3},
}

prop_amb = false
veh_detect = 0
isDead, isSearched, medic = false, false, 0

AddEventHandler("onClientMapStart", function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(5000)
	exports.spawnmanager:setAutoSpawn(false)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
	firstSpawn = true
end)

AddEventHandler('playerSpawned', function()
	IsDead = false

	if FirstSpawn then
		TriggerServerEvent('eAmbulance:firstSpawn')
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		FirstSpawn = false
	end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
end

function setNotHurt()
    hurt = false
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end

AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false

	if firstSpawn then
		firstSpawn = false

		if Config.AntiCombatLog then
			while not PlayerLoaded do
				Citizen.Wait(1000)
			end

			ESX.TriggerServerCallback('eAmbulance:getDeathStatus', function(shouldDie)
			end)
		end
	end
end)

Citizen.CreateThread(function()
	prop_exist = 0
	while true do
		wait = 800

		for _,g in pairs(Config.Hash) do
			local closestObject = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), 7.0, GetHashKey(g.hash), 18)
			if closestObject ~= 0 then
				veh_detect = closestObject
				veh_detection = g.detection
				prop_depth = g.depth
				prop_height = g.height
			end
		end

		if prop_amb == false then
			if GetVehiclePedIsIn(GetPlayerPed(-1)) == 0 then
				if DoesEntityExist(veh_detect) then
					wait = 0
					local coords = GetEntityCoords(veh_detect) + GetEntityForwardVector(veh_detect) * - veh_detection

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x , coords.y, coords.z, true) <= 1.0 then

						hintToDisplay(Config.Language.out_vehicle_bed.."\n"..Config.Language.out_vehicle_wheelchair)

						for _,m in pairs(lit) do
							local prop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 4.0, GetHashKey(m.lit))
							if prop ~= 0 then
								prop_exist = prop
							end
						end

						if IsControlJustPressed(0, Config.Press.out_vehicle_wheelchair) then
							ExecuteCommand("wheelchair")
						end

						if IsEntityAttachedToEntity(prop, GetPlayerPed(-1)) ~= 0 or prop ~= 0 then
							if IsControlJustPressed(0, Config.Press.out_vehicle_bed) then
								while not HasModelLoaded("v_med_emptybed") do
									RequestModel("v_med_emptybed")
									Citizen.Wait(1)
								end
								local object = CreateObject(GetHashKey("v_med_emptybed"), GetEntityCoords(GetPlayerPed(-1)), true)
								SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)) - 180.0)
								prendre(object, vehicle)
								prop_exist = 0
							end
						end
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

function prendre(propObject, hash)
	NetworkRequestControlOfEntity(propObject)

	LoadAnim("anim@heists@box_carry@")
	
	AttachEntityToEntity(propObject, GetPlayerPed(-1), GetPlayerPed(-1), 0.0, 1.6, -0.43 , 180.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(propObject, GetPlayerPed(-1)) do

		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(GetPlayerPed(-1)) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			DetachEntity(propObject, true, true)
		end
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(veh_detect), true) <= 7.0 then
			hintToDisplay(Config.Language.in_vehicle_bed)
			if (IsControlJustPressed(0, Config.Press.in_vehicle_bed)) then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				DetachEntity(propObject, true, true)
				prop_amb = true
				in_ambulance(propObject, veh_detect, prop_depth, prop_height)
			end
		else
			hintToDisplay(Config.Language.release_bed)
		end

		if IsControlJustPressed(0, Config.Press.release_bed) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			DetachEntity(propObject, true, true)
		end
		
	end
end

function in_ambulance(propObject, amb, depth, height)
	veh_detect = 0
	NetworkRequestControlOfEntity(amb)

	AttachEntityToEntity(propObject, amb, 0.0, 0.0, depth, height, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(propObject, amb) do
		Citizen.Wait(5)

		if GetVehiclePedIsIn(GetPlayerPed(-1)) == 0 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(amb), true) <= 7.0 then
				hintToDisplay(Config.Language.out_vehicle_bed)
				if IsControlJustPressed(0, Config.Press.out_vehicle_bed) then
					DetachEntity(propObject, true, true)
					prop_amb = false
					SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)) - 180.0)
					prendre(propObject)
				end
			end
		end
	end
end

local function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


local function cooldowncool(time)
	cooldown = true
	Citizen.SetTimeout(time,function()
		cooldown = false
	end)
end

Citizen.CreateThread(function()

	while true do
		local sleep = 2000	
		local pedCoords = GetEntityCoords(GetPlayerPed(-1))
		for _,i in pairs(lit) do
			local closestObject = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(i.lit), false)
	
			if DoesEntityExist(closestObject) then
				sleep = 5
				local propCoords = GetEntityCoords(closestObject)
				local propForward = GetEntityForwardVector(closestObject)
				local litCoords = (propCoords + propForward)
				local sitCoords = (propCoords + propForward * 0.1)
				local pickupCoords = (propCoords + propForward * 1.2)
				local pickupCoords2 = (propCoords + propForward * - 1.2)

				if GetDistanceBetweenCoords(pedCoords, litCoords, true) <= 5.0 then
					if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 1.4 then
						hintToDisplay(Config.Language.do_action)
						if IsControlJustPressed(0, Config.Press.do_action) then
							Ambulancedeouf()
						end
					end
					if IsEntityAttachedToEntity(closestObject, GetPlayerPed(-1)) == false then
						if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 0.8 then
							hintToDisplay(Config.Language.take_bed)
							if IsControlJustPressed(0, Config.Press.take_bed) then
								prendre(closestObject)
							end
						end

						if GetDistanceBetweenCoords(pedCoords, pickupCoords2, true) <= 0.8 then
							hintToDisplay(Config.Language.take_bed)
							if IsControlJustPressed(0, Config.Press.take_bed) then
								prendre(closestObject)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
		else
			Citizen.Wait(800)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		wait = 800
		if isDead and isSearched then
			wait = 0
			local playerPed = PlayerPedId()
			local ped = GetPlayerPed(GetPlayerFromServerId(medic))
			isSearched = false

			AttachEntityToEntity(playerPed, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			Citizen.Wait(1000)
			DetachEntity(playerPed, true, false)
			ClearPedTasksImmediately(playerPed)
		end
		Citizen.Wait(wait)
	end
end)

RegisterNetEvent('eAmbulance:clsearch')
AddEventHandler('eAmbulance:clsearch', function(medicId)
	local playerPed = PlayerPedId()

	if isDead then
		local coords = GetEntityCoords(playerPed)
		local playersInArea = ESX.Game.GetPlayersInArea(coords, 50.0)

		for i=1, #playersInArea, 1 do
			local player = playersInArea[i]
			if player == GetPlayerFromServerId(medicId) then
				medic = tonumber(medicId)
				isSearched = true
				break
			end
		end
	end
end)


function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	RageUI.CloseAll()
	Wait(100)
	TriggerServerEvent('eAmbulance:setDeathStatus', true)

	StartDeathTimer()
	StartDistressSignal()

	StartScreenEffect('DeathFailOut', 0, false)
end

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer
		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30
			SetTextFont(4)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			EndTextCommandDisplayText(0.199, 0.900)
			drawTxt(0.70, 1.40, 1.0, 1.0, 0.3, "Appuyez sur ~r~G~s~ pour envoyer un signal de détresse", 255, 255, 255, 255, false)
			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent("eAmbulance:envoielanotif")
AddEventHandler("eAmbulance:envoielanotif", function()
    ESX.ShowAdvancedNotification("EMS", "~b~Demande d'EMS", "Quelqu'un a besoin d'un ems ! Ouvrez votre Call-Center pour intervenir", "CHAR_CALL911", 8)
end)

RegisterNetEvent("eAmbulance:envoielanotifclose")
AddEventHandler("eAmbulance:envoielanotifclose", function(nom)
    ESX.ShowAdvancedNotification("EMS", "~b~Fermeture d'un appel", "L'appel de "..nom.." a été ferme par "..GetPlayerName(PlayerId()), "CHAR_CALL911", 8)
end)

function SendDistressSignal()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    ESX.ShowAdvancedNotification("Détresse", "~g~EMS", "Ta position a était envoyer aux "..Config.PrefixName.." en service", "CHAR_CALL911", 7)
    TriggerServerEvent('eAmbulance:envoyersingal', coords)
    TriggerServerEvent('eAmbulance:emsAppel')
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function minToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins
	end
end

function secToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('eAmbulance:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			drawTxt(0.53, 1.25, 1.0, 1.0, 0.6, "~o~Vous êtes inconscient", 255, 255, 255, 255, false)
			drawTxt(0.175, 0.850, 0, 0, 0.6, "Réanimation encore possible avant~b~ "..minToClock(earlySpawnTimer).." ~s~minutes et ~b~"..secToClock(earlySpawnTimer).." ~s~secondes", 255, 255, 255, 255, false)
			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			drawTxt(0.53, 1.25, 1.0, 1.0, 0.6, "~r~Vous êtes mort", 255, 255, 255, 255, false)
			drawTxt(0.18, 0.850, 0, 0, 0.6, "Vous allez être sortie de coma par l'unité X dans ~b~ "..minToClock(bleedoutTimer).." ~s~minutes et ~b~"..secToClock(bleedoutTimer).." ~s~secondes", 255, 255, 255, 255, false)

			if Config.EarlyRespawnFine and canPayFine then
				drawTxt(0.70, 1.42, 1.0, 1.0, 0.3, "Appuyez sur ~r~E~s~ pour être transporté de suite pour ~g~"..Config.EarlyRespawnFineAmount.."~s~$", 255, 255, 255, 255, false)
				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('eAmbulance:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()
			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end



function RemoveItemsAfterRPDeath()
	local playerPed = PlayerPedId()
	local coords = Config.RespawnPoint
	TriggerServerEvent('eAmbulance:setDeathStatus', false)
	setHurt()
	Citizen.CreateThread(function()
		DoScreenFadeOut(3000)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		local formattedCoords = {x = ESX.Math.Round(coords.x, 1),y = ESX.Math.Round(coords.y, 1),z = ESX.Math.Round(coords.z, 1)}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		DoScreenFadeIn(40000)
		DisplayRadar(false)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		local pedCoords = GetEntityCoords(GetPlayerPed(-1))
		for _,i in pairs(lit) do
		local closestObject = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(i.lit), false)
		if DoesEntityExist(closestObject) then
		local propCoords = GetEntityCoords(closestObject)
		local propForward = GetEntityForwardVector(closestObject)
		local litCoords = (propCoords + propForward)
		if GetDistanceBetweenCoords(pedCoords, litCoords, true) <= 5.0 then
		for _,k in pairs(i.name) do
		LoadAnim(k.anim)
		AttachEntityToEntity(GetPlayerPed(-1), closestObject, GetPlayerPed(-1), k.x, k.y, k.z, 0.0, 0.0, k.r, 0.0, false, false, false, false, 2, true)
		TaskPlayAnim(GetPlayerPed(-1), k.anim, k.lib, 8.0, 8.0, -1, 1, 0, false, false, false)
		end
		end
		end
		end
		cooldowncool(26000)
		Wait(5000)
		RageUI.Text({ message = "~r~Vous venez de sortir du coma\nVous ne vous souvenez plus du passé", time_display = 16000 })
		Wait(16000)
		StopScreenEffect('DeathFailOut')
		DisplayRadar(true)
		SetPedMotionBlur(playerPed, false)
		setNotHurt()
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAABp5JREFUWIW1l21sFNcVhp/58npn195de23Ha4Mh2EASSvk0CPVHmmCEI0RCTQMBKVVooxYoalBVCVokICWFVFVEFeKoUdNECkZQIlAoFGMhIkrBQGxHwhAcChjbeLcsYHvNfsx+zNz+MBDWNrYhzSvdP+e+c973XM2cc0dihFi9Yo6vSzN/63dqcwPZcnEwS9PDmYoE4IxZIj+ciBb2mteLwlZdfji+dXtNU2AkeaXhCGteLZ/X/IS64/RoR5mh9tFVAaMiAldKQUGiRzFp1wXJPj/YkxblbfFLT/tjq9/f1XD0sQyse2li7pdP5tYeLXXMMGUojAiWKeOodE1gqpmNfN2PFeoF00T2uLGKfZzTwhzqbaEmeYWAQ0K1oKIlfPb7t+7M37aruXvEBlYvnV7xz2ec/2jNs9kKooKNjlksiXhJfLqf1PXOIU9M8fmw/XgRu523eTNyhhu6xLjbSeOFC6EX3t3V9PmwBla9Vv7K7u85d3bpqlwVcvHn7B8iVX+IFQoNKdwfstuFtWoFvwp9zj5XL7nRlPXyudjS9z+u35tmuH/lu6dl7+vSVXmDUcpbX+skP65BxOOPJA4gjDicOM2PciejeTwcsYek1hyl6me5nhNnmwPXBhjYuGC699OpzoaAO0PbYJSy5vgt4idOPrJwf6QuX2FO0oOtqIgj9pDU5dCWrMlyvXf86xsGgHyPeLos83Brns1WFXLxxgVBorHpW4vfQ6KhkbUtCot6srns1TLPjNVr7+1J0PepVc92H/Eagkb7IsTWd4ZMaN+yCXv5zLRY9GQ9xuYtQz4nfreWGdH9dNlkfnGq5/kdO88ekwGan1B3mDJsdMxCqv5w2Iq0khLs48vSllrsG/Y5pfojNugzScnQXKBVA8hrX51ddHq0o6wwIlgS8Y7obZdUZVjOYLC6e3glWkBBVHC2RJ+w/qezCuT/2sV6Q5VYpowjvnf/iBJJqvpYBgBS+w6wVB5DLEOiTZHWy36nNheg0jUBs3PoJnMfyuOdAECqrZ3K7KcACGQp89RAtlysCphqZhPtRzYlcPx+ExklJUiq0le5omCfOGFAYn3qFKS/fZAWS7a3Y2wa+GJOEy4US+B3aaPUYJamj4oI5LA/jWQBt5HIK5+JfXzZsJVpXi/ac8+mxWIXWzAG4Wb4g/jscNMp63I4U5FcKaVvsNyFALokSA47Kx8PVk83OabCHZsiqwAKEpjmfUJIkoh/R+L9oTpjluhRkGSPG4A7EkS+Y3HZk0OXYpIVNy01P5yItnptDsvtIwr0SunqoVP1GG1taTHn1CloXm9aLBEIEDl/IS2W6rg+qIFEYR7+OJTesqJqYa95/VKBNOHLjDBZ8sDS2998a0Bs/F//gvu5Z9NivadOc/U3676pEsizBIN1jCYlhClL+ELJDrkobNUBfBZqQfMN305HAgnIeYi4OnYMh7q/AsAXSdXK+eH41sykxd+TV/AsXvR/MeARAttD9pSqF9nDNfSEoDQsb5O31zQFprcaV244JPY7bqG6Xd9K3C3ALgbfk3NzqNE6CdplZrVFL27eWR+UASb6479ULfhD5AzOlSuGFTE6OohebElbcb8fhxA4xEPUgdTK19hiNKCZgknB+Ep44E44d82cxqPPOKctCGXzTmsBXbV1j1S5XQhyHq6NvnABPylu46A7QmVLpP7w9pNz4IEb0YyOrnmjb8bjB129fDBRkDVj2ojFbYBnCHHb7HL+OC7KQXeEsmAiNrnTqLy3d3+s/bvlVmxpgffM1fyM5cfsPZLuK+YHnvHELl8eUlwV4BXim0r6QV+4gD9Nlnjbfg1vJGktbI5UbN/TcGmAAYDG84Gry/MLLl/zKouO2Xukq/YkCyuWYV5owTIGjhVFCPL6J7kLOTcH89ereF1r4qOsm3gjSevl85El1Z98cfhB3qBN9+dLp1fUTco+0OrVMnNjFuv0chYbBYT2HcBoa+8TALyWQOt/ImPHoFS9SI3WyRajgdt2mbJgIlbREplfveuLf/XXemjXX7v46ZxzPlfd8YlZ01My5MUEVdIY5rueYopw4fQHkbv7/rZkTw6JwjyalBCHur9iD9cI2mU0UzD3P9H6yZ1G5dt7Gwe96w07dl5fXj7vYqH2XsNovdTI6KMrlsAXhRyz7/C7FBO/DubdVq4nBLPaohcnBeMr3/2k4fhQ+Uc8995YPq2wMzNjww2X+vwNt1p00ynrd2yKDJAVN628sBX1hZIdxXdStU9G5W2bd9YHR5L3f/CNmJeY9G8WAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

RegisterNetEvent('eAmbulance:revive')
AddEventHandler('eAmbulance:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('eAmbulance:setDeathStatus', false)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)


function GetABed()
    local getbed = RageUI.CreateMenu(Config.PrefixName, "Lit")
	getbed:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

        RageUI.Visible(getbed, not RageUI.Visible(getbed))
            while getbed do
            Citizen.Wait(0)
            RageUI.IsVisible(getbed, true, true, true, function()

				for _,e in pairs(lit) do
					RageUI.ButtonWithStyle(e.title, nil, Config.RightLab, true, function(Hovered, Active, Selected)
						if Selected then
							while not HasModelLoaded(e.lit) do
								RequestModel(e.lit)
								Citizen.Wait(1)
							end
							local ped = GetEntityCoords(GetPlayerPed(-1), false)
							local object = CreateObject(GetHashKey(e.lit), ped.x, ped.y, ped.z-1.0, true)
							prendre(object)
							RageUI.CloseAll()
						end
					end)
				end

				RageUI.ButtonWithStyle(Config.Language.delete_bed, nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
					if Selected then 
						for _,z in pairs(lit) do
							local prop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1), false), 4.0, GetHashKey(z.lit))
							if IsEntityAttachedToEntity(prop, GetPlayerPed(-1)) ~= 0 or prop ~= 0 then
								if DoesEntityExist(prop) then
									SetEntityAsMissionEntity(prop, true, true)
									DeleteEntity(prop)
									Citizen.Wait(5)
									ClearPedTasksImmediately(GetPlayerPed(-1))
									cooldowncool(1000)
								end
							end
						end
					end
				end)


                end, function()
                end)

            if not RageUI.Visible(getbed) then
			getbed = RMenu:DeleteType("getbed", true)
        end
    end
end

function Ambulancedeouf()
	local Ambulance = RageUI.CreateMenu(Config.PrefixName, "Intéractions")
    Ambulance:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        RageUI.Visible(Ambulance, not RageUI.Visible(Ambulance))
            while Ambulance do
            Citizen.Wait(0)
            RageUI.IsVisible(Ambulance, true, true, true, function()

                RageUI.Separator("~b~↓ Actions ↓")
				
				local pedCoords = GetEntityCoords(GetPlayerPed(-1))

				for _,i in pairs(lit) do

					local closestObject = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(i.lit), false)
				
					if DoesEntityExist(closestObject) then
						sleep = 5
						local propCoords = GetEntityCoords(closestObject)
						local propForward = GetEntityForwardVector(closestObject)
						local litCoords = (propCoords + propForward)
						local sitCoords = (propCoords + propForward * 0.1)
						local pickupCoords = (propCoords + propForward * 1.2)
						local pickupCoords2 = (propCoords + propForward * - 1.2)
		
						if GetDistanceBetweenCoords(pedCoords, litCoords, true) <= 5.0 then

							for _,k in pairs(i.name) do
								RageUI.ButtonWithStyle(k.name, nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
									if Selected then 
										LoadAnim(k.anim)
										AttachEntityToEntity(GetPlayerPed(-1), closestObject, GetPlayerPed(-1), k.x, k.y, k.z, 0.0, 0.0, k.r, 0.0, false, false, false, false, 2, true)
										TaskPlayAnim(GetPlayerPed(-1), k.anim, k.lib, 8.0, 8.0, -1, 1, 0, false, false, false)
										cooldowncool(1000)
									end
								end)
							end

							RageUI.ButtonWithStyle("Ranger le lit", nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
								if Selected then 
									for _,z in pairs(lit) do
										local prop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1), false), 4.0, GetHashKey(z.lit))
										if IsEntityAttachedToEntity(prop, GetPlayerPed(-1)) ~= 0 or prop ~= 0 then
											if DoesEntityExist(prop) then
												SetEntityAsMissionEntity(prop, true, true)
												DeleteEntity(prop)
												Citizen.Wait(5)
												ClearPedTasksImmediately(GetPlayerPed(-1))
												cooldowncool(1000)
											end
										end
									end
								end
							end)

							RageUI.ButtonWithStyle("Descendre du lit", nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
								if Selected then 
									DetachEntity(GetPlayerPed(-1), true, true)
									local x, y, z = table.unpack(GetEntityCoords(closestObject) + GetEntityForwardVector(closestObject) * - i.distance_stop)
									SetEntityCoords(GetPlayerPed(-1), x, y, z)
									cooldowncool(1000)
								end
							end)

						end
					end
				end

                end, function()
                end)

            if not RageUI.Visible(Ambulance) then
			Ambulance = RMenu:DeleteType("Ambulance", true)
        end
    end
end

local hurt = false
Citizen.CreateThread(function()
    while true do
        wait = 800
        if GetEntityHealth(GetPlayerPed(-1)) <= Config.NBHealPourDegatMarche then
            wait = 0
            setHurt()
        elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > Config.NBHealPourNODegatMarche then
            wait = 0
            setNotHurt()
        end
        Citizen.Wait(wait)
    end
end)
