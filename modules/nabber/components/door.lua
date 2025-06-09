--- @class Door : Component
--- @field open boolean
--- @field openDrawable Drawable
--- @field closedDrawable Drawable
--- @field indicator? Vector2
--- @overload fun(options: {open: boolean, openDrawable: Drawable, closedDrawable: Drawable, indicator?: Vector2})
local Door = prism.Component:extend("Door")

function Door:__new(options)
   self.open = options.open
   self.openDrawable = options.openDrawable
   self.closedDrawable = options.closedDrawable
   self.indicator = options.indicator
end

return Door
