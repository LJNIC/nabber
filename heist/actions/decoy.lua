---@class DecoyAction : Action
local Decoy = prism.Action:extend("DecoyAction")

local PointTarget = prism.Target:extend("DecoyTarget")
PointTarget.typesAllowed = { Point = true }

Decoy.targets = { PointTarget }

---@param level Level
function Decoy:_canPerform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local target = self.owner:getPosition() + direction

  return level:getCellPassable(target.x, target.y, self.owner:getComponent(prism.components.Moveable).mask)
end

---@param level Level
function Decoy:_perform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local position = self.owner:getPosition() + direction
  local decoy = prism.actors.Decoy()
  level:addActor(decoy)
  decoy:getComponent(prism.components.DecoyController).direction = direction
  level:moveActor(decoy, position, false)
end

return Decoy
