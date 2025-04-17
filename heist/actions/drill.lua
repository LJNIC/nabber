---@class DrillAction : Action
local Drill = prism.Action:extend("DrillAction")
Drill.name = "Drill"

local PointTarget = prism.Target:extend("DrillTarget")
PointTarget.typesAllowed = { Point = true }

Drill.targets = { PointTarget }

---@param level Level
---@param direction Vector2
function Drill:_canPerform(level, direction)
  local target = self.owner:getPosition() + direction

  return level:getCell(target:decompose()).drillable == true
end

---@param level Level
function Drill:_perform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local target = self.owner:getPosition() + direction
  level:setCell(target.x, target.y, prism.cells.Floor())
end

return Drill
