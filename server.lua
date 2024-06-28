ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('aybgearbox:changeGear')
AddEventHandler('aybgearbox:changeGear', function(vehicle, gear)
    TriggerClientEvent('aybgearbox:syncGear', -1, vehicle, gear)
end)
