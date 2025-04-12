---@class DrillAction : Action
local Drill = prism.Action:extend("DrillAction")

local PointTarget = prism.Target:extend("DrillTarget")
PointTarget.typesAllowed = { Point = true }

Drill.targets = { PointTarget }

---@param level Level
function Drill:canPerform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local target = self.owner:getPosition() + direction

  return level:getCell(target:decompose()) == prism.cells.Wall
end

---@param level Level
function Drill:perform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  local target = self.owner:getPosition() + direction
  level:setCell(target.x, target.y, prism.cells.Floor)
end

return Drill
