love.graphics.setDefaultFilter("nearest", "nearest")
local image = love.graphics.newImage("frame.png")
function love.draw()
   love.graphics.scale(3, 3)
   love.graphics.draw(image)
end
