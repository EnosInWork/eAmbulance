local stockCar = {}
local stockCar2 = {}
local stockBato = {}
local stockHelico = {}

Citizen.CreateThread(function()
    while true do
		local wait = 800
        local player = PlayerPedId()
		local plyPos = GetEntityCoords(player)
        --------------------------------------------------------------------------------------------------------------------
        local SudGarage = #(plyPos-Config.Sud.garage)
		local SudGarageHeli = #(plyPos-Config.Sud.garageHeli)
		local SudGarageBato = #(plyPos-Config.Sud.garageBato)
        --------------------------------------------------------------------------------------------------------------------
		local NordGarage = #(plyPos-Config.Nord.garage)
		--------------------------------------------------------------------------------------------------------------------

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then 

			if NordGarage <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.garage.x, Config.Nord.garage.y, Config.Nord.garage.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordGarage <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Garage", time_display = 1 })
                if IsControlJustPressed(1,51) then
					for k,v in pairs(Config.Garage.voiture) do
						if v.category == nil then
							ESX.TriggerServerCallback('eAmbulance:getVehGarageN', function(amount)
								stockCar[GetHashKey(v.model)] = amount
								GarageAmbulanceNord()
							end, GetHashKey(v.model))
						end
					end
                end
            end

            if SudGarage <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.garage.x, Config.Sud.garage.y, Config.Sud.garage.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudGarage <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Garage", time_display = 1 })
					if IsControlJustPressed(1,51) then
						for k,v in pairs(Config.Garage.voiture) do
						if v.category == nil then
							ESX.TriggerServerCallback('eAmbulance:getVehGarage', function(amount)
								stockCar2[GetHashKey(v.model)] = amount
								GarageAmbulanceSud()
							end, GetHashKey(v.model))
						end
					end
                end
            end

			if SudGarageHeli <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.garageHeli.x, Config.Sud.garageHeli.y, Config.Sud.garageHeli.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudGarageHeli <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Garage (Hélicoptère)", time_display = 1 })
					if IsControlJustPressed(1,51) then
						for k,v in pairs(Config.Garage.helico) do
						if v.category == nil then
							ESX.TriggerServerCallback('eAmbulance:getVehGarage', function(amount)
								stockHelico[GetHashKey(v.model)] = amount
								GarageHeliAmbu()
							end, GetHashKey(v.model))
						end
					end
                end
            end

			if SudGarageBato <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.garageBato.x, Config.Sud.garageBato.y, Config.Sud.garageBato.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudGarageBato <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Garage (Bateau)", time_display = 1 })
					if IsControlJustPressed(1,51) then
						for k,v in pairs(Config.Garage.bato) do
						if v.category == nil then
							ESX.TriggerServerCallback('eAmbulance:getVehGarage', function(amount)
								stockBato[GetHashKey(v.model)] = amount
								BateauAmbu()
							end, GetHashKey(v.model))
						end
					end
                end
            end

		end
		Citizen.Wait(wait)
	end
end)

function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end

function SpawnBato(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.SpawnGarage.Bato.Position, Config.SpawnGarage.Bato.Heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
    SetVehicleMaxMods(vehicle)
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle))
end

function SpawnHelico(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.SpawnGarage.Helico.Position, Config.SpawnGarage.Helico.Heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
    SetVehicleMaxMods(vehicle)
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle))
end

function SpawnNord(card)
	local card = GetHashKey(card)

	RequestModel(card)
	while not HasModelLoaded(card) do
		RequestModel(card)
		Citizen.Wait(0)
	end

	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
	local vehiclen = CreateVehicle(card, Config.SpawnGarage.VoitureNord.Position, Config.SpawnGarage.VoitureNord.Heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
    SetVehicleMaxMods(vehicle)
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle))
end

function SpawnSud(car)
	local car = GetHashKey(car)

	RequestModel(car)
	while not HasModelLoaded(car) do
		RequestModel(car)
		Citizen.Wait(0)
	end

	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
	local vehicle = CreateVehicle(car, Config.SpawnGarage.VoitureSud.Position, Config.SpawnGarage.VoitureSud.Heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
    SetVehicleMaxMods(vehicle)
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle))
end

