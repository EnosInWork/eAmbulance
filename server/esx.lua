if Config.Framework == "esx" then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.Framework == "newEsx" then 
    ESX = exports["es_extended"]:getSharedObject()
end