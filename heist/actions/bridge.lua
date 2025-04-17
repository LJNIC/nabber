---@class BridgeAction : Action
local Bridge = prism.Action:extend("BridgeAction")

local PointTarget = prism.Target:extend("BridgeTarget")
PointTarget.typesAllowed = { Point = true }

Bridge.targets = { PointTarget }

---@param level Level
---@param direction Vector2
function Bridge:_canPerform(level, direction)
  local target = self.owner:getPosition() + direction

  return level:getCell(target:decompose()).void == true
end

---@param level Level
---@param direction Vector2
function Bridge:_perform(level, direction)
  for i = 1, 3 do
    local target = (direction * i) + self.owner:getPosition()
    if level:getCell(target:decompose()).void == true then
      level:setCell(target.x, target.y, prism.cells.Bridge)
    end
  end
end

return Bridge
