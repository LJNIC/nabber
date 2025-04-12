---@class GearComponent : Component
local Gear = prism.Component:extend("GearComponent")
Gear.name = "Gear"

---@param item1 Actor
---@param item2 Actor
function Gear:__new(item1, item2)
  self.item1 = item1
  self.item2 = item2
  self.item1Uses = 3
  self.item2Uses = 3

  self.actions = {
    item1:getComponent(prism.components.Ability).actionPrototype,
    item2:getComponent(prism.components.Ability).actionPrototype
  }
end

return Gear
