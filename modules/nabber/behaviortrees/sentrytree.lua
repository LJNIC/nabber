---@class SentryBehavior : BehaviorTree.Root
local SentryBehavior = prism.BehaviorTree.Root:extend("SentryBehavior")

SentryBehavior.children = {
   prism.BehaviorTree.Sequence {
      -- Do we have a target?
      prism.BehaviorTree.Node(function(self, level, actor, controller)
         local alarm = actor:get(prism.components.Alarm)
         if alarm and alarm.target then return true end
         return false
      end),
      -- Otherwise try to move towards them
      prism.BehaviorTree.Node(function(self, level, actor, controller)
         local target = actor:get(prism.components.Alarm).target
         local path = level:findPath(
            actor:getPosition(),
            target:getPosition(),
            1,
            actor:get(prism.components.Moveable).mask
         )
         if path and path:length() > 0 then
            local move = prism.actions.Move(actor, path:pop())
            return level:canPerform(move) and move
         end

         return false
      end),
   },
   -- Finally, continue doing the rounds
   prism.BehaviorTree.Node(function(self, level, actor, controller)
      --- @cast controller SentryContoller
      local direction = controller.currentDirection
      local destination = actor:getPosition() + prism.Vector2.neighborhood4[direction]
      if
         not level:getCellPassable(
            destination.x,
            destination.y,
            actor:get(prism.components.Mover).mask
         )
      then
         direction = direction + 1
         if direction > 4 then direction = 1 end
         destination = actor:getPosition() + prism.Vector2.neighborhood4[direction]
         controller.currentDirection = direction
      end

      local move = prism.actions.Move(actor, destination)
      if level:canPerform(move) then
         return move
      else
         return prism.actions.Wait(actor)
      end
   end),
}

prism.behaviors.Sentry = SentryBehavior

return SentryBehavior
