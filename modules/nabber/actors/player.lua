local palette = require "display.palette"

prism.registerActor("Player", function(index)
   return prism.Actor.fromComponents {
      prism.components.Drawable(index or 2, palette[20], palette[6], 2),
      prism.components.Name("Player"),

      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 2, fov = true },
      prism.components.Mover { "walk" },
   }
end)
