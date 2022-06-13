local stockCar = {}

ESX = nil 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.esxGet, function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
		local wait = 800
        local player = PlayerPedId()
		local plyPos = GetEntityCoords(player)
        --------------------------------------------------------------------------------------------------------------------
		local SudVestiaire = #(plyPos-Config.Sud.vestiaire)
        local SudPharma = #(plyPos-Config.Sud.pharmacie)
        local SudFiche = #(plyPos-Config.Sud.fiche_medical)
        local SudCoffre = #(plyPos-Config.Sud.coffre)
        local SudBoss = #(plyPos-Config.Sud.boss)
        local SudExtra = #(plyPos-Config.Sud.extra)
        local SudRDV = #(plyPos-Config.Sud.rdv)
        --------------------------------------------------------------------------------------------------------------------
        local NordVestiaire = #(plyPos-Config.Nord.vestiaire)
        local NordPharma = #(plyPos-Config.Nord.pharmacie)
        local NordFiche = #(plyPos-Config.Nord.fiche_medical)
        local NordCoffre = #(plyPos-Config.Nord.coffre)
        local NordBoss = #(plyPos-Config.Nord.boss)
        local NordExtra = #(plyPos-Config.Nord.extra)
        local NordRDV = #(plyPos-Config.Nord.rdv)
        --------------------------------------------------------------------------------------------------------------------


		if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then 

			if SudVestiaire <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.vestiaire.x, Config.Sud.vestiaire.y, Config.Sud.vestiaire.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudVestiaire <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Vestiaire", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    VestiaireAmbulance()
                end
            end

            if SudPharma <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.pharmacie.x, Config.Sud.pharmacie.y, Config.Sud.pharmacie.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudPharma <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Pharmacie", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    PharmacieAmbulance()
                end
            end

            if SudCoffre <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.coffre.x, Config.Sud.coffre.y, Config.Sud.coffre.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudCoffre <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Coffre", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    CoffreAmbulance()
                end
            end

            if SudFiche <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.fiche_medical.x, Config.Sud.fiche_medical.y, Config.Sud.fiche_medical.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudFiche <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Fiche médicale", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    LesFiches()
                end
            end


            if SudExtra <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Sud.extra.x, Config.Sud.extra.y, Config.Sud.extra.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if SudExtra <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Extras & Liveries", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    ExtraAmbu()
                end
            end

            --------------------------------------------------------------------------------------------------------------------

            if NordVestiaire <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.vestiaire.x, Config.Nord.vestiaire.y, Config.Nord.vestiaire.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordVestiaire <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Vestiaire", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    VestiaireAmbulance()
                end
            end

            if NordPharma <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.pharmacie.x, Config.Nord.pharmacie.y, Config.Nord.pharmacie.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordPharma <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Pharmacie", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    PharmacieAmbulance()
                end
            end

            if NordFiche <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.fiche_medical.x, Config.Nord.fiche_medical.y, Config.Nord.fiche_medical.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordFiche <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Fiche médicale", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    LesFiches()
                end
            end

            if NordCoffre <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.coffre.x, Config.Nord.coffre.y, Config.Nord.coffre.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordCoffre <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Coffre", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    CoffreAmbulance()
                end
            end

            if NordExtra <= Config.Marker.DrawDistance then
			    wait = 0
                DrawMarker(Config.Marker.Type, Config.Nord.extra.x, Config.Nord.extra.y, Config.Nord.extra.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end

			if NordExtra <= Config.Marker.DrawInteract then
                wait = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Extras & Liveries", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    ExtraAmbu()
                end
            end

            --------------------------------------------------------
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then

                if NordBoss <= Config.Marker.DrawDistance then
                    wait = 0
                    DrawMarker(Config.Marker.Type, Config.Nord.boss.x, Config.Nord.boss.y, Config.Nord.boss.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
                end
        
                if NordBoss <= Config.Marker.DrawInteract then
                    wait = 0
                    RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Actions Patron", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        RefreshAmbulanceMoney()
                        BossAmbulance()
                    end
                end

                if SudBoss <= Config.Marker.DrawDistance then
                    wait = 0
                    DrawMarker(Config.Marker.Type, Config.Sud.boss.x, Config.Sud.boss.y, Config.Sud.boss.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
                end
        
                if SudBoss <= Config.Marker.DrawInteract then
                    wait = 0
                    RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Actions Patron", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        RefreshAmbulanceMoney()
                        BossAmbulance()
                    end
                end

            end
            ----------------------------------------------------------------
		end

        if SudRDV <= Config.Marker.DrawDistance then
            wait = 0
            DrawMarker(Config.Marker.Type, Config.Sud.rdv.x, Config.Sud.rdv.y, Config.Sud.rdv.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        end

        if SudRDV <= Config.Marker.DrawInteract then
            wait = 0
            RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Accueil", time_display = 1 })
            if IsControlJustPressed(1,51) then
                ServiceAmbu()
            end
        end

        if NordRDV <= Config.Marker.DrawDistance then
            wait = 0
            DrawMarker(Config.Marker.Type, Config.Nord.rdv.x, Config.Nord.rdv.y, Config.Nord.rdv.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        end

        if NordRDV <= Config.Marker.DrawInteract then
            wait = 0
            RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Accueil", time_display = 1 })
            if IsControlJustPressed(1,51) then
                ServiceAmbu()
            end
        end

		Citizen.Wait(wait)
	end
end)