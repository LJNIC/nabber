--- @class SightComponent : Component
--- @field range integer How many tiles can this actor see?
--- @field fov boolean
--- @field directional boolean
--- @field direction Vector2
local Sight = prism.Component:extend("SightComponent")
Sight.name = "Sight"
Sight.requirements = { prism.components.Senses }

--- @param options {range: integer, fov: boolean, directional: boolean, startingDirection: Vector2}
function Sight:__new(options)
   self.range = options.range
   self.fov = options.fov or false
   self.directional = options.directional or false
   self.direction = options.startingDirection
end

return Sight
