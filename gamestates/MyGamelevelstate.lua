local keybindings = require "keybindingschema"
local palette = require "display.palette"

--- @class MyGameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @field path Path
--- @field level Level
--- @overload fun(display: Display, overlay: Display): MyGameLevelState
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

--- @param display Display
--- @param overlay Display
function MyGameLevelState:__new(display, overlay)
   -- Construct a simple test map using MapBuilder.
   -- In a complete game, you'd likely extract this logic to a separate module
   -- and pass in an existing player object between levels.
   local mapbuilder = prism.MapBuilder(prism.cells.Pit)

   mapbuilder:drawRectangle(4, 10, 9, 17, prism.cells.Wall)
   mapbuilder:drawRectangle(7, 12, 15, 19, prism.cells.Wall)
   mapbuilder:drawRectangle(15, 15, 18, 18, prism.cells.Wall)
   mapbuilder:drawRectangle(18, 11, 24, 21, prism.cells.Wall)
   -- Fill the interior with floor tiles
   mapbuilder:drawRectangle(5, 12, 8, 16, prism.cells.Floor)
   mapbuilder:drawRectangle(8, 14, 14, 18, prism.cells.Floor)
   mapbuilder:drawLine(15, 17, 18, 17, prism.cells.Floor)
   mapbuilder:drawRectangle(19, 13, 23, 20, prism.cells.Floor)
   mapbuilder:addActor(prism.actors.Terminal(), 12, 13)
   mapbuilder:drawPolygon(prism.cells.Pipe, 7, 9, 7, 7, 19, 7, 19, 8, 21, 8, 21, 10)
   local door = prism.actors.PipeDoor()
   door:expect(prism.components.Door).indicator = prism.Vector2(0, -2)
   mapbuilder:addActor(door, 7, 11)
   door = prism.actors.PipeDoor()
   door:expect(prism.components.Door).indicator = prism.Vector2(0, -2)
   mapbuilder:addActor(door, 21, 12)
   mapbuilder:addActor(prism.actors.Sentry(), 21, 13)

   mapbuilder:set(21, 11, prism.cells.Pipe())
   mapbuilder:set(7, 10, prism.cells.Pipe())
   mapbuilder:set(21, 12, prism.cells.Floor())
   mapbuilder:set(7, 11, prism.cells.Floor())
   mapbuilder:addPadding(1, prism.cells.Pit)

   mapbuilder:set(7, 9, prism.cells.PipeDoorClosed())
   mapbuilder:set(21, 10, prism.cells.PipeDoorClosed())

   -- Place the player character at a starting location
   mapbuilder:addActor(prism.actors.Player(5), 8, 15)

   -- Build the map and instantiate the level with systems
   local map, actors = mapbuilder:build()
   local level = prism.Level(map, actors, {
      prism.systems.Senses(),
      prism.systems.Sight(),
      prism.systems.AutoTile(),
   })
   level.debug = true

   self.overlay = overlay

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   spectrum.LevelState.__new(self, level, display)
end

function MyGameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   -- Handle any messages sent to the level state from the level. LevelState
   -- handles a few built-in messages for you, like the decision you fill out
   -- here.

   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
end

function MyGameLevelState:focus(focus)
   self.path = nil
   self.selectedPath = nil
end

local timer = 0.1
function MyGameLevelState:update(dt)
   spectrum.LevelState.update(self, dt)
   local x, y, cell = self:getCellUnderMouse()
   local player = self:getCurrentActor()
   if cell and player and not self.selectedPath then
      local path = nil
      local minDistance = 0
      while not path and minDistance < 32 do
         path = self.level:findPath(
            player:getPosition(),
            prism.Vector2(x, y),
            player,
            player:expect(prism.components.Mover).mask,
            minDistance
         )
         minDistance = minDistance + 1
      end
      self.path = path
   else
      self.path = nil
   end

   timer = timer - dt
   if player and self.selectedPath and self.selectedPath:length() > 0 and timer <= 0 then
      local position = self.selectedPath:pop()
      local action = self:performOn(position, position - player:getPosition())
      if action then self.decision:setAction(action) end
      if self.selectedPath:length() == 0 then self.selectedPath = nil end
      timer = 0.05
   end
end

function MyGameLevelState:transformMousePosition(mx, my)
   return mx / 2, my / 2
end

--- @param vector? Vector2
local function directionToArrow(vector)
   if vector == prism.Vector2.UP then return 29 end
   if vector == prism.Vector2.DOWN then return 30 end
   if vector == prism.Vector2.RIGHT then return 31 end
   if vector == prism.Vector2.LEFT then return 32 end
   return nil
end

