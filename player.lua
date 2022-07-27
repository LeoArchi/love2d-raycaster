local Player = {

  r,
  a,
  x1,
  y1,
  x2,
  y2,
  maxSpeed,
  speed,
  life,
  --vectors,

  init = function(self, r, a)
    self.x1 =  Level.spawn.x * Level.squareSize - Level.squareSize/2 -- Spawn en fonction du Level
    self.y1 =  Level.spawn.y * Level.squareSize - Level.squareSize/2 -- Spawn en fonction du Level
    self.r = r
    self.a = a
    self.maxSpeed = 100
    self.life = 100
  end,

  update = function(self, dt)

    local _playerDegreesAngle = MathUtils.radsTodegrees(self.a)

    self.speed = Vector:new(0,_playerDegreesAngle)

    -- Recorrection de l'angle entre 0 et 2 PI radians

    if self.a > 2 * math.pi then
      self.a = self.a - 2 * math.pi
    elseif self.a < 0 then
      self.a = self.a + 2 * math.pi
    end

    -- Déplacement du joueur
    if love.keyboard.isDown("z") then
      local _vectorZ = Vector:new(self.maxSpeed,_playerDegreesAngle)
      self.speed = self.speed:add(_vectorZ)
    end
    if love.keyboard.isDown("s") then
      local _vectorS = Vector:new(self.maxSpeed,_playerDegreesAngle + 180)
      self.speed = self.speed:add(_vectorS)
    end
    if love.keyboard.isDown("q") then
      local _vectorQ = Vector:new(self.maxSpeed,_playerDegreesAngle + 90)
      self.speed = self.speed:add(_vectorQ)
    end
    if love.keyboard.isDown("d") then
      local _vectorD = Vector:new(self.maxSpeed,_playerDegreesAngle - 90)
      self.speed = self.speed:add(_vectorD)
    end

    local newX = self.x1 + self.speed.x * dt
    local newY = self.y1 + self.speed.y * dt

    newTemoinX = newX + math.cos(MathUtils.degreesToRads(self.speed.angle)) * self.r
    newTemoinY = newY - math.sin(MathUtils.degreesToRads(self.speed.angle)) * self.r

    oldMapX = math.floor(self.x1/Level.squareSize) +1
    newMapX = math.floor(newTemoinX/Level.squareSize) +1
    oldMapY = math.floor(self.y1/Level.squareSize) +1
    newMapY = math.floor(newTemoinY/Level.squareSize) +1

    mapSquareNewX = Level.walls[(oldMapY-1)*Level.width+newMapX]
    mapSquareNewY = Level.walls[(newMapY-1)*Level.width+oldMapX]

    if mapSquareNewX == 0 then
      -- Si la case est vide, avancer normalement sur l'axe X
      self.x1 = newX
    end

    if mapSquareNewY == 0 then
      -- Si la case est vide, avancer normalement sur l'axe Y
      self.y1 = newY
    end

    -- Calcul de la position du témoin d'orientation
    self.x2 = self.x1 + math.cos(self.a) * self.r
    self.y2 = self.y1 - math.sin(self.a) * self.r

    -- Mise à jour de l'animation du shotgun
    --shotgunAnimation.currentTime = shotgunAnimation.currentTime + dt
    --if shotgunAnimation.currentTime >= shotgunAnimation.duration then
        --shotgunAnimation.currentTime = shotgunAnimation.currentTime - shotgunAnimation.duration
    --end

  end,

  draw2D = function(self)
    love.graphics.setColor(252/255, 186/255, 3/255, 1)
    love.graphics.rectangle("fill", self.x1-5, self.y1-5, 10, 10)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.line(self.x1, self.y1, newTemoinX, newTemoinY)
  end,

  draw3D = function(self)
    love.graphics.setColor(1, 1, 1, 1)
    local spriteNum = math.floor(shotgunAnimation.currentTime / shotgunAnimation.duration * #shotgunAnimation.quads) + 1
    love.graphics.draw(shotgunAnimation.spriteSheet, shotgunAnimation.quads[spriteNum], love.graphics.getWidth()/2 - shotgunAnimation.width/2, love.graphics.getHeight() - 100 - shotgunAnimation.height, 0, 1)
  end

}

function love.mousemoved( x, y, dx, dy, istouch )

  if dx < 0 then
    Player.a = Player.a + math.abs(dx) * 0.02
  else
    Player.a = Player.a - math.abs(dx) * 0.02
  end

end

function love.mousepressed(x, y, button)
   if button == 1 then
     local _shotgun_sound = shotgun_sound:clone()
     _shotgun_sound:play()
   end
end

return Player
