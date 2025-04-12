---@class AttackerComponent : Component
---@field ramming boolean
local Attacker = prism.Component:extend("AttackerComponent")
Attacker.name = "Attacker"
Attacker.actions = {
  prism.actions.Attack
}

function Attacker:__new(ramming)
  self.ramming = ramming
end

return Attacker
