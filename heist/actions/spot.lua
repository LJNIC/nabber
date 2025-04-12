---@class SpotAction : Action
local Spot = prism.Action:extend("SpotAction")
Spot.name = "wait"

--- @class SpotTarget : Target
local SpotTarget = prism.Target:extend("SpotTarget")
SpotTarget.typesAllowed = { Actor = true }
Spot.targets = { SpotTarget }

---@param targetObject Actor
function SpotTarget:validate(owner, targetObject, targets)
  return targetObject:hasComponent(prism.components.Suspicious)
end

---@param level Level
function Spot:perform(level)
  local target = self:getTarget(1)
  print(self.owner.name .. " spotted " .. target.name)
  for actor in level:eachActor(prism.components.Alarm) do
    actor:getComponent(prism.components.Alarm).target = target
  end
end

return Spot
