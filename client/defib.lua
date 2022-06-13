local defibItemName = 'medikit'

if Config.Defibrilateur then 
  RegisterNetEvent('esx_extraitems:defib')
  AddEventHandler('esx_extraitems:defib', function(source)
    TriggerServerEvent('defib:getAmbulancesCount')
  end)

  RegisterNetEvent("defib:useDefib")
  AddEventHandler("defib:useDefib", function(ambulancesConnected)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if ambulancesConnected > 0 then
      RageUI.Popup({message = "<C>~r~Médecin disponible, contactez un EMS au plus vite !"})
    elseif closestPlayer == -1 or closestDistance > 3.0 then
      RageUI.Popup({message = "<C>~r~Aucune personne à proximité"})
    else
      ESX.TriggerServerCallback('eAmbulance:getItemAmount', function(qtty)
        if qtty > 0 then
          local closestPlayerPed = GetPlayerPed(closestPlayer)
          local health = GetEntityHealth(closestPlayerPed)
          
          if health == 0 then
            local playerPed = GetPlayerPed(-1)
            

            RageUI.Popup({message = "<C>~g~Réanimation en cours"})
            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            Citizen.Wait(10000)
            ClearPedTasks(playerPed)
            
            TriggerServerEvent('eAmbulance:removeItem',defibItemName)
            TriggerServerEvent('eAmbulance:revive', GetPlayerServerId(closestPlayer))
          else
            ESX.ShowNotification("----1")
          end
        else
          ESX.ShowNotification("----2")
        end
      end, defibItemName)
    end
  end)
end