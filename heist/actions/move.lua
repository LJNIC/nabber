local PointTarget = prism.Target:extend("PointTarget")
PointTarget.typesAllowed = { Point = true }

---@class MoveAction : Action
---@field forced boolean
local Move = prism.Action:extend("MoveAction")
Move.name = "move"
Move.targets = { PointTarget }
Move.requiredComponents = {
  prism.components.Moveable
}

---@param level Level
---@param position Vector2
function Move:_canPerform(level, position)
  local mover = self.owner:expectComponent(prism.components.Moveable)
  return level:getCellPassable(position.x, position.y, mover.mask)
end

---@param level Level
---@param position Vector2
function Move:_perform(level, position)
  local direction = position - self.owner:getPosition()

  if self.owner:hasComponent(prism.components.PlayerController) then
    local treasure = level:getActorsAt(position:decompose())
    if treasure[1] and treasure[1]:is(prism.actors.Treasure) then
      level:removeActor(treasure[1])
      level:addComponent(self.owner, prism.components.HasTreasure)
    end

    if level:getCell(position:decompose()) == prism.cells.Exit and self.owner:hasComponent(prism.components.HasTreasure) then
      print("You win!")
      love.event.quit()
    end
  end

  level:moveActor(self.owner, position, false)

  local attacker = self.owner:getComponent(prism.components.Attacker)
  if attacker and attacker.ramming then
    local next = position + direction
    local actorAt = level:getActorsAt(next:decompose())[1]
    if actorAt and actorAt:hasComponent(prism.components.Suspicious) then
      prism.actions.Attack:validateTarget(1, self.owner, actorAt, {})
      local attack = prism.actions.Attack(self.owner, { actorAt })
      if attack:canPerform(level) then level:performAction(attack) end
    end
  end
end

return Move
