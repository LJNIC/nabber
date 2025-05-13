local palette = require "display.palette"

--- @class Wall : Cell
local Wall = prism.Cell:extend("Wall")

function Wall:initialize()
  return {
    prism.components.Drawable(239, palette[7], palette[6]),
    prism.components.Collider(),
    prism.components.Opaque()
  }
end

return Wall
