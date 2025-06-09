--- @class Push : Action
local Push = prism.Action:extend("Push")
Push.requiredComponents = { prism.components.Mover }

Push.targets = { prism.targets.PushTarget(), prism.targets.DirectionTarget() }

local pushMask = prism.Collision.createBitmaskFromMovetypes { "walk" }

--- @param level Level
--- @param pushableObject Actor
--- @param direction Vector2
function Push:canPerform(level, pushableObject, direction)
   local destination = pushableObject:getPosition() + direction
   return level:getCellPassable(destination.x, destination.y, pushMask)
end

--- @param level Level
--- @param pushableObject Actor
--- @param direction Vector2
function Push:perform(level, pushableObject, direction)
   local pushedDestination = pushableObject:getPosition() + direction
   local ownerDestination = pushableObject:getPosition()

   level:moveActor(pushableObject, pushedDestination)
   level:moveActor(self.owner, ownerDestination)
end

return Push
