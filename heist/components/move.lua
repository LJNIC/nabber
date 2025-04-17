---@class MoveableComponent : Component
---@field mask integer
local Moveable = prism.Component:extend("MoveableComponent")
Moveable.name = "Moveable"

function Moveable:__new(movetypes)
  if movetypes then
    self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
  end
end

return Moveable
