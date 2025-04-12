local palette = require "palette"

--- @class WallCell : Cell
local Wall = prism.Cell:extend("WallCell")

Wall.name = "WALL" -- displayed in the user interface
Wall.passable = false -- defines whether a cell is passable
Wall.opaque = true -- defines whether a cell can be seen through
Wall.drawable = prism.components.Drawable(239, palette[16], palette[3])

return Wall
