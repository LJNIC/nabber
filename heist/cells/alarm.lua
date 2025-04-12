local palette = require "palette"

---@class AlarmCell : Cell
local Alarm = prism.Cell:extend("AlarmCell")

Alarm.name = "ALARM"
Alarm.passable = true
Alarm.opaque = false
Alarm.drawable = prism.components.Drawable(271, palette[6])

return Alarm
