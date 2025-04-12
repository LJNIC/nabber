local palette = require "palette"
--- @class DrillActor : Actor
local Drill = prism.Actor:extend("DrillActor")
Drill.name = "Drill"

function Drill:initialize()
   return {
      prism.components.Drawable(27, palette[13], palette[3]),
      prism.components.Ability(prism.actions.Drill)
  }
end

return Drill
