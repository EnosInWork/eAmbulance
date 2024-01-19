local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy, deadPlayers, deadPlayerBlips, isOnDuty = false, {}, {}, false

local appellist = {}

local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('eAmbulance:infoReport', function(info)
        appellist = info
    end)
end

local ZoneBlips = {Config.Nord.Blips, Config.Sud.Blips}

Citizen.CreateThread(function()    
    Citizen.Wait(0)    
        local bool = true     
        if bool then    
            for k,v in pairs(ZoneBlips) do      
            blip = AddBlipForCoord(v.position)
            SetBlipSprite(blip, v.id)
            SetBlipDisplay(blip, v.display)
            SetBlipScale(blip, v.scale)
            SetBlipColour(blip, v.colour)
            SetBlipAsShortRange(blip, v.shortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(blip)
        end        
     bool = false     
    end
end)

local object = {}
local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }
  
function checkArray (array, val)
    for name, value in ipairs(array) do
        if value == val then
            return true
        end
    end

    return false
end
  
Citizen.CreateThread(function()
	Citizen.Wait(1000)
		while true do
        local sleep = 3000

        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance < 10.0 then

                if distance ~= -1 and distance <= 2.0 then	
                    if IsPedDeadOrDying(GetPlayerPed(player)) then
                        Start(GetPlayerPed(player))
                    end
                end

            else
                sleep = sleep / 100 * distance 
            end

        end
        Citizen.Wait(sleep)
	end
end)


function Start(ped)
	checking = true
	  while checking do
		  Citizen.Wait(5)
  
		  local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))
		  local x,y,z = table.unpack(GetEntityCoords(ped))
  
		  if distance < 2.0 then

            RageUI.Text({message = "Appuyez sur [E] pour analyser le corp"})

            if IsControlPressed(0, 38) then
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                    F6Ambulance()
                else
                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~g~Vous n'êtes pas médecin"})
                end
            end

		  end
  
		  if distance > 7.5 or not IsPedDeadOrDying(ped) then
			checking = false
		end
	end
end

local fofo = false
local PanelChargement = false
local Percentage = 0.0

  
ficheBuilder = {dangerosity = 1}

function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

local MenuDeOuf = {

    action = {
        'Disponible',
        'Non-Dispo',
        'Recrutement',
        'Personnalisée',
    },

    list = 1,

    action_deux = {
        'En service',
        'Fin de service',
        'Pause du service',
    },

    liste = 1 

}

thisis = {
    back = false
}

local label = "Démarrer son service"
local leservice = "~r~Call-Center ~s~[~r~OFF~s~]"
local medecinname = GetPlayerName(PlayerId())

