local palette = require "palette"
--- @class DecoyActor : Actor
local Decoy = prism.Actor:extend("DecoyActor")
Decoy.name = "Decoy"

function Decoy:initialize()
   return {
      prism.components.Drawable(5, palette[9], palette[3]),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 5, fov = true },
      prism.components.Moveable(),
      prism.components.DecoyController(),
      prism.components.Suspicious(),
      prism.components.Health(1)
  }
end

return Decoy
