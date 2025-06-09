--- @class Seen : Component
local Seen = prism.Component:extend("Seen")

function Seen:__new(drawable)
   self.drawable = drawable
end

return Seen
