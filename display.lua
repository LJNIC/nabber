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
      local range = actor:getComponent(prism.components.Sight).range
      prism.Ellipse("fill", actor:getPosition(), range, range, function(x, y)
         local isFloor = self.attachable:getCell(x, y) == prism.cells.Floor
         local cellsSeenByActor = actor:getComponent(prism.components.Senses).cells
         if isFloor and primaryCellSet:get(x, y) and cellsSeenByActor:get(x, y) then
            self:drawAlarm(x, y)
         end
      end)
   end
end

return HeistDisplay
