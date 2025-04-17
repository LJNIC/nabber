---@class HeistDisplay : Display
local HeistDisplay = spectrum.Display:extend("HeistDisplay")

function HeistDisplay:drawAlarm(x, y)
   HeistDisplay.drawDrawable(prism.cells.Alarm.drawable, self.spriteAtlas, self.cellSize, x, y)
end

---@param actor Actor
---@param inPrimary boolean
---@param inSecondary boolean
---@param primaryCellSet SparseGrid
function HeistDisplay:beforeDrawActor(actor, inPrimary, inSecondary, primaryCellSet)
   if actor:hasComponent(prism.components.Alarm) then
      local senses = actor:expectComponent(prism.components.Senses)
      for x, y, cell in senses.cells:each() do
         local isFloor = cell and cell:is(prism.cells.Floor)
         if isFloor and primaryCellSet:get(x, y) then
            self:drawAlarm(x, y)
         end
      end
   end
end

return HeistDisplay
