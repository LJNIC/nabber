---@class AlarmComponent : Component
---@field target Actor
local Alarm = prism.Component:extend("AlarmComponent")
Alarm.name = "Alarm"
Alarm.requirements = { prism.components.Sight }

return Alarm
