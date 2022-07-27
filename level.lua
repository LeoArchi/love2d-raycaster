local LevelOne = require "levels/levelOne"

local Level = {

  width,
  height,

  squareSize,
  maxSquares,

  top={},
  walls={},
  floor={},

  init = function(self)

    --[[ Définition en dur d'un niveau
    self.width = 16
    self.height = 12
    self.squareSize = 25

    self.spawn = {}
    self.spawn.x = 9
    self.spawn.y = 7

    self.walls = {
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,
      1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,
      1,0,0,1,1,1,1,0,0,1,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,
      1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,
      1,0,0,0,0,0,2,0,0,0,0,0,1,0,0,1,
      1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,
      1,0,0,1,1,1,0,0,0,0,1,1,1,0,0,1,
      1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,
      1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    }]]

    -- Récupération des donnés du LevelOne
    self.width = LevelOne.width
    self.height = LevelOne.height
    self.squareSize = LevelOne.squareSize
    self.spawn = LevelOne.spawn
    self.walls = LevelOne.walls
    self.maxSquares = LevelOne.maxSquares

  end,


  draw = function(self)

    love.graphics.setLineWidth(1)

    for y=1, self.height do
      for x=1, self.width do

        local _square  = self.walls[(y-1)*self.width+x]
        local _squareX = (x-1) * self.squareSize
        local _squareY = (y-1) * self.squareSize

        if _square == 0 then
          love.graphics.setColor(0.1, 0.1, 0.1, 1)
        elseif _square == 1 then
          love.graphics.setColor(0.8, 0.4, 0.4, 1) -- Rouge "Vertical"
        elseif _square == 2 then
          love.graphics.setColor(0.4, 0.4, 0.8, 1) -- Bleu "Vertical"
        end

        love.graphics.rectangle('fill', _squareX, _squareY, self.squareSize, self.squareSize)
        love.graphics.setColor(0.3, 0.3, 0.3, 1)
        love.graphics.rectangle('line', _squareX, _squareY, self.squareSize, self.squareSize)


      end
    end

  end

}

return Level
