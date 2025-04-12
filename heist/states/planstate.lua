local PlayState = require "heist.states.playstate"

---@class PlanState : GameState
---@field level MapBuilder
---@field display Display
---@field gear Actor[]
---@field selectedGear number[]|nil[]
---@field currentSelectionIndex number
local PlanState = spectrum.GameState:extend("PlanState")

function PlanState:__new(level, display)
  self.level = level
  self.display = display

  self.gear = {
    prism.actors.Drill(),
    prism.actors.Bridge(),
    prism.actors.Grapple(),
    prism.actors.DecoyTool()
  }

  self.selectedGear = {nil, nil}
  self.currentSelectionIndex = 1
end

local list = love.graphics.newImage("assets/list.png")
function PlanState:draw()
  love.graphics.push()
  love.graphics.scale(4, 4)
  love.graphics.draw(list, 8, 8)
  for i, actor in ipairs(self.gear) do
    local drawable = actor:getComponent(prism.components.Drawable)
    self.display.drawDrawable(drawable, self.display.spriteAtlas, self.display.cellSize, 2, (i - 1) * 2 + 2)
    if i == self.currentSelectionIndex then
      local offset = self.display.cellSize * (i - 1) * 2
      love.graphics.rectangle("line", 16, offset.y + 16, self.display.cellSize.x, self.display.cellSize.y)
    end
    if self:isGearSelected(actor) then
      local offset = self.display.cellSize * (i - 1) * 2
      love.graphics.setColor(0, 1, 0) -- Green color for selected gear
      love.graphics.rectangle("line", 16, offset.y + 16, self.display.cellSize.x, self.display.cellSize.y)
      love.graphics.setColor(1, 1, 1) -- Reset to white color
    end
  end
  love.graphics.pop()

  love.graphics.translate(0, -48)
  self.display:draw()
end

function PlanState:keypressed(key, scancode)
  if key == "up" then
    self.currentSelectionIndex = math.max(1, self.currentSelectionIndex - 1)
  elseif key == "down" then
    self.currentSelectionIndex = math.min(#self.gear, self.currentSelectionIndex + 1)
  elseif key == "z" then
    self:selectGear(1)
  elseif key == "x" then
    self:selectGear(2)
  elseif key == "return" then
    self:createGearComponent()
  end
end

function PlanState:selectGear(slot)
  local selectedActor = self.gear[self.currentSelectionIndex]
  if not self:isGearSelected(selectedActor) then
    self.selectedGear[slot] = self.currentSelectionIndex
  end
end

function PlanState:isGearSelected(actor)
  for _, selection in ipairs(self.selectedGear) do
    if selection and self.gear[selection] == actor then
      return true
    end
  end
  return false
end

function PlanState:createGearComponent()
  if self.selectedGear[1] and self.selectedGear[2] then
    local gearComponent = prism.components.Gear(self.gear[self.selectedGear[1]], self.gear[self.selectedGear[2]])
    ---@type Actor
    local player = prism.actors.Player()
    player:__addComponent(gearComponent)
    self.level:addActor(player, 15, 7)
    local map, actors = self.level:build()
    local level = prism.Level(map, actors, { prism.systems.Senses(), prism.systems.Sight(), prism.systems.Alarm() })
    self.display.attachable = level
    self.manager:push(PlayState(level, self.display, require "actionhandlers"))
    -- Add the gearComponent to the appropriate entity or system
  end
end

return PlanState


