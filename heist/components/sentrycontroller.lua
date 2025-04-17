local behavior = require "heist.behaviors.sentry"

---@class SentryControllerComponent : ControllerComponent
---@field moved boolean
---@field root BTRoot
local SentryController = prism.components.Controller:extend("SentryControllerComponent")
SentryController.name = "SentryController"
SentryController.requirements = {
  prism.components.Alarm,
  prism.components.Senses,
  prism.components.Moveable
}

function SentryController:__new()
  self.direction = 2
  self.root = behavior
end

---@param level Level
---@param actor Actor
---@return Action
function SentryController:act(level, actor)
  return self.root:run(level, actor, self)
end

return SentryController
