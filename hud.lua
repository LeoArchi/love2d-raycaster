local HUD = {

  x,
  y,
  width,
  height,

  init = function(self)

    self.x = 0
    self.y = love.graphics.getHeight() - 100
    self.width = love.graphics.getWidth()
    self.height = 100


  end,

  update = function(self, dt)
    heartAnimation.currentTime = heartAnimation.currentTime + dt
    if heartAnimation.currentTime >= heartAnimation.duration then
        heartAnimation.currentTime = heartAnimation.currentTime - heartAnimation.duration
    end

    -- Mise à jour des FPS
    --fps = math.ceil(1/dt)
    fpsText = love.graphics.newText( middleFont, "FPS: " .. love.timer.getFPS() )
  end,


  draw = function(self)

    Minimap:draw()

    love.graphics.setLineWidth(3)

    -- FPS
    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.rectangle('fill', love.graphics.getWidth()-108, 20, 88, 50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', love.graphics.getWidth()-108, 20, 88, 50)
    love.graphics.draw(fpsText, love.graphics.getWidth()-104, 33)

    -- Base HUD
    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

    local spriteNum = math.floor(heartAnimation.currentTime / heartAnimation.duration * #heartAnimation.quads) + 1
    love.graphics.draw(heartAnimation.spriteSheet, heartAnimation.quads[spriteNum], 17, love.graphics.getHeight() - 87, 0, 0.3, 0.3)

    -- VISEUR
    love.graphics.setLineWidth(1)

    love.graphics.line(love.graphics.getWidth()/2 - 10, love.graphics.getHeight()/2, love.graphics.getWidth()/2 - 3, love.graphics.getHeight()/2)
    love.graphics.line(love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 10, love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 3)

    love.graphics.line(love.graphics.getWidth()/2 + 3, love.graphics.getHeight()/2, love.graphics.getWidth()/2 + 10, love.graphics.getHeight()/2)
    love.graphics.line(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 3, love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 10)
    love.graphics.circle('line', love.graphics.getWidth()/2, love.graphics.getHeight()/2, 7, 32)
  end

}


return HUD
