---@class WaitAction : Action
local Wait = prism.Action:extend("WaitAction")
Wait.name = "wait"

function Wait:perform(level)
end

return Wait
