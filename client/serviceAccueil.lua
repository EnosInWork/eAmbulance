local FirstName = nil
local LastName = nil
local Subject = nil
local Desc = nil
local tel = nil
local cansend = false

function reset()
    FirstName = nil
    LastName = nil
    Subject = nil
    Desc = nil
    tel = nil
    cansend = false
end

function ServiceAmbu()
    local service_ambulance = RageUI.CreateMenu("Accueil "..Config.PrefixName, "Que puis-je faire pour vous ?")
	local rdv_svp = RageUI.CreateSubMenu(service_ambulance, "Accueil "..Config.PrefixName, "Demande de rendez-vous")
	service_ambulance:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
	rdv_svp:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    RageUI.Visible(service_ambulance, not RageUI.Visible(service_ambulance))
    while service_ambulance do
        Citizen.Wait(0)
            RageUI.IsVisible(service_ambulance, true, true, true, function()

            RageUI.ButtonWithStyle("Demander un rendez-vous", nil, Config.RightLab,true, function()
            end, rdv_svp) 

			RageUI.ButtonWithStyle("Appeler un "..Config.PrefixName.." à l'hopital", nil, Config.RightLab,true, function(Hovered, Active, Selected)
				if (Selected) then  
				TriggerServerEvent("eAmbulance:sendcall") 
                RageUI.Popup({message = "<C>~b~Votre appel à bien été pris en compte"})
				end
			end)   
            
    end, function()
	end)

	RageUI.IsVisible(rdv_svp, true, true, true, function()

		RageUI.ButtonWithStyle("Votre Nom : ~s~"..notNilString(LastName), nil, Config.RightLab,true, function(Hovered, Active, Selected)
			if (Selected) then   
                LastName = KeyboardInput("Votre Nom:",nil,20)
			end
		end)   

		RageUI.ButtonWithStyle("Votre Prénom : ~s~"..notNilString(FirstName), nil, Config.RightLab,true, function(Hovered, Active, Selected)
			if (Selected) then   
                FirstName = KeyboardInput("Votre Prénom:",nil,20)
			end
		end)   

		RageUI.ButtonWithStyle("Votre Numéro de téléphone~s~ : ~s~"..notNilString(tel), nil, Config.RightLab,true, function(Hovered, Active, Selected)
			if (Selected) then   
                tel = KeyboardInput("Votre Numéro :",nil,350)
			end
		end)   

		RageUI.ButtonWithStyle("Sujet de votre demande~s~ : ~s~"..notNilString(Subject), nil, Config.RightLab,true, function(Hovered, Active, Selected)
			if (Selected) then   
                Subject = KeyboardInput("Votre Sujet:",nil,30)
			end
		end)   

		RageUI.ButtonWithStyle("Votre demande~s~ : ~s~"..notNilString(Desc), nil, Config.RightLab,true, function(Hovered, Active, Selected)
			if (Selected) then   
                Desc = KeyboardInput("Votre Description:",nil,350)
			end
		end)  

		if LastName ~= nil and LastName ~= "" and FirstName ~= nil and FirstName ~= "" and tel ~= nil and tel ~= "" and Subject ~= nil and Subject ~= "" and Desc ~= nil and Desc ~= "" then
			cansend = true
		end

        RageUI.ButtonWithStyle("~g~~h~Envoyer", nil, Config.RightLab,true, function(Hovered, Active, Selected)
            if (Selected) then   
                RageUI.CloseAll()
                TriggerServerEvent("eAmbulance:sendDemande", LastName, FirstName,tel ,Subject, Desc)
                RageUI.Popup({message = "<C>~b~Votre demande a bien été pris en compte"})
                reset()
            end
        end)

	end, function()
	end)
	
        if not RageUI.Visible(service_ambulance) and not RageUI.Visible(rdv_svp) then
            service_ambulance = RMenu:DeleteType(service_ambulance, true)
        end
    end
end