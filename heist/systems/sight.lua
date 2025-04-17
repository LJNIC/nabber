--- The Sight System manages the sight of actors. It is responsible for updating the FOV of actors, and
--- keeping track of which actors are visible to each other.
--- @class SightSystem : System
local SightSystem = prism.System:extend("SightSystem")
SightSystem.name = "Sight"

SightSystem.requirements = { "Senses" }

-- These functions update the fov and visibility of actors on the level.
---@param level Level
---@param actor Actor
function SightSystem:onSenses(level, actor)
   -- check if actor has a sight component and if not return
   local sensesComponent = actor:getComponent(prism.components.Senses)
   if not sensesComponent then return end

   local sightComponent = actor:getComponent(prism.components.Sight)
   local sightLimit = sightComponent.range

   -- we check if the sight component has a fov and if so we clear it
   if sightComponent.fov then
      local sightLimit = sightComponent.range
      self.computeFOV(level, sensesComponent, actor, sightLimit)
   else
      local actorPos = actor:getPosition()
      -- we have a sight component but no fov which essentially means the actor has blind sight and can see
      -- all cells within a certain radius  generally only simple actors have this vision type
      for x = actorPos.x - sightLimit, actorPos.x + sightLimit do
         for y = actorPos.y - sightLimit, actorPos.y + sightLimit do
            sensesComponent.cells:set(x, y, level:getCell(x, y))
         end
      end
   end

   self:updateSeenActors(level, actor)
end

---@param level Level
---@param actor Actor
---@param from Vector2
---@param to Vector2
function SightSystem:onMove(level, actor, from, to)
   local sight = actor:getComponent(prism.components.Sight)
   if not sight then return end

   local direction = (to - from)
   if direction == prism.Vector2.DOWN then
      actor:getComponent(prism.components.Drawable):switch("down")
      sight.direction = prism.Vector2.DOWN
   elseif direction == prism.Vector2.LEFT then
      actor:getComponent(prism.components.Drawable):switch("left")
      sight.direction = prism.Vector2.LEFT
   elseif direction == prism.Vector2.UP then
      actor:getComponent(prism.components.Drawable):switch("up")
      sight.direction = prism.Vector2.UP
   elseif direction == prism.Vector2.RIGHT then
      actor:getComponent(prism.components.Drawable):switch("right")
      sight.direction = prism.Vector2.RIGHT
   end
end

---@param level Level
---@param actor Actor
function SightSystem:updateSeenActors(level, actor)
   -- if we don't have a sight component we return
   local sensesComponent = actor:getComponent(prism.components.Senses)
   if not sensesComponent then return end

   -- clear the actor visibility table
   sensesComponent.actors = prism.ActorStorage()

   for x, y, _ in sensesComponent.cells:each() do
      for other in level:eachActorAt(x, y) do
         sensesComponent.actors:addActor(other)
      end
   end
end

---@param level Level
---@param sensesComponent SensesComponent
---@param actor Actor
---@param maxDepth integer
function SightSystem.computeFOV(level, sensesComponent, actor, maxDepth)
   local origin = actor:getPosition()
   sensesComponent.cells:set(origin.x, origin.y, level:getCell(origin:decompose()))
   level:computeFOV(origin, maxDepth, function(x, y)
      if SightSystem.isPointInSight(x, y, origin, actor:getComponent(prism.components.Sight)) then
         sensesComponent.cells:set(x, y, level:getCell(x, y))
      end
   end)
end

---@param x integer
---@param y integer
---@param origin Vector2
---@param sightComponent SightComponent
function SightSystem.isPointInSight(x, y, origin, sightComponent)
   if not sightComponent.directional then return true end

   local direction = sightComponent.direction
   local angle = math.atan2(y - origin.y, x - origin.x)
   if direction == prism.Vector2.RIGHT then
      return angle < (math.pi / 3) and angle > (-math.pi / 3)
   end

   if direction == prism.Vector2.DOWN then
      return angle > (math.pi / 6) and angle < (math.pi *  5/6)
   end

   if direction == prism.Vector2.LEFT then
      return angle > (math.pi * 2/3) or angle < -(math.pi * 2/3)
   end

   if direction == prism.Vector2.UP then
      return angle > -(math.pi * 5/6) and angle < -(math.pi / 6)
   end
end

return SightSystem
