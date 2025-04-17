---@class AttackerComponent : Component
---@field ramming boolean
local Attacker = prism.Component:extend("AttackerComponent")
Attacker.name = "Attacker"

function Attacker:__new(ramming)
  self.ramming = ramming
end

return Attacker
