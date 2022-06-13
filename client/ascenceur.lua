Citizen.CreateThread(function()
    while true do
        local waiting = 750
        local plyCoords2 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.Sud.ascenceur.monter.x, Config.Sud.ascenceur.monter.y, Config.Sud.ascenceur.monter.z)
        local dist3 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.Sud.ascenceur.descendre.x, Config.Sud.ascenceur.descendre.y, Config.Sud.ascenceur.descendre.z)
        local dist4 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.Sud.ascenceur.neutre.x, Config.Sud.ascenceur.neutre.y, Config.Sud.ascenceur.neutre.z)

        if dist4 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.Sud.ascenceur.neutre.x, Config.Sud.ascenceur.neutre.y, Config.Sud.ascenceur.neutre.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        elseif dist2 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.Sud.ascenceur.monter.x, Config.Sud.ascenceur.monter.y, Config.Sud.ascenceur.monter.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        elseif dist3 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.Sud.ascenceur.descendre.x, Config.Sud.ascenceur.descendre.y, Config.Sud.ascenceur.descendre.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        end
        
        if dist4 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour →→ ~r~Prendre l'ascenceur", time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end   
        elseif dist2 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour →→ ~r~Prendre l'ascenceur", time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end  
        elseif dist3 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour →→ ~r~Prendre l'ascenceur", time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end 
        end
        Citizen.Wait(waiting)
    end
end)

function monter()
    DoScreenFadeOut(100)
    Citizen.Wait(750)
    ESX.Game.Teleport(PlayerPedId(), {x=Config.Sud.ascenceur.descendre.x,y=Config.Sud.ascenceur.descendre.y,z=Config.Sud.ascenceur.descendre.z})
    DoScreenFadeIn(100)
end

function descendre()
    DoScreenFadeOut(100)
    Citizen.Wait(750)
    ESX.Game.Teleport(PlayerPedId(), {x=Config.Sud.ascenceur.monter.x,y=Config.Sud.ascenceur.monter.y,z=Config.Sud.ascenceur.monter.z})
    DoScreenFadeIn(100)
end

function neutre()
    DoScreenFadeOut(100)
    Citizen.Wait(750)
    ESX.Game.Teleport(PlayerPedId(), {x=Config.Sud.ascenceur.neutre.x,y=Config.Sud.ascenceur.neutre.y,z=Config.Sud.ascenceur.neutre.z})
    DoScreenFadeIn(100)
end

function OpenAcssss()
    local main_chirurgie = RageUI.CreateMenu("E.M.S", "Ascenceur")

    main_chirurgie:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)


    RageUI.Visible(main_chirurgie, not RageUI.Visible(main_chirurgie))
    while main_chirurgie do
        Citizen.Wait(0)

            RageUI.IsVisible(main_chirurgie, true, true, true, function()

                RageUI.ButtonWithStyle("Etage - Pharmacie",nil, {RightLabel = "1"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        monter()
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Accueil - Réception",nil, {RightLabel = "0"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        neutre()
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Parking - Garage",nil, {RightLabel = "-1"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        descendre()
                        RageUI.CloseAll()
                    end
                end)

            end, function()
            end)

        if not RageUI.Visible(main_chirurgie) then
            main_chirurgie = RMenu:DeleteType(main_chirurgie, true)
        end
    end
end

