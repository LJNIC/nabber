local palette = require "palette"
local handlers = {}

local exclamation = prism.components.Drawable(34, palette[2])

---@param display Display
---@param message ActionMessage
handlers[prism.actions.Spot] = function(display, message)
   local t = 0
   local maxT = 0.5

   return function(dt, drawnSet)
      t = t + dt
      local action = message.action
      local pos = action.owner:getPosition()
      
      display.drawDrawable(exclamation, display.spriteAtlas, display.cellSize, pos.x, pos.y - 1)

      return maxT <= t
   end
end

return handlers
