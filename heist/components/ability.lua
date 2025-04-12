---@class AbilityComponent : Component
local Ability = prism.Component:extend("AbilityComponent")
Ability.name = "Ability"

function Ability:__new(actionPrototype)
  self.actionPrototype = actionPrototype
end

return Ability
