local palette = require "palette"
--- @class BridgeActor : Actor
local Bridge = prism.Actor:extend("BridgeActor")
Bridge.name = "Bridge"

function Bridge:initialize()
   return {
      prism.components.Drawable(257, palette[16], palette[1]),
      prism.components.Ability(prism.actions.Bridge)
  }
end

return Bridge
