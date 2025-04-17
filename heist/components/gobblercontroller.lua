---@class GobblerControllerComponent : ControllerComponent
local GobblerController = prism.components.Controller:extend("GobblerControllerComponent")
GobblerController.name = "GobblerController"

function GobblerController:__new()
  self.first = false
end

---@param level Level
---@param actor Actor
---@return Action
function GobblerController:act(level, actor)
  if not self.first then
    self.first = true
    return prism.actions.Wait()
  end

  local sight = actor:getComponent(prism.components.Sight)
  if sight.direction == prism.Vector2.RIGHT then
    actor:getComponent(prism.components.Drawable):switch("down")
    sight.direction = prism.Vector2.DOWN 
  elseif sight.direction == prism.Vector2.DOWN then
    actor:getComponent(prism.components.Drawable):switch("left")
    sight.direction = prism.Vector2.LEFT
  elseif sight.direction == prism.Vector2.LEFT then
    actor:getComponent(prism.components.Drawable):switch("up")
    sight.direction = prism.Vector2.UP
  elseif sight.direction == prism.Vector2.UP then
    actor:getComponent(prism.components.Drawable):switch("right")
    sight.direction = prism.Vector2.RIGHT
  end

  return prism.actions.Wait()
end

return GobblerController
