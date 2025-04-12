---@class MoveableComponent : Component
local Moveable = prism.Component:extend("MoveableComponent")
Moveable.name = "Moveable"
Moveable.actions = {
  prism.actions.Move,
  prism.actions.Wait
}

return Moveable
