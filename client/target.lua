--local cfg = require 'cfg'
local state  = require 'client.state'
local utils  = require 'client.utils'
local fuel   = require 'client.fuel'

exports.ox_target:addModel(cfg.pumpModels, {
  {
    distance = 2,
    onSelect = function()
      if utils.getMoney() >= cfg.priceTick then
        if GetVehicleFuelLevel(state.lastVehicle) >= 100 then
          return lib.notify({ type = 'error', description = locale('vehicle_full') })
        end
        fuel.startFueling(state.lastVehicle, 1)
      else
        lib.notify({ type = 'error', description = locale('refuel_cannot_afford') })
      end
    end,
    icon = "fas fa-gas-pump",
    label = locale('start_fueling'),
    canInteract = function(entity)
      if state.isFueling or cache.vehicle or not DoesVehicleUseFuel(state.lastVehicle) then
        return false
      end

      return state.lastVehicle and #(GetEntityCoords(state.lastVehicle) - GetEntityCoords(cache.ped)) <= 3
    end
  },
})
