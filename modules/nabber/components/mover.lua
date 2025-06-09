--- @class Mover : Component
--- @field mask Bitmask
--- @overload fun(movetypes: string[]): Mover
local Mover = prism.Component:extend("Mover")
Mover.name = "Mover"

--- @param movetypes string[]
function Mover:__new(movetypes)
   self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
end

return Mover
