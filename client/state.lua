---@class State
---@field isFueling boolean
---@field nearestPump vector3?
---@field lastVehicle number?
local state = {
  isFueling = false,
  lastVehicle = cache.vehicle or GetPlayersLastVehicle()
}

if state.lastVehicle == 0 then state.lastVehicle = nil end

return state
