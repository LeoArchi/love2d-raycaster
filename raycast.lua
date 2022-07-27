local function checkHorizontalLines(x1, y1, rayAngleRad)

  -- Déclaration du rayon, le point de départ est égal à la position du joueur
  local ray = {}
  ray.x1 = x1
  ray.y1 = y1
  ray.angle = rayAngleRad

  -- Initialisation des offsets
  local offsetY
  local offsetX

  -- Initialisation du nombre maximum de cases que pourra parcourir le rayon (la taille du niveau)
  local nbCases = 0

  -- Regarde en haut
  if ray.angle > 0 and  ray.angle < math.pi then
    ray.y2 = math.floor(Player.y1/Level.squareSize) * Level.squareSize -- calcul de la composante y de la première intersection avec une ligne horizontale en arrondissant au plus proche 50ème vers 0
    ray.x2 = (ray.y1 - ray.y2) / math.tan(ray.angle) + ray.x1 -- calcul de la composante x avec la trigo
    offsetY = Level.squareSize * (-1)
    offsetX = offsetY * (-1) / math.tan(ray.angle+math.pi)
  end

  -- Regarde en bas
  if ray.angle > math.pi and ray.angle < math.pi*2 then
    ray.y2 = math.ceil(Player.y1/Level.squareSize) * Level.squareSize -- calcul de la composante y de la première intersection avec une ligne horizontale en arrondissant au plus proche 50ème vers 0
    ray.x2 = (ray.y1 - ray.y2) / math.tan(ray.angle) + ray.x1 -- calcul de la composante x avec la trigo
    offsetY = Level.squareSize
    offsetX = offsetY * (-1) / math.tan(ray.angle+math.pi)
  end

  -- Regarde pile à gauche ou pile à droite
  if ray.angle == 0 or ray.angle == math.pi or ray.angle == math.pi*2 then
    nbCases = Level.maxSquares
    ray.x2 = ray.x1
    ray.y2 = ray.y1
  end

  while nbCases < Level.maxSquares do

    -- Récupération de la case du tableau
    local mapX = math.floor(ray.x2 / Level.squareSize) +1
    local mapY = (ray.y2/Level.squareSize)
    if offsetY > 0 then
      mapY = mapY + 1
    end

    local mapSquare = Level.walls[(mapY-1)*Level.width+mapX]

    if mapSquare == 0 then
      -- Calcul de la prochaine intersection, à faire seulement si le contenu de la case est 0
      ray.y2 = ray.y2 + offsetY
      ray.x2 = ray.x2 + offsetX
      nbCases = nbCases+1
    else
      if mapSquare == 1 then
        ray.color = {0.8, 0.2, 0.2, 1}
      elseif mapSquare == 2 then
        ray.color = {0.2, 0.2, 0.8, 1}
      end
      nbCases = Level.maxSquares
    end

  end

  ray.dist = math.sqrt(math.pow(ray.x2 - ray.x1, 2)+math.pow(ray.y2 - ray.y1, 2))

  local _offsetX = (ray.x2 % Level.squareSize) / Level.squareSize
  ray.texturePosX = math.floor(_offsetX * baseTextureData:getWidth())

  ray.direction = "horizontal"

  return ray

end

local function checkVerticalLines(x1, y1, rayAngleRad)

  -- Déclaration du rayon, le point de départ est égal à la position du joueur
  local ray = {}
  ray.x1 = x1
  ray.y1 = y1
  ray.angle = rayAngleRad

  -- Initialisation des offsets
  local offsetY
  local offsetX

  -- Initialisation du nombre maximum de cases que pourra parcourir le rayon (la taille du niveau)
  local nbCases = 0

  -- Regarde à gauche
  if ray.angle > math.pi/2 and  ray.angle < 3*math.pi/2 then
    ray.x2 = math.floor(Player.x1/Level.squareSize) * Level.squareSize
    ray.y2 = ray.y1 - (ray.x2 - ray.x1) * math.tan(ray.angle)
    offsetX = Level.squareSize * (-1)
    offsetY = offsetX * math.tan(ray.angle)
  end

  -- Regarde à droite
  if (ray.angle > 3*math.pi/2 and ray.angle <= math.pi*2) or (ray.angle >= 0 and ray.angle < math.pi/2) then
    ray.x2 = math.ceil(Player.x1/Level.squareSize) * Level.squareSize
    ray.y2 = ray.y1 - (ray.x2 - ray.x1) * math.tan(ray.angle)
    offsetX = Level.squareSize
    offsetY = offsetX * math.tan(ray.angle)
  end

  -- Regarde pile en haut ou pile en bas
  if ray.angle == math.pi/2 or ray.angle == 3*math.pi/2 then
    nbCases = Level.maxSquares
    ray.x2 = ray.x1
    ray.y2 = ray.y1
  end


  while nbCases < Level.maxSquares do

    -- Récupération de la case du tableau
    local mapY = math.floor(ray.y2 / Level.squareSize) +1 --(ray.y2/Level.squareSize)

    local mapX = (ray.x2/Level.squareSize) --math.floor(ray.x2 / Level.squareSize) +1

    if offsetX > 0 then
      mapX = mapX + 1
    end

    local mapSquare = Level.walls[(mapY-1)*Level.width+mapX]

    if mapSquare == 0 then
      -- Calcul de la prochaine intersection, à faire seulement si le contenu de la case est 0
      ray.x2 = ray.x2 + offsetX
      ray.y2 = ray.y2 - offsetY
      nbCases = nbCases+1
    else
      if mapSquare == 1 then
        ray.color = {0.8, 0.4, 0.4, 1}
      elseif mapSquare ==2 then
        ray.color = {0.4, 0.4, 0.8, 1}
      end
      nbCases = Level.maxSquares
    end

  end

  ray.dist = math.sqrt(math.pow(ray.x2 - ray.x1, 2)+math.pow(ray.y2 - ray.y1, 2))

  local _offsetX = (ray.y2 % Level.squareSize) / Level.squareSize
  ray.texturePosX = math.floor(_offsetX * baseTextureData:getWidth())

  ray.direction = "vertical"

  return ray
