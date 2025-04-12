---@class TargetComponent : Component
---@field actor Actor
local Target = prism.Component:extend("TargetComponent")
Target.name = "target"

function Target:__new()
  self.actor = nil
end

return Target
