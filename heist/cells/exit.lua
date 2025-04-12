local palette = require "palette"

---@class ExitCell : Cell
local Exit = prism.Cell:extend("ExitCell")

Exit.name = "BRIDGE"
Exit.passable = true
Exit.opaque = false
Exit.drawable = prism.components.Drawable(294, palette[6])

return Exit
