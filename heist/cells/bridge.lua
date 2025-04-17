local palette = require "palette"

---@class BridgeCell : Cell
local Bridge = prism.Cell:extend("BridgeCell")

Bridge.name = "BRIDGE"
Bridge.passable = true
Bridge.opaque = false
Bridge.drawable = prism.components.Drawable(257, palette[16], palette[1])
Bridge.allowedMovetypes = { "walk" }
Bridge.collisionMask = prism.Collision.createBitmaskFromMovetypes(Bridge.allowedMovetypes)

return Bridge
