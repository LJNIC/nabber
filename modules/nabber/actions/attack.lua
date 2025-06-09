--- @class Attack : Action
local Attack = prism.Action:extend "Attack"
Attack.targets = { prism.targets.PushTarget() }

function Attack:canPerform()
   return true
end

--- Perform
---@param level Level
---@param target Actor
function Attack:perform(level, target)
   level:removeActor(target)
   local x, y = target:getPosition():decompose()
   local debris = prism.actors.BrokenBox()
   level:addActor(debris)
   level:moveActor(debris, prism.Vector2(x, y))

   level
      :query(prism.components.Collider, prism.components.Controller)
      :at(5, 8)
      :each(function(actor, collider, controller)
         --- @cast collider Collider
         --- @cast controller Controller

         local act = controller.act
      end)
end

return Attack
