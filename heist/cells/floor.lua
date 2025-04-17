local palette = require "palette"

---@class FloorCell : Cell
local Floor = prism.Cell:extend("FloorCell")

Floor.name = "FLOOR"
Floor.passable = true
Floor.opaque = false
Floor.drawable = prism.components.Drawable(271, palette[11], palette[3])
Floor.allowedMovetypes = { "walk" }

return Floor
