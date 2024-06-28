local currentGear = 0  -- Vitesse actuelle (0 pour le point mort)
local maxGears = 6  -- Nombre maximum de vitesses (y compris le point mort)

function ChangeGear(vehicle, gear)
    if gear >= 0 and gear <= maxGears then
        -- Ajustement des paramètres de conduite du véhicule
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront", 0.0)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", 0.0)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia", 1.0)

        local driveForce = 0.0
        local driveInertia = 1.0

        if gear > 0 then
            if gear == 1 then
                driveForce = 0.27
                driveInertia = 0.10
                SetVehicleEngineAudio(vehicle, "V8_LOW")  -- Synchronisation du son du moteur
            elseif gear == 2 then
                driveInertia = 0.50
                SetVehicleEngineAudio(vehicle, "V8_MID")  -- Synchronisation du son du moteur
            elseif gear == 3 then
                driveForce = 0.30
                SetVehicleEngineAudio(vehicle, "V8_HIGH")  -- Synchronisation du son du moteur
            elseif gear == 4 then
                driveForce = 0.25
                SetVehicleEngineAudio(vehicle, "V8_HIGH")  -- Synchronisation du son du moteur
            elseif gear == 5 then
                driveInertia = 0.20
                SetVehicleEngineAudio(vehicle, "V8_HIGHEST")  -- Synchronisation du son du moteur
            elseif gear == 6 then
                driveForce = 0.20
                SetVehicleEngineAudio(vehicle, "V8_HIGHEST")  -- Synchronisation du son du moteur
            end
        else
            -- Configuration pour le point mort (vitesse 0)
            driveForce = 0.0  
            driveInertia = 1.0 
            SetVehicleEngineAudio(vehicle, "IDLE") 
        end

        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", driveForce)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia", driveInertia)

        currentGear = gear
        TriggerServerEvent('aybgearbox:changeGear', vehicle, gear)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                if IsControlJustPressed(0, 38) then  -- Touche "E" pour passer une vitesse
                    currentGear = currentGear + 1
                    if currentGear > maxGears then
                        currentGear = maxGears
                    end
                    ChangeGear(vehicle, currentGear)
                elseif IsControlJustPressed(0, 34) then  -- Touche "A" pour rétrograder
                    currentGear = currentGear - 1
                    if currentGear < 0 then 
                        currentGear = 0
                    end
                    ChangeGear(vehicle, currentGear)
                end
            end
        end
    end
end)
