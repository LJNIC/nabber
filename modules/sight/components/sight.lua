--- @class Sight : Component
--- @field range integer How many tiles can this actor see?
--- @field darkRange integer
--- @field fov boolean
local Sight = prism.Component:extend("Sight")
Sight.requirements = { "Senses" }

function Sight:getRequirements()
   return prism.components.Senses
end

--- @param options {range: integer, fov: boolean, darkRange: integer}
function Sight:__new(options)
   self.range = options.range
   self.fov = options.fov
   self.darkRange = options.darkRange
end

return Sight