function GarageAmbulanceNord()
	local AmbuNord = RageUI.CreateMenu("E.M.S", "Garage Nord")
    AmbuNord:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
	  RageUI.Visible(AmbuNord, not RageUI.Visible(AmbuNord))
		  while AmbuNord do
			  Citizen.Wait(0)
				  RageUI.IsVisible(AmbuNord, true, true, true, function()

					RageUI.ButtonWithStyle("Ranger le véhicule dans le stock", nil, Config.RightLab,true, function(Hovered, Active, Selected)
						if Selected then
	
							local veh, dist4 = ESX.Game.GetClosestVehicle()
							TriggerServerEvent("eAmbulance:addVehInGarageN", GetEntityModel(veh))
							if dist4 < 4 then
								DeleteEntity(veh)
								RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~Rangement du véhicule. . ."})
								TriggerServerEvent('ddx_vehiclelock:deletekeyjobs', 'no')
								RageUI.CloseAll()
							end
	
						end
					end)
		
				for k,v in pairs(Config.Garage.voiture) do
					if v.category ~= nil then 
						RageUI.Separator(v.category)
					else
						RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "Stock(s) : [~b~"..stockCar[GetHashKey(v.model)].."~s~]"}, ESX.PlayerData.job.grade >= v.minimum_grade, function(_,_,s)
							if s then
								if stockCar[GetHashKey(v.model)] > 0 then
									SpawnNord(v.model)
									TriggerServerEvent("eAmbulance:removeVehInGarageN", GetHashKey(v.model))
									RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~"..v.label.." sortie du stock LSMS"})
									RageUI.CloseAll()
								else 
									RageUI.Popup({message = "<C>~b~"..v.label.."\n~r~Aucun stock"})
									RageUI.CloseAll()
								end
							end
						end)
					end
				end

				  end, function()
				  end)
			if not RageUI.Visible(AmbuNord) then
			AmbuNord = RMenu:DeleteType("AmbuNord", true)
		end
	end
end

function GarageAmbulanceSud()
	local GAmbulance = RageUI.CreateMenu("E.M.S", "Garage Sud")
    GAmbulance:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

	  RageUI.Visible(GAmbulance, not RageUI.Visible(GAmbulance))
		  while GAmbulance do
			  Citizen.Wait(0)
				  RageUI.IsVisible(GAmbulance, true, true, true, function()


				RageUI.ButtonWithStyle("Ranger le véhicule dans le stock", nil, Config.RightLab,true, function(Hovered, Active, Selected)
					if Selected then

						local veh, dist4 = ESX.Game.GetClosestVehicle()
						TriggerServerEvent("eAmbulance:addVehInGarage", GetEntityModel(veh))
						if dist4 < 4 then
							DeleteEntity(veh)
							RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~Rangement du véhicule. . ."})
							TriggerServerEvent('ddx_vehiclelock:deletekeyjobs', 'no')
							RageUI.CloseAll()
						end

					end
				end)
		
				for k,v in pairs(Config.Garage.voiture) do
					if v.category ~= nil then 
						RageUI.Separator(v.category)
					else
						RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "Stock(s) : [~b~"..stockCar2[GetHashKey(v.model)].."~s~]"}, ESX.PlayerData.job.grade >= v.minimum_grade, function(_,_,s)
							if s then
								if stockCar2[GetHashKey(v.model)] > 0 then
									SpawnSud(v.model)
									TriggerServerEvent("eAmbulance:removeVehInGarage", GetHashKey(v.model))
									RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~"..v.label.." sortie du stock LSPD"})
									RageUI.CloseAll()
								else 
									RageUI.Popup({message = "<C>~b~"..v.label.."\n~r~Aucun stock"})
									RageUI.CloseAll()
								end
							end
						end)
					end
				end 


				end, function()
				end)

			if not RageUI.Visible(GAmbulance) then
			GAmbulance = RMenu:DeleteType("GAmbulance", true)
		end
	end
