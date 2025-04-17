local palette = require "palette"
--- @class SentryActor : Actor
local Sentry = prism.Actor:extend("SentryActor")
Sentry.name = "Sentry"

function Sentry:initialize()
   return {
      prism.components.Drawable(349, palette[7], palette[3]),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 2, fov = true },
      prism.components.Moveable{ "walk" },
      prism.components.Alarm(),
      prism.components.SentryController(),
      prism.components.Attacker(true),
      prism.components.Health(2)
  }
end

return Sentry
