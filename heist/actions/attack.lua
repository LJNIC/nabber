---@class AttackAction : Action
local Attack = prism.Action:extend("AttackAction")
Attack.name = "attack"

--- @class AttackTarget : Target
local AttackTarget = prism.Target:extend("AttackTarget")
AttackTarget.typesAllowed = { Actor = true }
Attack.targets = { AttackTarget }

function AttackTarget:validate(owner, targetObject, targets)
   return targetObject:hasComponent(prism.components.Health)
end

---@param level Level
function Attack:perform(level)
  ---@type Actor
  local target = self:getTarget(1)
  local health = target:getComponent(prism.components.Health)
  health.health = health.health - 2
  print(self.owner.name .. " attacks " .. target.name)
  if health.health <= 0 and not target:hasComponent(prism.components.PlayerController) then
    level:removeActor(target)
  end
end

return Attack
