---@class BridgeAction : Action
local Bridge = prism.Action:extend("BridgeAction")

local PointTarget = prism.Target:extend("BridgeTarget")
PointTarget.typesAllowed = { Point = true }

Bridge.targets = { PointTarget }

---@param level Level
function Bridge:canPerform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local target = self.owner:getPosition() + direction

  return level:getCell(target:decompose()) == prism.cells.Void
end

---@param level Level
function Bridge:perform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  for i = 1, 3 do
    local target = (direction * i) + self.owner:getPosition()
    if level:getCell(target:decompose()) == prism.cells.Void then
      level:setCell(target.x, target.y, prism.cells.Bridge)
    end
  end
end

return Bridge
