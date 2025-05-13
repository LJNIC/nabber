---@class Pit : Cell
local Pit = prism.Cell:extend("Pit")

function Pit:initialize()
  return {
    prism.components.Drawable(1),
    prism.components.Collider({ allowedMovetypes = { "fly" }})
  }
end

return Pit
