---@class SentryBehavior : BTRoot
local SentryBehavior = prism.BehaviorTree.Root:extend("SentryBehavior")

SentryBehavior.children = {
  prism.BehaviorTree.Sequence {
    -- Do we have a target?
    prism.BehaviorTree.Node(function (self, level, actor, controller)
      local alarm = actor:getComponent(prism.components.Alarm)
      if alarm.target then return true end
      return false
    end),
    -- Hit them if we're close enough
    prism.BehaviorTree.Node(function (self, level, actor, controller)
      local target = actor:getComponent(prism.components.Alarm).target
      if actor:getPosition():getRange("manhattan", target:getPosition()) == 1 then
        local attack = prism.actions.Attack(actor, { target })
        return attack:canPerform(level) and attack
      end
      return true
    end),
    -- Otherwise try to move towards them
    prism.BehaviorTree.Node(function (self, level, actor, controller)
      local target = actor:getComponent(prism.components.Alarm).target
      local path = level:findPath(actor:getPosition(), target:getPosition(), 1, actor:getComponent(prism.components.Moveable).mask)
      if path and path:length() > 0 then
        local move = prism.actions.Move(actor, { path:pop() })
        return move:canPerform(level) and move
      end

      return false
    end)
  },
  prism.BehaviorTree.Node(function (self, level, actor, controller)
    local direction = controller.direction
    local destination = actor:getPosition() + prism.Vector2.neighborhood4[direction]
    if not level:getCellPassable(destination.x, destination.y, actor:getComponent(prism.components.Moveable).mask) then
      direction = direction + 1
      if direction > 4 then direction = 1 end
      destination = actor:getPosition() + prism.Vector2.neighborhood4[direction]
      controller.direction = direction
    end

    local move = prism.actions.Move(actor, { destination })
    if move:canPerform(level) then
      return move
    else 
      return prism.actions.Wait()
    end
  end)
}

return SentryBehavior
