--- @class DirectionTarget : Target
local DirectionTarget = prism.Target:extend("DirectionTarget")

--- @param owner Actor
--- @param targetObject Vector2
function DirectionTarget:validate(owner, targetObject, targets)
   return prism.Vector2:is(targetObject)
end

prism.registerTarget("DirectionTarget", function()
   return prism.Target():isPrototype(prism.Vector2)
end)
