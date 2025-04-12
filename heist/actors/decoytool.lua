local palette = require "palette"
--- @class DecoyTool : Actor
local DecoyTool = prism.Actor:extend("DecoyToolActor")
DecoyTool.name = "Decoy"

function DecoyTool:initialize()
   return {
      prism.components.Drawable(5, palette[9], palette[3]),
      prism.components.Ability(prism.actions.Decoy)
  }
end

return DecoyTool
