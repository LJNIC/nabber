--- @class AlarmSystem : System
--- @field spotted boolean
local AlarmSystem = prism.System:extend("AlarmSystem")
AlarmSystem.name = "Alarm"
AlarmSystem.requirements = { "Sight" }

function AlarmSystem:__new()
   self.spotted = false
end

---@param level Level
---@param actor Actor
function AlarmSystem:onTurnEnd(level, actor)
   if self.spotted then return end

   local alarm = actor:getComponent(prism.components.Alarm)
   local senses = actor:getComponent(prism.components.Senses)
   if not senses or not alarm then return end

   for other in senses.actors:eachActor(prism.components.Suspicious) do
      self.spotted = true
      local action = prism.actions.Spot(actor, { other })
      level:performAction(action)
      break
   end
end

return AlarmSystem
