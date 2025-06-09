local palette = require "display.palette"

prism.registerActor("Sentry", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Sentry"),
      prism.components.Drawable(349, palette[27], palette[6]),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 2, fov = true },
      prism.components.Mover { "walk" },
      prism.components.Alarm(),
      prism.components.SentryContoller(),
   }
end)
