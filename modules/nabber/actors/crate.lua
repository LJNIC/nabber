local palette = require "display.palette"

prism.registerActor("Crate", function()
   return prism.Actor.fromComponents {
      prism.components.Pushable(),
      prism.components.Drawable(302, palette[24], palette[6], 2),
      prism.components.Collider(),
   }
end)
