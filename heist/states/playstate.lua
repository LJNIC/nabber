---@type Keybinding
local keybinds = require "keybindingschema"

local palette = require "palette"

---@class PlayState : LevelState
local PlayState = spectrum.LevelState:extend "PlayState"

love.graphics.setDefaultFilter("nearest", "nearest")

function PlayState:updateDecision(dt, actor, decision)
end

---@param message Message
function PlayState:handleMessage(message)
  spectrum.LevelState.handleMessage(self, message)
end

function PlayState:update(dt)
  local player = self.level:getActorByType(prism.actors.Player)
  if player and player:getComponent(prism.components.Health).health <= 0 then
    self.dead = true
  end
  spectrum.LevelState.update(self, dt)
end

function PlayState:keypressed(key)
  if self.dead then return end

  if key == "`" then
    self.manager:push(self.geometer)
  end

  if not self.decision or not self.decision:is(prism.decisions.ActionDecision) then
    return
  end

  local decision = self.decision
  ---@cast decision ActionDecision
  local actor = decision.actor

  local mode = nil
  local actionName = keybinds:keypressed(key, mode)
  ---@type Action?
  local action

  if actionName == "right" then
    action = self:handleMove(prism.Vector2.RIGHT, actor)
  elseif actionName == "left" then
    action = self:handleMove(prism.Vector2.LEFT, actor)
  elseif actionName == "up" then
    action = self:handleMove(prism.Vector2.UP, actor)
  elseif actionName == "down" then
    action = self:handleMove(prism.Vector2.DOWN, actor)
  elseif actionName == "action1" and actor:getComponent(prism.components.Gear).item1Uses > 0 then
    self.actionPrototype = actor:getComponent(prism.components.Gear).actions[1]
    if #self.actionPrototype.targets > 0 then
      self.decidingDirection = true
      self.decidingOne = true
    end
  elseif actionName == "action2" and actor:getComponent(prism.components.Gear).item2Uses > 0 then
    self.actionPrototype = actor:getComponent(prism.components.Gear).actions[2]
    if #self.actionPrototype.targets > 0 then
      self.decidingOne = false
      self.decidingDirection = true
    else
    end
  elseif actionName == "wait" then
    action = prism.actions.Wait(actor, {})
  end

  -- elseif actionName == "throw" then
  --   if actor:hasAction(prism.actions.Throw) then
  --     local throw = prism.actions.Throw(actor, {})
  --     if throw:canPerform(self.level) then action = throw end
  --   end
  -- elseif actionName == "attack" then
  --   local hold = actor:getComponent(prism.components.Hold)
  --   if hold and hold.heldActor then
  --     local attack = prism.actions.Attack(actor, { hold.heldActor })
  --     if attack:canPerform(self.level) then action = attack end
  --   end
  -- elseif actionName == "super" then
  --   if actor:hasAction(prism.actions.Super) then
  --     local super = prism.actions.Super(actor, {})
  --     if super:canPerform(self.level) then action = super end
  --   end
  -- end

  if action then
    ---@diagnostic disable-next-line
    self.decision:setAction(action)
  end
end

---@param level Level
---@param actor Actor
---@param actorsAt Actor[]
---@param actionPrototype Action
---@return Actor|nil
function PlayState:validateMove(actor, actorsAt, actionPrototype)
  if actor:hasAction(actionPrototype) then
    for _,actorAt in ipairs(actorsAt) do
      if actionPrototype:validateTarget(1, actor, actorAt, {}) then
        return actorAt
      end
    end
  end
end

---@param direction Vector2
---@param actor Actor
---@return Action?
function PlayState:handleMove(direction, actor)
  if self.decidingDirection then
    self.decidingDirection = false
    local action = self.actionPrototype(actor, { direction })
    self.actionPrototype = nil
    if action:canPerform(self.level) then 
      local gear = actor:getComponent(prism.components.Gear)
      if self.decidingOne then
        gear.item1Uses = gear.item1Uses - 1
      else
        gear.item2Uses = gear.item2Uses - 1
      end
      return action
    end

    return
  end
  local target = actor:getPosition() + direction
  local move = prism.actions.Move(actor, { target })
  if move:canPerform(self.level) then return move end

  local actorsAt = self.level:getActorsAt(target:decompose())
  if not actorsAt then return end

  local attackActor = self:validateMove(actor, actorsAt, prism.actions.Attack)
  if attackActor then
    local attack = prism.actions.Attack(actor, { attackActor })
    if attack:canPerform(self.level) then return attack end
  end
end

local life = spectrum.SpriteAtlas.fromGrid("assets/lifebar.png", 24, 8)
local controls = spectrum.SpriteAtlas.fromGrid("assets/items.png", 32, 88)
local items = spectrum.SpriteAtlas.fromGrid("assets/loadout.png", 56, 24) 
function PlayState:draw()
  love.graphics.setBackgroundColor(palette[3]:decompose())
  love.graphics.push()
  love.graphics.scale(4, 4)
  love.graphics.translate(8, 8)
  local player = self.level:getActorByType(prism.actors.Player)
  local health = 0
  local gear = nil
  if player then
    health = player:getComponent(prism.components.Health).health
    gear = player:getComponent(prism.components.Gear)
  end

  life:drawByIndex((6 - health + 1), 0, 8)

  love.graphics.translate(0, 16)
  if self.decidingDirection then
    controls:drawByIndex(2, 0, 0)
  else
    controls:drawByIndex(1, 0, 0)
  end

  if gear then
    local item1 = gear.item1:getComponent(prism.components.Drawable)
    local item2 = gear.item2:getComponent(prism.components.Drawable)
    local quad1 = spectrum.Display.getQuad(self.display.spriteAtlas, item1)
    local quad2 = spectrum.Display.getQuad(self.display.spriteAtlas, item2)

    items:drawByIndex(gear.item1Uses + 1, 8, 0)
    love.graphics.setColor(item1.color:decompose())
    love.graphics.draw(self.display.spriteAtlas.image, quad1, 16, 8)

    love.graphics.setColor(1, 1, 1, 1)
    items:drawByIndex(gear.item2Uses + 1, 8, 32)
    love.graphics.setColor(item2.color:decompose())
    love.graphics.draw(self.display.spriteAtlas.image, quad2, 16, 40)
    love.graphics.setColor(1, 1, 1, 1)
  end
  love.graphics.pop()

  love.graphics.translate(8*8*4, 0)
  spectrum.LevelState.draw(self)
end

return PlayState
