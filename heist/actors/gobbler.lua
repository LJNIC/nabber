local palette = require "palette"
--- @class GobblerActor : Actor
local Gobbler = prism.Actor:extend("GobblerActor")
Gobbler.name = "Gobbler"

function Gobbler:initialize()
   return {
      prism.components.Drawable(322, palette[7], palette[3], { 
         right = { index = 321 },
         left = { index = 322 },
         up = { index = 323 },
         down = { index = 324 }
      }),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 3, fov = true, directional = true, startingDirection = prism.Vector2.LEFT },
      prism.components.Moveable(),
      prism.components.Alarm(),
      prism.components.Attacker(true),
      prism.components.Health(2),
      prism.components.SentryController()
  }
end

return Gobbler
