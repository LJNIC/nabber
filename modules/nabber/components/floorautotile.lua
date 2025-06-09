local AutoTile = require "modules.nabber.components.autotile"
local Drawable = require "prism.spectrum.components.drawable"
local palette = require "display.palette"

--- @class FloorAutoTile : AutoTile
local FloorAutoTile = AutoTile:extend("FloorAutoTile")

FloorAutoTile.default = Drawable(271, palette[5], palette[6])
FloorAutoTile.id = 5
FloorAutoTile.rules = {}

return FloorAutoTile
