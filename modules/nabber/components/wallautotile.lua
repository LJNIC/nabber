local AutoTile = require "modules.nabber.components.autotile"
local Drawable = require "prism.spectrum.components.drawable"
local palette = require "display.palette"
local default = Drawable(1, nil, palette[25])

--- @class WallAutoTile : AutoTile
local WallAutoTile = AutoTile:extend("WallAutoTile")

WallAutoTile.id = 4
WallAutoTile.default = default

WallAutoTile.drawables = {
   ["top"] = default,
   ["top-left"] = Drawable(130, palette[25], palette[5]),
   ["bottom-left"] = Drawable(146, palette[25], palette[5]),
   ["bottom-right"] = Drawable(147, palette[25], palette[5]),
   ["top-right"] = Drawable(131, palette[25], palette[5]),
   ["single"] = Drawable(304, palette[25], palette[5]),
   ["bottom"] = Drawable(257, palette[7], palette[6]),
   ["door-right"] = Drawable(257, palette[7], palette[6]),
}

-- stylua: ignore start
WallAutoTile.rules = {
  {
    drawable = "top",
    pattern = {
      0, 0, 0,
      6, 3, 0,
      0, 0, 0
    },
    mirrorX = true
  },
  {
    drawable = "bottom",
    pattern = {
      0, 2, 0,
      0, 3, 0,
      0, 5, 0
    }
  },
  {
    drawable = "single",
    pattern = {
      0, 1, 0,
      1, 3, 1,
      0, 1, 0
    }
  },
  {
    drawable = "top-left",
    pattern = {
      0, 1, 0,
      1, 3, 2,
      0, 2, 0
    }
  },
  {
    drawable = "bottom-right",
    pattern = {
      0, 2, 0,
      2, 3, 1,
      0, 1, 0
    }
  },
  {
    drawable = "top-right",
    pattern = {
      0, 1, 0,
      2, 3, 1,
      0, 2, 0
    }
  },
  {
    drawable = "top",
    pattern = {
      0, 1, 0,
      0, 3, 0,
      0, 0, 0
    }
  },
  {
    drawable = "bottom-left",
    pattern = {
      0, 2, 0,
      1, 3, 2,
      0, 1, 0
    }
  },
  {
    drawable = "top",
    pattern = {
      0, 0, 0,
      0, 3, 0,
      0, 1, 0
    }
  },
  {
    drawable = "top-right",
    pattern = {
      0, 1, 0,
      2, 3, 1,
      0, 2, 0
    }
  },
  {
    drawable = "top",
    pattern = {
      0, 0, 0,
      0, 3, 0,
      0, 2, 0
    }
  },
  {
    drawable = "top",
    pattern = {
      0, 2, 0,
      0, 3, 0,
      0, 0, 0
    }
  },
}
-- stylua: ignore end

return WallAutoTile
