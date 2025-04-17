require "prism2.engine"
require "prism2.spectrum"
require "prism2.geometer"

prism.loadModule("prism2/spectrum")
prism.loadModule("prism2/geometer")

prism.neighborhood = prism.Vector2.neighborhood4

prism.Collision.assignNextAvailableMovetype("walk")

prism.loadModule("heist")

local palette = require "palette"

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(palette[3]:decompose())

local player = prism.actors.Player()

local data = prism.json.decode(love.filesystem.read("assets/level1.json"))
---@type MapBuilder
local level = prism.Object.deserialize(data)
--mapbuilder:addActor(player, 5, 5)
-- local map, actors = mapbuilder:build()
--
-- local level = prism.Level(map, actors, { prism.systems.Senses(), prism.systems.Sight() })
--level:addComponent(player, prism.components.Gear(prism.actors.Grapple(), prism.actors.Bridge()))

local HeistDisplay = require "display"

local atlas = spectrum.SpriteAtlas.fromGrid("assets/tileset.png", 8, 8)
local display = HeistDisplay(atlas, prism.Vector2(8, 8), level)
display.camera:setScale(0.25, 0.25)

--- @type PlayState
local PlayState = require "heist.states.playstate"
local PlanState = require "heist.states.planstate"
-- local state = PlayState(level, display, require "actionhandlers")
local stateManager = spectrum.StateManager()
stateManager:push(PlanState(level, display))

---@param level Level
---@param actor Actor
---@param controller ControllerComponent
---@diagnostic disable-next-line
function prism.turn(level, actor, controller)
  local _, action

  action = controller:act(level, actor)

  -- we make sure we got an action back from the controller for sanity's sake
  assert(action, "Actor " .. actor.name .. " returned nil from act()")

  level:performAction(action)

  if action.free then
    action = controller:act(level, actor)

    -- we make sure we got an action back from the controller for sanity's sake
    assert(action, "Actor " .. actor.name .. " returned nil from act()")

    level:performAction(action)
  end
end

function love.draw()
  stateManager:draw()
  ---love.graphics.translate(200, 0)
  ---display:draw()
end

function love.update(dt)
  stateManager:update(dt)
end

function love.keypressed(key)
  stateManager:keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
  stateManager:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button)
  stateManager:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
  stateManager:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(dx, dy)
  stateManager:wheelmoved(dx, dy)
end
