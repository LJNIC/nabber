local palette = require "palette"
--- @class GrappleActor : Actor
local Grapple = prism.Actor:extend("GrappleActor")
Grapple.name = "Grapple"

function Grapple:initialize()
   return {
      prism.components.Drawable(31, palette[16], palette[3]),
      prism.components.Ability(prism.actions.Grapple)
  }
end

return Grapple
