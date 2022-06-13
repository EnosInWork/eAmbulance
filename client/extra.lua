function ExtraAmbu()
    local main_extra = RageUI.CreateMenu("E.M.S", "Extras & Liveries")
    local subextra = RageUI.CreateSubMenu(main_extra, "E.M.S", "Extras & Liveries")
    local livery = RageUI.CreateSubMenu(main_extra, "E.M.S", "Extras & Liveries")
    main_extra:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    subextra:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    livery:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    RageUI.Visible(main_extra, not RageUI.Visible(main_extra))
    while main_extra do
        Citizen.Wait(0)

            RageUI.IsVisible(main_extra, true, true, true, function()

                RageUI.ButtonWithStyle("Extras & Liverys", nil, {}, true, function(_, _, s)
                end, livery)

                RageUI.ButtonWithStyle("Couleurs", nil, Config.RightLab, true, function(Hovered, Active, Selected)  
                end, subextra)

                RageUI.ButtonWithStyle("Nettoyer le véhicule", nil, Config.RightLab, true, function(Hovered, Active, Selected)  
                    if Selected then 
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                        SetVehicleDirtLevel(vehicle, 0)
                        RageUI.Popup({message = "<C>Véhicule nettoyer"})
                    end
                end)

            end, function()
            end)

            RageUI.IsVisible(livery, true, true, true, function()

                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local liveryCount = GetVehicleLiveryCount(vehicle)

                RageUI.Separator("~r~Livery(s)")
        
                    for i = 1, liveryCount do
                        local state = GetVehicleLivery(vehicle) 
                        
                        if state == i then
                            RageUI.ButtonWithStyle("Livery: "..i, nil, {RightLabel = "~g~ON"}, true, function(Hovered, Active, Selected)
                                if (Selected) then   
                                    SetVehicleLivery(vehicle, i, not state)
                                end      
                            end)
                        else
                            RageUI.ButtonWithStyle("Livery: "..i, nil, {RightLabel = "~r~OFF"}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    SetVehicleLivery(vehicle, i, state)
                                end      
                            end)
                        end
                    end

                RageUI.Separator("~b~Extra(s)")

                for id=0, 12 do
                        if DoesExtraExist(vehicle, id) then
                            local state2 = IsVehicleExtraTurnedOn(vehicle, id)
                        
                        if state2 then
                            RageUI.ButtonWithStyle("Extra: "..id, nil, {RightLabel = "~g~ON"}, true, function(Hovered, Active, Selected)
                                if (Selected) then   
                                    SetVehicleExtra(vehicle, id, state2)
                                end      
                            end)
                        else
                            RageUI.ButtonWithStyle("Extra: "..id, nil, {RightLabel = "~r~OFF"}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    SetVehicleExtra(vehicle, id, state2)
                                end      
                            end)
                        end
                    end
                end

            end, function()
            end)

            RageUI.IsVisible(subextra, true, true, true, function()

                RageUI.ButtonWithStyle("Bleu", "Couleur bleu", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    SetVehicleCustomPrimaryColour(vehicle, 0, 0, 255)
                    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 255)
                    end      
                end)
                RageUI.ButtonWithStyle("Rouge", "Couleur rouge", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                        SetVehicleCustomPrimaryColour(vehicle, 255, 0, 0)
                        SetVehicleCustomSecondaryColour(vehicle, 255, 0, 0)
                    end      
                end)
                RageUI.ButtonWithStyle("Vert", "Couleur verte", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    SetVehicleCustomPrimaryColour(vehicle, 0, 255, 0)
                    SetVehicleCustomSecondaryColour(vehicle, 0, 255, 0)
                    end      
                end)
                RageUI.ButtonWithStyle("Noir", "Couleur noir", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
                    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
                    end      
                end)
                RageUI.ButtonWithStyle("Rose", "Couleur rose", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    SetVehicleCustomPrimaryColour(vehicle, 100, 0, 60)
                    SetVehicleCustomSecondaryColour(vehicle, 100, 0, 60)
                    end      
                end)
                RageUI.ButtonWithStyle("Blanc", "Couleur blanc", Config.RightLab, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
                    SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
                    end      
                end)

        
            end, function()
            end)

        if not RageUI.Visible(main_extra) and not RageUI.Visible(subextra)  and not RageUI.Visible(livery) then
            main_extra = RMenu:DeleteType(main_extra, true)
        end
    end
end