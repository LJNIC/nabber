---@class DecoyControllerComponent : ControllerComponent
---@field direction Vector2
local DecoyController = prism.components.Controller:extend("DecoyControllerComponent")
DecoyController.name = "DecoyController"
DecoyController.actions = {
  prism.actions.Wait
}

function DecoyController:__new()
  self.direction = prism.Vector2.RIGHT
  self.first = false
end

---@param level Level
---@param actor Actor
---@return Action
function DecoyController:act(level, actor)
  if not self.first then
    self.first = true
    return prism.actions.Wait()
  end

  local position = actor:getPosition() + self.direction
  if not level:getCellPassable(position:decompose()) then
    return prism.actions.Wait()
  end

  ---@type Action
  local move = actor:getAction(prism.actions.Move)
  local action = move(actor, { position })
  if action:canPerform(level) then
    return action
  else
    return prism.actions.Wait()
  end
end

return DecoyController
