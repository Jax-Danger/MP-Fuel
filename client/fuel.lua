--local cfg = require 'cfg'
local state = require 'client.state'
local utils = require 'client.utils'
local fuel = {}

---@param vehState StateBag
---@param vehicle integer
---@param amount number
---@param replicate? boolean
function fuel.setFuel(vehState, vehicle, amount, replicate)
  if DoesEntityExist(vehicle) then
    amount = math.clamp(amount, 0, 100)

    SetVehicleFuelLevel(vehicle, amount)
    vehState:set('fuel', amount, replicate)
  end
end

function fuel.startFueling(vehicle, isPump)
  local vehState = Entity(vehicle).state
  local fuelAmount = vehState.fuel or GetVehicleFuelLevel(vehicle)
  local duration = math.ceil((100 - fuelAmount) / cfg.refillValue) * cfg.refillTick
  local price, moneyAmount
  local durability = 0

  if 100 - fuelAmount < cfg.refillValue then
    return lib.notify({ type = 'error', description = locale('tank_full') })
  end

  if isPump then
    price = 0
    moneyAmount = utils.getMoney()

    if cfg.priceTick > moneyAmount then
      return lib.notify({
        type = 'error',
        description = locale('not_enough_money', cfg.priceTick)
      })
    end
  end

  state.isFueling = true

  TaskTurnPedToFaceEntity(cache.ped, vehicle, duration)
  Wait(500)

  CreateThread(function()
    lib.progressCircle({
      duration = duration,
      useWhileDead = false,
      canCancel = true,
      disable = {
        move = true,
        car = true,
        combat = true,
      },
      anim = {
        dict = isPump and 'timetable@gardener@filling_can' or 'weapon@w_sp_jerrycan',
        clip = isPump and 'gar_ig_5_filling_can' or 'fire',
      },
    })

    state.isFueling = false
  end)

  while state.isFueling do
    if isPump then
      price += cfg.priceTick

      if price + cfg.priceTick >= moneyAmount then
        lib.cancelProgress()
      end
    else
      break
    end

    fuelAmount += cfg.refillValue

    if fuelAmount >= 100 then
      state.isFueling = false
      fuelAmount = 100.0
    end

    Wait(cfg.refillTick)
  end

  ClearPedTasks(cache.ped)

  if isPump then
    TriggerServerEvent('ox_fuel:pay', price, fuelAmount, NetworkGetNetworkIdFromEntity(vehicle))
  else
    TriggerServerEvent('ox_fuel:updateFuelCan', durability, NetworkGetNetworkIdFromEntity(vehicle), fuelAmount)
  end
end

return fuel
