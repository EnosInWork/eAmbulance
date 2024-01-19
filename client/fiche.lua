FicheBuilder = {dangerosity = 1}
ficheData = nil
ficheIndex = 0

RegisterNetEvent("ambu:ficheGet")
AddEventHandler("ambu:ficheGet", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then ficheData = result end
end)


function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function LesFiches()
	local lesfichess = RageUI.CreateMenu("E.M.S", "Fiche médicale")
	local Fiche_Info = RageUI.CreateSubMenu(lesfichess, "E.M.S", "Fiche médicale")
	local Fiche = RageUI.CreateSubMenu(lesfichess, "E.M.S", "Fiche médicale")
    lesfichess:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    Fiche_Info:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    Fiche:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

	  RageUI.Visible(lesfichess, not RageUI.Visible(lesfichess))
  
			  while lesfichess do
				  Citizen.Wait(0)
					  RageUI.IsVisible(lesfichess, true, true, true, function()

					RageUI.Separator("↓ ~b~ Intéractions~s~ ↓")
		
					RageUI.ButtonWithStyle("Consulter les fiches", nil, {RightLabel = "→"}, true, function(_,_,s)
						if s then
							ficheData = nil
							TriggerServerEvent("ambu:ficheGet")
						end
					end, Fiche)


				end, function()
			  	end)
		
			RageUI.IsVisible(Fiche, true, true, true, function()

				RageUI.List("Filtre :", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)
		
				if ficheData == nil then
					RageUI.Separator("")
					RageUI.Separator("~r~Aucune fiche médicale par "..filterArray[filter])
					RageUI.Separator("")
				else
					for index,Fiche in pairs(ficheData) do
						if starts(Fiche.lastname:lower(), filterArray[filter]:lower()) then
							RageUI.ButtonWithStyle("→ "..Fiche.firstname.." "..Fiche.lastname, nil, { RightLabel = "~b~→→" }, true, function(_,_,s)
								if s then
									ficheIndex = index
								end
							end, Fiche_Info)
						end
					end
					
				end
		
			end, function()
			end)
		
			RageUI.IsVisible(Fiche_Info, true, true, true, function()

				RageUI.Separator("↓ ~r~Informations ~s~↓")

				RageUI.ButtonWithStyle("~g~Médecin: ~s~"..ficheData[ficheIndex].author, nil, {}, true, function()
                end)

				RageUI.ButtonWithStyle("~g~Le: ~s~"..ficheData[ficheIndex].date, nil, {}, true, function()
                end)

				RageUI.ButtonWithStyle("~o~Client: ~s~"..ficheData[ficheIndex].firstname.." "..ficheData[ficheIndex].lastname, nil, {}, true, function()
                end)

				RageUI.ButtonWithStyle("~o~Raison(s): ~s~"..ficheData[ficheIndex].reason, nil, {}, true, function()
                end)


				RageUI.Separator("↓ ~r~Actions ~s~↓")

					RageUI.ButtonWithStyle('~b~Ajouter/Supprimer un élement à la fiche', nil, Config.RightLab, true, function(Hovered, Active, Selected)
						if (Selected) then
							FicheBuilder.newreason = KeyboardInput("Raison", ficheData[ficheIndex].reason..", ", 100)
							TriggerServerEvent("ambu:FicheModify", FicheBuilder, ficheIndex, newreason)
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~L.S.M.S~b~]\n~g~Raison ajouter à la fiche de l'individu"})
							RageUI.CloseAll()
						end 
					end)

					RageUI.ButtonWithStyle("~r~Supprimer la fiche médicale", nil, Config.RightLab, true, function(_,_,s)
						if s then
							RageUI.GoBack()
							TriggerServerEvent("ambu:ficheDel", ficheIndex)
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~L.S.M.S~b~]\n~g~Fiche médicale supprimer avec succès"})
						end
					end)

		
				end, function()
				end)

            if not RageUI.Visible(lesfichess) and not RageUI.Visible(Fiche_Info) and not RageUI.Visible(Fiche) then
            lesfichess = RMenu:DeleteType("Fiche médicale", true)
        end
    end
end   

