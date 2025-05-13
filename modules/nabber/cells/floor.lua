local palette = require "display.palette"

---@class Floor : Cell
local Floor = prism.Cell:extend("Floor")

function Floor:initialize()
  return {
    prism.components.Drawable(271, palette[5], palette[6]),
    prism.components.Collider({ allowedMovetypes = { "walk", "fly" }})
  }
end

return Floor
