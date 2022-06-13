
function VestiaireAmbulance()
    local Main_Vest = RageUI.CreateMenu("E.M.S", "Vestiaire")
    Main_Vest:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        RageUI.Visible(Main_Vest, not RageUI.Visible(Main_Vest))
            while Main_Vest do
            Citizen.Wait(0)
            RageUI.IsVisible(Main_Vest, true, true, true, function()

                RageUI.Separator("~u~↓ Vêtements ↓")

                    RageUI.ButtonWithStyle("Equiper sa tenue EMS",nil, Config.RightLab, true, function(Hovered, Active, Selected)
                        if Selected then
                            mettreuniform()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Remettre sa tenue civil",nil, Config.RightLab, true, function(Hovered, Active, Selected)
                        if Selected then
                            mettretenuecivil()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(Main_Vest) then
            Main_Vest = RMenu:DeleteType("Main_Vest", true)
        end
    end
end

function mettreuniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Config.Tenue.male
        else
            uniformObject = Config.Tenue.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function mettretenuecivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end