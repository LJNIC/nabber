--- @class DrawableComponent : Component
--- @field index string|integer
--- @field color Color4
--- @field background? Color4
--- @overload fun(index: string|integer, color?: Color4, background?: Color4): DrawableComponent
local Drawable = prism.Component:extend "DrawableComponent"
Drawable.name = "Drawable"

--- Index needs to be a string associated with a sprite in the SpriteAtlas, or
--- an integer index associated with a sprite.
--- @param index string|integer
--- @param color? Color4
--- @param background? Color4
function Drawable:__new(index, color, background, sprites)
   self.sprites = sprites or {}
   self.sprites.default = { index = index, color = color, background = background}
   self.index = index
   self.color = color or prism.Color4.WHITE
   self.background = background
end

function Drawable:switch(sprite)
   local s = self.sprites[sprite]
   if not s then return end
   self.index = s.index or self.index
   self.color = s.color or self.color
   self.background = s.background or self.background
end

return Drawable