end

function GarageHeliAmbu()
	local ghp = RageUI.CreateMenu("E.M.S", "Garage Hélico")
    ghp:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
		RageUI.Visible(ghp, not RageUI.Visible(ghp))
			while ghp do
    			Citizen.Wait(0)
        			RageUI.IsVisible(ghp, true, true, true, function()
  
						RageUI.ButtonWithStyle("Ranger le véhicule dans le stock", nil, Config.RightLab,true, function(Hovered, Active, Selected)
							if Selected then
		
								local veh, dist4 = ESX.Game.GetClosestVehicle()
								TriggerServerEvent("eAmbulance:addVehInGarage", GetEntityModel(veh))
								if dist4 < 4 then
									DeleteEntity(veh)
									RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~Rangement du véhicule. . ."})
									TriggerServerEvent('ddx_vehiclelock:deletekeyjobs', 'no')
									RageUI.CloseAll()
								end
		
							end
						end)
                
				for k,v in pairs(Config.Garage.helico) do
					if v.category ~= nil then 
						RageUI.Separator(v.category)
					else
						RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "Stock(s) : [~b~"..stockHelico[GetHashKey(v.model)].."~s~]"}, ESX.PlayerData.job.grade >= v.minimum_grade, function(_,_,s)
							if s then
								if stockHelico[GetHashKey(v.model)] > 0 then
									SpawnSud(v.model)
									TriggerServerEvent("eAmbulance:removeVehInGarage", GetHashKey(v.model))
									RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~"..v.label.." sortie du stock EMS"})
									RageUI.CloseAll()
								else 
									RageUI.Popup({message = "<C>~b~"..v.label.."\n~r~Aucun stock"})
									RageUI.CloseAll()
								end
							end
						end)
					end
				end 
              
                end, function()
                end)
   
		if not RageUI.Visible(ghp) then
			ghp = RMenu:DeleteType("ghp", true)
		end
	end
end

function BateauAmbu()
    local batp = RageUI.CreateMenu("E.M.S", "Garage bateaux")
    batp:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    RageUI.Visible(batp, not RageUI.Visible(batp))
    while batp do
        Citizen.Wait(0)
            RageUI.IsVisible(batp, true, true, true, function()

				RageUI.ButtonWithStyle("Ranger le véhicule dans le stock", nil, Config.RightLab,true, function(Hovered, Active, Selected)
					if Selected then

						local veh, dist4 = ESX.Game.GetClosestVehicle()
						TriggerServerEvent("eAmbulance:addVehInGarage", GetEntityModel(veh))
						if dist4 < 4 then
							DeleteEntity(veh)
							RageUI.Popup({message = "<C>~r~- Stock LSMS\n~g~Rangement du véhicule. . ."})
							TriggerServerEvent('ddx_vehiclelock:deletekeyjobs', 'no')
							RageUI.CloseAll()
						end

					end
				end)
		
		for k,v in pairs(Config.Garage.bato) do
			if v.category ~= nil then 
				RageUI.Separator(v.category)
			else
				RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "Stock(s) : [~b~"..stockBato[GetHashKey(v.model)].."~s~]"}, ESX.PlayerData.job.grade >= v.minimum_grade, function(_,_,s)
					if s then
						if stockBato[GetHashKey(v.model)] > 0 then
							SpawnSud(v.model)
							TriggerServerEvent("eAmbulance:removeVehInGarage", GetHashKey(v.model))
							RageUI.Popup({message = "<C>~r~- Stock EMS\n~g~"..v.label.." sortie du stock EMS"})
							RageUI.CloseAll()
						else 
							RageUI.Popup({message = "<C>~b~"..v.label.."\n~r~Aucun stock"})
							RageUI.CloseAll()
						end
					end
				end)
			end
		end 

            
        end, function()
        end)
        if not RageUI.Visible(batp) then
            batp = RMenu:DeleteType("batp", true)
        end
    end
end