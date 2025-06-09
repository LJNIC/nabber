--- @class Pull : Action
--- @overload fun(owner: Actor, pushableObject: Actor, direction: Vector2): Action
local Pull = prism.Action:extend "Pull"
Pull.requiredComponents = { prism.components.Mover }
Pull.targets = { prism.targets.PushTarget(), prism.targets.DirectionTarget() }

--- @param level Level
--- @param pushableObject Actor
--- @param direction Vector2
function Pull:canPerform(level, pushableObject, direction)
   local destination = self.owner:getPosition() + direction
   return level:getCellPassable(
      destination.x,
      destination.y,
      self.owner:expect(prism.components.Mover).mask
   )
end

--- @param level Level
--- @param pushableObject Actor
--- @param direction Vector2
function Pull:perform(level, pushableObject, direction)
   local pulledDestination = self.owner:getPosition()
   local ownerDestination = self.owner:getPosition() + direction

   level:moveActor(self.owner, ownerDestination)
   level:moveActor(pushableObject, pulledDestination)
end

return Pull
