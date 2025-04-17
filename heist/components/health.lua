---@class HealthComponent : Component
---@field health integer
---@field maxHealth integer
---@overload fun(maxHealth: integer, health?: integer): HealthComponent
local Health = prism.Component:extend("HealthComponent")
Health.name = "Health"

function Health:__new(maxHealth, health)
  self.maxHealth = maxHealth
  self.health = health or maxHealth
end

return Health
