local GrappleTarget = prism.Target:extend("GrappleTarget")
GrappleTarget.typesAllowed = { Point = true }

---@class GrappleAction : Action
---@field forced boolean
local Grapple = prism.Action:extend("GrappleAction")
Grapple.name = "move"
Grapple.targets = { GrappleTarget }

---@param level Level
function Grapple:_canPerform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  ---@type Cell
  local previous = nil
  for i = 1, 5 do
    local target = self.owner:getPosition() + (direction * i)
    local cell = level:getCell(target:decompose())
    if cell == prism.cells.Wall then
      return previous == nil or previous.passable
    end
    previous = cell
  end

  return false
end

---@param level Level
function Grapple:_perform(level)
  ---@type Vector2
  local direction = self:getTarget(1)
  for i = 1, 5 do
    local target = self.owner:getPosition() + (direction * i)
    local cell = level:getCell(target:decompose())
    if cell == prism.cells.Wall then
      local position = self.owner:getPosition() + (direction * (i - 1))
      self.previousPosition = self.owner:getPosition()
      self.distance = i
      level:moveActor(self.owner, position, false)
    end
  end
end

return Grapple
