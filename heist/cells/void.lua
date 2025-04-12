---@class VoidCell : Cell
local Void = prism.Cell:extend("VoidCell")

Void.name = "VOID"
Void.passable = false
Void.opaque = false
Void.drawable = prism.components.Drawable(1, prism.Color4.BLACK, prism.Color4.BLACK)

return Void
