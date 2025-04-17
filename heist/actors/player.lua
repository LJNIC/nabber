local palette = require "palette"
--- @class PlayerActor : Actor
local Player = prism.Actor:extend("PlayerActor")
Player.name = "Player"

function Player:initialize()
   return {
      prism.components.Drawable(2, palette[2], palette[3]),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 6, fov = true },
      prism.components.Moveable { "walk" },
      prism.components.Health(6),
      prism.components.Suspicious(),
      prism.components.Attacker()
  }
end

return Player
