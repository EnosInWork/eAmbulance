function CoffreAmbulance()
    local CAmbulance = RageUI.CreateMenu("E.M.S", "Coffre - Action")
    CAmbulance:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

        RageUI.Visible(CAmbulance, not RageUI.Visible(CAmbulance))
            while CAmbulance do
            Citizen.Wait(0)
            RageUI.IsVisible(CAmbulance, true, true, true, function()

                RageUI.Separator("~b~↓ Objet(s) ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, Config.RightLab, true, function(Hovered, Active, Selected)
                        if Selected then
                            AmbulanceRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, Config.RightLab, true, function(Hovered, Active, Selected)
                        if Selected then
                            AmbulanceDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CAmbulance) then
            CAmbulance = RMenu:DeleteType("CAmbulance", true)
        end
    end
end


itemstock = {}
function AmbulanceRetirerobjet()
    local Stockbennys = RageUI.CreateMenu("E.M.S", "Coffre - Retirer")
    Stockbennys:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    ESX.TriggerServerCallback('eAmbulance:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockbennys, not RageUI.Visible(Stockbennys))
        while Stockbennys do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockbennys, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('eAmbulance:getStockItem', v.name, tonumber(count))
                                    AmbulanceRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockbennys) then
            Stockbennys = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function AmbulanceDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("E.M.S", "Coffre - Déposer")
    StockPlayer:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    ESX.TriggerServerCallback('eAmbulance:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('eAmbulance:putStockItems', item.name, tonumber(count))
                                            AmbulanceDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end