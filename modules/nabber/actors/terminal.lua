local palette = require "display.palette"

prism.registerActor("Terminal", function()
   return prism.Actor.fromComponents {
      prism.components.Drawable(301, palette[15], palette[6]),
      prism.components.Collider(),
      prism.components.Hackable(true),
   }
end)