end


local Raycast = {

  fov, -- en degrés
  res,
  rays = {},

  init = function(self, fov, res)
    self.fov = fov
    self.res = res

  end,

  update = function(self ,dt)

    self.rays = {}

    -- Calcul de l'angle du joueur en degrés
    local _playerAngleDegrees = Player.a * 180 / math.pi

    for i=(_playerAngleDegrees - self.fov/2), (_playerAngleDegrees + self.fov/2), (self.fov/(self.res-1)) do

      -- Reconversion de l'angle du joueur en radians
      local _rayAngleRad = i * math.pi / 180

      -- Ajustement de l'angle en radians entre 0 et 2*PI
      if _rayAngleRad >= 2 * math.pi then
        _rayAngleRad = _rayAngleRad - 2 * math.pi
      elseif _rayAngleRad < 0 then
        _rayAngleRad = _rayAngleRad + 2 * math.pi
      end

      local rayHorizontal = checkHorizontalLines(Player.x1, Player.y1, _rayAngleRad)
      local rayVertical   = checkVerticalLines(Player.x1, Player.y1, _rayAngleRad)

      if rayHorizontal.dist < rayVertical.dist then
        table.insert(self.rays,rayHorizontal)
      else
        table.insert(self.rays,rayVertical)
      end


    end


  end,

  draw2D = function(self)

    for i,ray in ipairs(self.rays) do

      --love.graphics.setColor(ray.color)
      love.graphics.setColor(10/255, 255/255, 157/255)
      love.graphics.line(ray.x1, ray.y1, ray.x2, ray.y2)
    end

    love.graphics.setColor(1, 0, 0, 1)
  end,

  draw3D = function(self)

    love.graphics.setColor(200/255, 200/255, 242/255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)

    love.graphics.setColor(247/255, 180/255, 22/255)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight()/2)

    for i,ray in ipairs(self.rays) do

      local distCorr = math.cos(ray.angle - Player.a) * ray.dist
      local lineHeight = Level.squareSize * 600 / distCorr

      if texturesOn == false then
        -- OLD : Rectangle plein
        love.graphics.setColor(ray.color)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('fill', love.graphics.getWidth()-(i*love.graphics.getWidth()/self.res), love.graphics.getHeight()/2-lineHeight/2, love.graphics.getWidth()/self.res, lineHeight)
      else
        -- NEW on dessine pixel par pixel

        local rectangleOffsetX = love.graphics.getWidth()-(i*love.graphics.getWidth()/self.res)
        local rectangleOffsetY = love.graphics.getHeight()/2-lineHeight/2

        local texturePosX = ray.texturePosX

        local textureOffsetY = lineHeight / baseTextureData:getHeight()


        for rectangleY=0,(lineHeight-1) do

          local texturePosY = math.floor(rectangleY/textureOffsetY)

          -- Dans le cas des murs "Gauches" et "Bas", il faut inverser la boucle pour ne pas inverser la texture
          if (ray.direction == "vertical" and ray.angle > math.pi/2 and ray.angle < 3*math.pi/2) or (ray.direction == "horizontal" and ray.angle > math.pi and ray.angle < 2*math.pi) then
            love.graphics.setColor(baseTextureData:getPixel(baseTextureData:getWidth() - texturePosX - 1, texturePosY))
          else
            love.graphics.setColor(baseTextureData:getPixel(texturePosX, texturePosY))
          end

          local _points = {}

          for rectangleX=0,(love.graphics.getWidth()/self.res-1) do
            table.insert(_points, {rectangleX + rectangleOffsetX, rectangleY + rectangleOffsetY})
            --love.graphics.points(rectangleX + rectangleOffsetX, rectangleY + rectangleOffsetY)
          end

          love.graphics.points(_points)

        end
      end

    end

  end

}

return Raycast
