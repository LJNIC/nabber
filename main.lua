require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/sight")
prism.loadModule("modules/nabber")

love.graphics.setBackgroundColor(require("display.palette")[5]:decompose())
love.graphics.setDefaultFilter("nearest", "nearest")
love.keyboard.setKeyRepeat(true)

-- Grab our level state and sprite atlas.
local MyGameLevelState = require "gamestates.MyGamelevelstate"

-- Load a sprite atlas and configure the terminal-style display,
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("display/tileset.png", 8, 8)
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(8, 8))
local overlay = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(8, 8))

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   manager:push(MyGameLevelState(display, overlay))
   manager:hook()
end
