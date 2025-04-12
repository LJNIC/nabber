local palette = require "palette"
--- @class TreasureActor : Actor
local Treasure = prism.Actor:extend("TreasureActor")
Treasure.name = "Treasure"

function Treasure:initialize()
   return {
      prism.components.Drawable(37, palette[9])
  }
end

return Treasure
