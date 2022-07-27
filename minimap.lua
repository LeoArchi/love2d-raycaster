local function myStencilFunction()
   love.graphics.rectangle("fill", 20, 20, 175, 100)
end


local Minimap = {

  x,
  y,
  width,
  height,
  scale,

  init = function(self, x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.scale = 0.4
    self.center = {}
    self.center.x = self.width/2 + self.x
    self.center.y = self.height/2 + self.y
  end,

  draw = function(self)

    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setLineWidth(3)

    -- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
    love.graphics.stencil(myStencilFunction, "replace", 1)

    -- Only allow rendering on pixels which have a stencil value greater than 0.
    love.graphics.setStencilTest("greater", 0)

    love.graphics.push()

    love.graphics.translate(self.center.x - Player.x1*self.scale, self.center.y - Player.y1*self.scale)
    love.graphics.scale(self.scale, self.scale)

    Level:draw()
    if displayCasting then Raycast:draw2D() end
    Player:draw2D()

    love.graphics.pop()

    love.graphics.setStencilTest()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)



  end


}

return Minimap