function F6Ambulance()
    local eAmbulancef6 = RageUI.CreateMenu(Config.PrefixName, "Interactions")
    local eAmbulancef6Annonces = RageUI.CreateSubMenu(eAmbulancef6, Config.PrefixName, "Annonces")
    local eAmbulanceappel = RageUI.CreateSubMenu(eAmbulancef6, Config.PrefixName, "Interactions")
    local eAmbulanceappelinfo = RageUI.CreateSubMenu(eAmbulanceappel, Config.PrefixName, "Interactions")
    local eInteractEMS = RageUI.CreateSubMenu(eAmbulancef6, Config.PrefixName, "Interactions")
    local gotofiche = RageUI.CreateSubMenu(eInteractEMS, Config.PrefixName, "Interactions")
    local objets = RageUI.CreateSubMenu(eAmbulancef6, Config.PrefixName, "Interactions")
    local objets1 = RageUI.CreateSubMenu(objets, Config.PrefixName, "Interactions")
    local objets2 = RageUI.CreateSubMenu(objets, Config.PrefixName, "Interactions")

    gotofiche.Closed = function()
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
    end
    
    eAmbulancef6:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    eAmbulancef6Annonces:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    eAmbulanceappel:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    eAmbulanceappelinfo:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    eInteractEMS:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    gotofiche:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    objets:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    objets1:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    objets2:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    getInfoReport()
    RageUI.Visible(eAmbulancef6, not RageUI.Visible(eAmbulancef6))
    while eAmbulancef6 do
        Citizen.Wait(0)
            RageUI.IsVisible(eAmbulancef6, true, true, true, function()

                RageUI.Checkbox(label, nil, ambuService, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    ambuService = Checked;
                end, function()
                    ambuService = true
                    label = "Arrêter son service"
                    leservice = "~g~Call-Center ~s~[~g~ON~s~]"
                    TriggerServerEvent('eAmbulance:PriseEtFinservice', "prise")
                    TriggerServerEvent("eEMS:logsEvent", "**"..ESX.PlayerData.job.grade_label.." **→** "..GetPlayerName(PlayerId()).." **→ Prise de service", Config.logs.service)
                end, function()
                    ambuService = false
                    label = "Démarrer son service"
                    leservice = "~r~Call-Center ~s~[~r~OFF~s~]"
                    TriggerServerEvent('eAmbulance:PriseEtFinservice', "fin")
                    TriggerServerEvent("eEMS:logsEvent", "**"..ESX.PlayerData.job.grade_label.." **→ ** "..GetPlayerName(PlayerId()).." **→ Fin de service", Config.logs.service)

                end)

                if ambuService then 

                RageUI.Separator("")
                RageUI.Separator("~b~"..ESX.PlayerData.job.grade_label.." ~s~→~b~ "..GetPlayerName(PlayerId()).." ~s~→ "..leservice)
                RageUI.Separator("")

                RageUI.ButtonWithStyle("Annonces", nil, Config.RightLab, true, function(Hovered,Active,Selected)
                end, eAmbulancef6Annonces)

                RageUI.ButtonWithStyle("Facturation",nil, Config.RightLab, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ('Ambulance'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Call-Center", "Vous avez ~o~"..#appellist.."~s~ mission(s) disponible", {RightLabel = "~o~"..#appellist.."~s~ →→"}, true, function(Hovered,Active,Selected)
                end, eAmbulanceappel)
                RageUI.ButtonWithStyle("Intéractions", nil, Config.RightLab, true, function(Hovered,Active,Selected)
                end, eInteractEMS)
                RageUI.ButtonWithStyle("Objets", nil, Config.RightLab, true, function(Hovered,Active,Selected)
                end, objets)
            else
                RageUI.Separator("")
                RageUI.Separator(leservice)
                
            end

            end, function() 
            end)

            RageUI.IsVisible(eAmbulancef6Annonces, true, true, true, function()

                RageUI.Separator("~b~↓ Annonces pour la ville ↓")

                RageUI.List('Vos annonces', MenuDeOuf.action, MenuDeOuf.list, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if Index == 1 then
                            TriggerServerEvent('AmbulanceDispo')
                            coolcoolmec(3500)
                        elseif Index == 2 then
                            TriggerServerEvent('AmbulancePasDispo')
                            coolcoolmec(3500)
                        elseif Index == 3 then
                            TriggerServerEvent('AmbulanceRecrutement')
                            coolcoolmec(3500)
                        elseif Index == 4 then
                        local irish = KeyboardInput("Votre annonce", "", 100)
                            ExecuteCommand("ems "..irish)
                            coolcoolmec(3500)
                        end
                        Wait(5)
                    end
                    MenuDeOuf.list = Index;
                end)

                RageUI.Separator("~b~↓ Annonces collègue ↓")

                RageUI.List('Informer que vous êtes ', MenuDeOuf.action_deux, MenuDeOuf.liste, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if Index == 1 then
                            TriggerServerEvent('eAmbulance:PriseEtFinservice', "prise")
                            coolcoolmec(3500)
                        elseif Index == 2 then
                            TriggerServerEvent('eAmbulance:PriseEtFinservice', "fin")
                            coolcoolmec(3500)
                        elseif Index == 3 then
                            TriggerServerEvent('eAmbulance:PriseEtFinservice', "pause")
                            coolcoolmec(3500)
                        end
                        Wait(5)
                    end
                    MenuDeOuf.liste = Index;
                end)

                RageUI.ButtonWithStyle("Demande d'aide",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then
                        local elements  = {}
                        local playerPed = PlayerPedId()
                        local coords  = GetEntityCoords(playerPed)
                        local name = GetPlayerName(PlayerId())
                        TriggerServerEvent('renfort', coords)
                        cooldowncool(5000)
                    end
                end)


                end, function() 
                end)
    
                RageUI.IsVisible(eAmbulanceappel, true, true, true, function()
                    if #appellist >= 1 then
                        RageUI.Separator("↓ ~r~Vos missions ~s~↓")

                        for k,v in pairs(appellist) do
                            RageUI.ButtonWithStyle(k.." - Patient [~o~"..v.nom.."~s~]", nil, Config.RightLab,true , function(_,_,s)
                                if s then
                                    nom = v.nom
                                    nbreport = k
                                    id = v.id
                                    raison = v.args
                                    gps = v.gps
                                end
                            end, eAmbulanceappelinfo)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~o~Vous n'avez aucune mission~s~")
                        RageUI.Separator("")
                    end
                    
                end, function() 
                end)

                RageUI.IsVisible(eAmbulanceappelinfo, true, true, true, function()

                    RageUI.Separator("Appel numéro : ~o~"..nbreport)
                    RageUI.Separator("Patient : ~o~"..nom.."~s~ [~o~"..id.."~s~]")
                    RageUI.Separator("Raison de l'appel : ~o~"..raison)

                    RageUI.ButtonWithStyle("Avoir les coordonnées GPS", nil, Config.RightLab, not cooldown, function(_,_,s)
                        if s then
                            SetNewWaypoint(gps.x, gps.y)
                            coolcoolmec(3500)
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Supprime l'appel", nil, Config.RightLab, not cooldown, function(_,_,s)
                        if s then
                            TriggerServerEvent('eAmbulance:CloseReport',nom, raison)
                            RageUI.CloseAll()
                        end
                    end)

                end, function() 
                end)

                RageUI.IsVisible(eInteractEMS, true, true, true, function()

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Faire un test d'alcoolèmie",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if (Selected) then
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            AlcoolEnos()
                            RageUI.CloseAll()
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                        end
                    end 
                end)

                RageUI.ButtonWithStyle("Faire un test de drogue",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            DrugsEnos()
                            RageUI.CloseAll()
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                        end
                    end 
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Connaître la cause de la mort",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestDistance > 1.0 then
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                        else
                        deathcause()
                        coolcoolmec(3500)
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Connaître la cause de la blessure",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        local bone
                        local success = GetPedLastDamageBone(player,bone)
            
                        local success,bone = GetPedLastDamageBone(player)
                        if success then
                            --print(bone)
                            local x,y,z = table.unpack(GetPedBoneCoords(player, bone))
                              Notification(x,y,z)
                              coolcoolmec(3500)
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                        end
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Réanimation", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
                    if Selected then 
                        ESX.TriggerServerCallback("eAmbulance:checkitem", function(haveitem)
                            if haveitem then
                                Canrevive = true
                            end
                        end, "medikit")
                
                        if Canrevive then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 1.0 then
                                RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                            else
                                TriggerServerEvent("eAmbulance:delitem", "medikit")
                                revivePlayer(closestPlayer) 
                            end
                            coolcoolmec(3500)
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Vous avez besoin d'un kit de soin"})
                        end
                
                    end
                end)

                RageUI.ButtonWithStyle("Petite blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
                    if (Selected) then 
                
                        ESX.TriggerServerCallback("eAmbulance:checkitem", function(haveitem)
                            if haveitem then
                                Cansmallheal = true
                            end
                        end, "compresse")
                
                        if Cansmallheal then
                
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 1.0 then
                                RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                            else
                                local closestPlayerPed = GetPlayerPed(closestPlayer)
                                local health = GetEntityHealth(closestPlayerPed)
        
                                if health > 0 then
                                    local playerPed = PlayerPedId()
                                    TriggerServerEvent("eAmbulance:delitem", "compresse")
        
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~o~Vous soignez la personne. . ."})
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                    Citizen.Wait(10000)
                                    ClearPedTasks(playerPed)
        
                                    TriggerServerEvent('eAmbulance:removeItem', 'bandage')
                                    TriggerServerEvent('eAmbulance:heal', GetPlayerServerId(closestPlayer), 'small')
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~g~Vous avez soigniez la personne..."})
                                else
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~o~Cette personne est inconsciente..."})
                                end
                            end
                            coolcoolmec(3500)
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Vous avez besoin de compresse"})
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Grande blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
                    if (Selected) then 
                
                        ESX.TriggerServerCallback("eAmbulance:checkitem", function(haveitem)
                            if haveitem then
                                Canheal = true
                            end
                        end, "bandage")
                
                        if Canheal then
                
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 1.0 then
                                RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Aucune personne à proximité"})
                            else
                                local closestPlayerPed = GetPlayerPed(closestPlayer)
                                local health = GetEntityHealth(closestPlayerPed)
        
                                if health > 0 then
                                    local playerPed = PlayerPedId()
                                    TriggerServerEvent("eAmbulance:delitem", "bandage")
        
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~o~Vous soignez la personne. . ."})
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                    Citizen.Wait(10000)
                                    ClearPedTasks(playerPed)
        
                                    TriggerServerEvent('eAmbulance:heal', GetPlayerServerId(closestPlayer), 'big')
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~g~Vous avez soigniez la personne..."})
                                else
                                    RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~o~Cette personne est inconsciente..."})
                                end
                            end
                            coolcoolmec(3500)
                        else
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Vous avez besoin de bandage"})
                        end
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Remplir une fiche médicale",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        startScenario('WORLD_HUMAN_CLIPBOARD')
                        PanelChargement = true
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Sortir un fauteuil roulant",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        ExecuteCommand("wheelchair")
                        fofo = true
                        coolcoolmec(3500)
                    end
                end)

                if fofo == true then 
                    RageUI.ButtonWithStyle("Ranger le fauteuil roulant",nil, Config.RightLab, not cooldown, function(Hovered, Active, Selected)
                        if Selected then 
                            ExecuteCommand("removewheelchair")
                            fofo = false
                        end
                    end)
                end

                RageUI.ButtonWithStyle("Ouvrir/Fermer les portes", nil, Config.RightLab, not cooldown, function(Hovered,Active,Selected)
                    if Selected then
                        TriggerEvent("ARPF-EMS:opendoors")
                        coolcoolmec(3500)
                    end
                end)



                if PanelChargement == true then
                    RageUI.PercentagePanel(Percentage or 0.0, "Chargement de la fiche médicale ... ("..math.floor(Percentage * 100).."%)", "", "",  function(Hovered, Active, Percent)
                        if Percentage < 1.0 then Percentage = Percentage + 0.004 else RageUI.Visible(gotofiche, not RageUI.Visible(gotofiche)) end end) end
                end, function() 
                end)


                RageUI.IsVisible(objets, true, true, true, function()
                    
                    RageUI.ButtonWithStyle("Ambulance", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, objets1)
            
                    RageUI.ButtonWithStyle("Mode suppression", "Supprimer des objets", { RightLabel = "XXX" }, true, function(Hovered, Active, Selected)
                    end, objets2)

                end, function() 
                end)

                RageUI.IsVisible(objets1, true, true, true, function()

                    RageUI.ButtonWithStyle("Cone", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SpawnObj("prop_roadcone02a")
                        end
                    end)
                    RageUI.ButtonWithStyle("Barrière", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SpawnObj("prop_barrier_work05")
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Gros carton", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SpawnObj("prop_boxpile_07d")
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Fauteil roulant", nil, {}, not cooldown, function(Hovered, Active, Selected)
                        if Selected then
                            local wheelchair = CreateObject(GetHashKey('prop_wheelchair_01'), GetEntityCoords(PlayerPedId()), true)
                            coolcoolmec(3500)
                        end
                    end)
            
                end, function()
                end)
            
                RageUI.IsVisible(objets2, true, true, true, function()

                    RageUI.ButtonWithStyle("Ranger le fauteil roulant", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_wheelchair_01'))

                            if DoesEntityExist(wheelchair) then
                                DeleteEntity(wheelchair)
                            end
                        end
                    end)

                    for k,v in pairs(object) do
                        if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
                        RageUI.ButtonWithStyle("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(Hovered, Active, Selected)
                            if Active then
                                local entity = NetworkGetEntityFromNetworkId(v)
                                local ObjCoords = GetEntityCoords(entity)
                                DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                            end
                            if Selected then
                                RemoveObj(v, k)
                            end
                        end)
                    end
                    
                end, function()
                end)

                RageUI.IsVisible(gotofiche, true, true, true, function()

                    PanelChargement = false
                    Percentage = 0.0

                    RageUI.ButtonWithStyle("Prénom : ~b~"..notNilString(ficheBuilder.firstname), "~r~Prénom : ~s~"..notNilString(ficheBuilder.firstname), { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            ficheBuilder.firstname = KeyboardInput("Prénom", "", 10)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Nom : ~b~"..notNilString(ficheBuilder.lastname), "~r~Nom : ~s~"..notNilString(ficheBuilder.lastname), { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            ficheBuilder.lastname = KeyboardInput("Nom", "", 10)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Motif : ~b~"..notNilString(ficheBuilder.reason), "~r~Motif : ~s~"..notNilString(ficheBuilder.reason), { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            ficheBuilder.reason = KeyboardInput("Raison", "", 100)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("~g~Ajouter", nil, { RightLabel = "→→" }, ficheBuilder.firstname ~= nil and ficheBuilder.lastname ~= nil and ficheBuilder.reason ~= nil, function(_,_,s)
                        if s then
                            local playerPed = PlayerPedId()
                            RageUI.CloseAll()
                            TriggerServerEvent("ambu:ficheAdd", ficheBuilder)
                            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~g~Fiche médicale de l'individu ajouté"})
                            ClearPedTasks(playerPed)
                            resetinfofo()
                        end
                    end)

                end, function()
                end)    

        if not RageUI.Visible(eAmbulancef6) and not RageUI.Visible(eAmbulancef6Annonces) and not RageUI.Visible(eAmbulanceappel) and not RageUI.Visible(eAmbulanceappelinfo) and not RageUI.Visible(eInteractEMS) and not RageUI.Visible(objets) and not RageUI.Visible(objets1) and not RageUI.Visible(objets2) and not RageUI.Visible(gotofiche) then
            eAmbulancef6 = RMenu:DeleteType("Ambulance", true)
        end
    end
end

Keys.Register("F6", 'Ambulance', 'Ouvrir le menu ambulance', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
    	F6Ambulance()
	end
end)

function resetinfofo()
    ficheBuilder.firstname = nil
    ficheBuilder.lastname = nil
    ficheBuilder.reason = nil
end

function VehicleInFront()
    local player = PlayerPedId()
      local pos = GetEntityCoords(player)
      local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 2.0, 0.0)
      local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, player, 0)
      local _, _, _, _, result = GetRaycastResult(rayHandle)
      return result
end

local open = false

RegisterNetEvent("ARPF-EMS:opendoors")
AddEventHandler("ARPF-EMS:opendoors", function()
    veh = VehicleInFront()
    if open == false then
        open = true
        SetVehicleDoorOpen(veh, 2, false, false)
        Citizen.Wait(1000)
        SetVehicleDoorOpen(veh, 3, false, false)
    elseif open == true then
        open = false
        SetVehicleDoorShut(veh, 2, false)
        SetVehicleDoorShut(veh, 3, false)
    end
end)

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

local function DrugsEnos()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	Wait(100)
	ESX.TriggerServerCallback('eAmbulance:getEnosStatus', function(status)
        if status.val == 0 then
            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Votre test multidrogue est négatif"})
            else
            RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Votre test multidrogue est positif"})
        end
    end, GetPlayerServerId(closestPlayer), 'drug')
end

local function AlcoolEnos()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	Wait(100)
	ESX.TriggerServerCallback('eAmbulance:getEnosStatus', function(status)
	if status.val == 0 then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Votre test alcool est négatif"})
		else
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~r~Votre test alcool est positif"})
	end
    end, GetPlayerServerId(closestPlayer), 'drunk')
end

function deathcause()

    local d = GetPedCauseOfDeath(player)		
    local playerPed = GetPlayerPed(-1)

    TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
    TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

    Citizen.Wait(5000)		

    ClearPedTasksImmediately(playerPed)

    if checkArray(Melee, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~ "..Config.PrefixName.." ~b~]\n~s~Probablement un ~r~choc violent~s~ a la tête."})
    elseif checkArray(Bullet, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Probablement touché par une ~r~balle~s~, il y a des impact dans le corps."})
    elseif checkArray(Knife, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Probablement touché par un ~r~objet coupant~s~."})
    elseif checkArray(Animal, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Probablement attaqué par un ~r~animal~s~."})
    elseif checkArray(FallDamage, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Il est ~r~tombé de haut~s~, il a les jambes cassé."})
    elseif checkArray(Explosion, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Il est presque completement défiguré par des ~r~explosifs~s~."})
    elseif checkArray(Gas, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Un ~r~gaz mortel~s~ a surement tué cette personne."})
    elseif checkArray(Burn, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Il est complètement ~r~brulé~s~."})
    elseif checkArray(Drown, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Il s'est ~r~noyé~s~."})
    elseif checkArray(Car, d) then
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~Il est surement mort du au ~r~choc de l'accident~s~."})
    else
        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~"..Config.PrefixName.."~b~]\n~s~La cause de la mort n'est pas identifiable"})
    end
end

function Notification(x,y,z)
    local timestamp = GetGameTimer()

    while (timestamp + 4500) > GetGameTimer() do
        Citizen.Wait(0)
        DrawText3D(x, y, z, 'The damage seems to occure here', 0.4)
        checking = false
    end
end

function revivePlayer(closestPlayer)
    local closestPlayerPed = GetPlayerPed(closestPlayer)

    if IsPedDeadOrDying(closestPlayerPed, 1) then
        local playerPed = PlayerPedId()
        local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
        RageUI.Popup({message = 'Réanimation en cours'})

        for i=1, 15 do
            Citizen.Wait(900)

            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end

        TriggerServerEvent('eAmbulance:revive', GetPlayerServerId(closestPlayer))
    else
        RageUI.Popup({message = 'N\'est pas inconscient'})
    end
end

RegisterNetEvent('eAmbulance:heal')
AddEventHandler('eAmbulance:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
        local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
        ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
            local health = GetEntityHealth(playerPed)
            local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
            SetEntityHealth(playerPed, newHealth)
		end)
	elseif healType == 'big' then
        local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
        ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
		SetEntityHealth(playerPed, maxHealth)
    end)
	end

	if not quiet then
		RageUI.Popup({message = 'Vous avez été soigné.'})
	end
end)


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
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

function SpawnObj(obj)
    local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    SpawnObject(obj, objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end)
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 2.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)

        if IsControlJustReleased(1, 38) then
            placed = true
        end
    end

    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    table.insert(object, NetId)

end


function RemoveObj(id, k)
    Citizen.CreateThread(function()
        SetNetworkIdCanMigrate(id, true)
        local entity = NetworkGetEntityFromNetworkId(id)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end
        SetEntityAsNoLongerNeeded(entity)

        local test = 0
        while test < 100 and DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
            DeleteEntity(entity)
            DeleteObject(entity)
            if not DoesEntityExist(entity) then 
                table.remove(object, k)
            end
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(1)
            test = test + 1
        end
    end)
end

function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end

function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end

function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function coolcoolmec(time)
    cooldown = true
    Citizen.SetTimeout(time,function()
        cooldown = false
    end)
end

RegisterNetEvent('eAmbulance:InfoService')
AddEventHandler('eAmbulance:InfoService', function(service, name)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('<C>Central '..Config.PrefixName, '~b~<C>Prise de service', '<C>Agent: ~g~'..name..'\n~w~Information: ~g~Prise de service.', 'CHAR_CHAT_CALL', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('<C>Central '..Config.PrefixName, '~b~<C>Fin de service', '<C>Agent: ~g~'..name..'\n~w~Information: ~g~Fin de service.', 'CHAR_CHAT_CALL', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('<C>Central '..Config.PrefixName, '~b~<C>Pause de service', '<C>Agent: ~g~'..name..'\n~w~Information: ~g~Pause de service.', 'CHAR_CHAT_CALL', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

RegisterNetEvent('renfort:setBlip')
AddEventHandler('renfort:setBlip', function(coords)
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    ESX.ShowAdvancedNotification('<C>Central '..Config.PrefixName, '~b~<C>Demande d\'aide', '<C>Demande de renfort demandé.', 'CHAR_CHAT_CALL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    color = 2
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande de renfort')
	EndTextCommandSetBlipName(blipId)
	Wait(80 * 1000)
	RemoveBlip(blipId)
end)