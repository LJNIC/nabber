--- @class Hackable : Component
--- @field on boolean
--- @overload fun(on: boolean): Hackable
local Hackable = prism.Component:extend("Hackable")

function Hackable:__new(on)
   self.on = on
end

return Hackable
