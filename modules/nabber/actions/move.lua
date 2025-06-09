local PointTarget = prism.Target():isPrototype(prism.Vector2):range(1)

---@class Move : Action
---@field name string
---@field targets Target[]
---@field previousPosition Vector2
---@overload fun(owner: Actor, destination: Vector2): Action
local Move = prism.Action:extend("Move")
Move.name = "move"
Move.targets = { PointTarget }

function Move:getRequirements()
   return prism.components.Controller, prism.components.Mover
end

--- @param level Level
--- @param destination Vector2
function Move:getFinalDestination(level, destination)
   local cell = level:getCell(destination:decompose())

   while cell:has(prism.components.Skippable) do
      local direction = (destination - self.owner:getPosition())
      local unit = direction * (1 / direction:length())
      destination = destination + unit
      cell = level:getCell(destination:decompose())
   end

   return destination
end

--- @param level Level
--- @param destination Vector2
function Move:canPerform(level, destination)
   local mover = self.owner:expect(prism.components.Mover)
   local passable = level:getCellPassable(destination.x, destination.y, mover.mask)

   if passable then destination = self:getFinalDestination(level, destination) end

   return level:getCellPassable(destination.x, destination.y, mover.mask)
end

--- @param level Level
--- @param destination Vector2
function Move:perform(level, destination)
   destination = self:getFinalDestination(level, destination)
   level:moveActor(self.owner, destination)
end

return Move