--- @param primary Senses[] { curActor:get(prism.components.Senses)}
---@param secondary Senses[]
function MyGameLevelState:draw(primary, secondary)
   self.overlay:clear()
   self.display:clear()

   self.display:setCamera(10, 5)

   local primary, secondary = self:getSenses()
   local primarySenses = primary[1]
   -- Render the level using the actor’s senses
   self.display:putLevel(self.level)

   local dx, dy = self.display.camera:decompose()

   for x, y, cell in primary[1].cells:each() do
      ---@cast cell Cell
      local seen = cell:get(prism.components.Seen)
      if seen then self.display:putDrawable(x + dx, y + dy, seen.drawable, seen.drawable.color) end
   end

   -- Handle darkness, i.e. pipes.
   for _, actor in ipairs(self.level:query():gather()) do
      local position = actor:getPosition()
      local cell = self.level:getCell(position:decompose())

      -- In the dark and we can see it
      if cell:has(prism.components.Dark) and primarySenses.actors:hasActor(actor) then
         local drawable = actor:expect(prism.components.Drawable)
         self.display:putDrawable(position.x + dx, position.y + dy, drawable, palette[18])
      -- In the dark but we can't see it
      elseif cell:has(prism.components.Dark) then
         self.display:putDrawable(
            position.x + dx,
            position.y + dy,
            cell:expect(prism.components.Drawable),
            nil,
            3
         )
      end
   end

   local owner = self.decision.actor

   if self.path then self:drawPath() end
   -- local move = prism.actions.Move(owner, prism.Vector2(x, y))
   -- if cell and self.level:canPerform(move) then
   --    self.display.cells[x + dx][y + dy].fg = palette[20]:copy()
   -- end

   local x, y = self:getCellUnderMouse()
   if x then
      local dx, dy = self.display.camera:decompose()
      local actorAtMouse = self.level:query(prism.components.Pushable):at(x, y):first()
      local position = prism.Vector2(x, y)
      local direction = position - owner:getPosition()
      local push = prism.actions.Push(self.decision.actor, actorAtMouse, direction)
      if self.level:canPerform(push) then
         local drawArrowAt = position + direction
         self.display:put(
            drawArrowAt.x + self.display.camera.x,
            drawArrowAt.y + self.display.camera.y,
            directionToArrow(direction),
            palette[20],
            palette[6]
         )
      end

      self.overlay:put(x + dx, y + dy, 155, palette[22])
   end

   -- custom terminal drawing goes here!

   -- Say hello!
   self.display:putString(1, 1, "Hello prism!")

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   love.graphics.scale(2, 2)
   self.display:draw()
   self.overlay:draw()

   -- custom love2d drawing goes here!
end

function MyGameLevelState:drawPath()
   local player = self:getCurrentActor()
   if not player then return end

   for _, position in ipairs(self.path:getPath()) do
      local cell = self.level:getCell(position:decompose())
      local senses = player:expect(prism.components.Senses)
      if cell:has(prism.components.Dark) and not senses.cells:get(position:decompose()) then
      else
         self.display.cells[position.x + self.display.camera.x][position.y + self.display.camera.y].fg =
            palette[20]:copy()
      end
   end
end

-- Maps string actions from the keybinding schema to directional vectors.
local keybindOffsets = {
   ["move up"] = prism.Vector2.UP,
   ["move left"] = prism.Vector2.LEFT,
   ["move down"] = prism.Vector2.DOWN,
   ["move right"] = prism.Vector2.RIGHT,
   ["move up-left"] = prism.Vector2.UP_LEFT,
   ["move up-right"] = prism.Vector2.UP_RIGHT,
   ["move down-left"] = prism.Vector2.DOWN_LEFT,
   ["move down-right"] = prism.Vector2.DOWN_RIGHT,
}

-- The input handling functions act as the player controller’s logic.
-- You should NOT mutate the Level here directly. Instead, find a valid
-- action and set it in the decision object. It will then be executed by
-- the level. This is a similar pattern to the example KoboldController.
function MyGameLevelState:keypressed(key, scancode)
   if self.selectedPath then return end
   -- handles opening geometer for us
   spectrum.LevelState.keypressed(self, key, scancode)

   local owner = self:getCurrentActor()
   if not owner then return end

   --- @type ActionDecision
   local decision = self.decision

   -- Resolve the action string from the keybinding schema
   local action = keybindings:keypressed(key)

   -- Attempt to translate the action into a directional move
   if keybindOffsets[action] then
      local destination = owner:getPosition() + keybindOffsets[action]
      local toPerform = self:performOn(destination, keybindOffsets[action])
      if toPerform then decision:setAction(toPerform) end
      return
   end

   -- Wait is a no op, skip turn.
   if action == "wait" then decision:setAction(prism.actions.Wait(owner)) end
end

function MyGameLevelState:mousepressed(x, y, button, istouch, presses)
   local _, _, cell = self:getCellUnderMouse()

   if not cell then return end

   if self.path then self.selectedPath = self.path end
end

--- @param position Vector2
--- @param direction Vector2
--- @return Action?
function MyGameLevelState:performOn(position, direction)
   local owner = self:getCurrentActor()
   if not owner then return nil end

   if love.keyboard.isDown("lshift") then
      local actorPosition = (direction * -1) + owner:getPosition()
      local actor =
         self.level:query(prism.components.Pushable):at(actorPosition:decompose()):first()
      local pull = prism.actions.Pull(owner, actor, direction)

      if self.level:canPerform(pull) then return pull end
   end

   if love.keyboard.isDown("lctrl") then
      local actor = self.level:query(prism.components.Pushable):at(position:decompose()):first()
      local attack = prism.actions.Attack(owner, actor)
      if self.level:canPerform(attack) then return attack end
   end

   local move = prism.actions.Move(owner, position)
   if self.level:canPerform(move) then return move end

   local actor = self.level:query(prism.components.Pushable):at(position:decompose()):first()

   local push = prism.actions.Push(owner, actor, direction)
   local can, err = self.level:canPerform(push)
   if can then return push end

   actor = self.level:query(prism.components.Hackable):at(position:decompose()):first()

   local hack = prism.actions.Hack(owner, actor)
   if self.level:canPerform(hack) then return hack end
end

function MyGameLevelState:resume()
   local sensesSystem = self.level:getSystem("SensesSystem")
   if sensesSystem then sensesSystem:postInitialize(self.level) end

   local autotileSystem = self.level:getSystem("AutoTileSystem")
   if autotileSystem then autotileSystem:initialize(self.level) end
end

return MyGameLevelState
