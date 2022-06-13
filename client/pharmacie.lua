function PharmacieAmbulance()
    local PhAmbulance = RageUI.CreateMenu("E.M.S", "Pharmacie")
    PhAmbulance:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        RageUI.Visible(PhAmbulance, not RageUI.Visible(PhAmbulance))
            while PhAmbulance do
            Citizen.Wait(0)
            RageUI.IsVisible(PhAmbulance, true, true, true, function()

                    RageUI.ButtonWithStyle("Kit médical",nil, {RightLabel = "~o~90$ Entreprise"}, not cooldown, function(Hovered, Active, Selected)
                        if Selected then
                            local item = "medikit"
                            local amount = 1
                            local price = 90
                            TriggerServerEvent('eAmbulance:BuyShop', item, amount, price)
                            coolcoolmec(500)
                        end
                    end)

                    RageUI.ButtonWithStyle("Bandage",nil, {RightLabel = "~o~50$ Entreprise"}, not cooldown, function(Hovered, Active, Selected)
                        if Selected then
                            local item = "bandage"
                            local amount = 1
                            local price = 50
                            TriggerServerEvent('eAmbulance:BuyShop', item, amount, price)
                            coolcoolmec(500)
                        end
                    end)

                    RageUI.ButtonWithStyle("Compresse",nil, {RightLabel = "~o~25$ Entreprise"}, not cooldown, function(Hovered, Active, Selected)
                        if Selected then
                            local item = "compresse"
                            local amount = 1
                            local price = 25
                            TriggerServerEvent('eAmbulance:BuyShop', item, amount, price)
                            coolcoolmec(500)
                        end
                    end)

                end, function()
                end)
            if not RageUI.Visible(PhAmbulance) then
                PhAmbulance = RMenu:DeleteType("PhAmbulance", true)
        end
    end
end