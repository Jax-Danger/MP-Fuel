
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage("setVisible", shouldShow)
end

RegisterNUICallback("hideFrame", function(_, cb)
  toggleNuiFrame(false)
  cb("ok")
end)

RegisterNUICallback('getFuel', function(data, cb)
  local ped = GetPlayerPed(-1)
  if not IsPedInAnyVehicle(ped, false) then
    cb(false)
    return
  end

  local vehicle = GetVehiclePedIsIn(ped, false)
  local fuel = GetVehicleFuelLevel(vehicle)
  local formattedFuel = string.format("%.2f", fuel)
  cb(tonumber(formattedFuel))
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
      SendReactMessage('setVisible', true)
      break
    else
      toggleNuiFrame(false)
    end
  end
end)
