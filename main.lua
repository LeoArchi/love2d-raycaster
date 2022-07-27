levelOne = require("levelOne")


function love.load()

	love.mouse.setRelativeMode(true)

  -- Vue map
  viewMap = false

  -- theme
  doomE1m1 = love.audio.newSource("doom.wav", "stream")
  doomE1m1:setLooping(true)
  doomE1m1:setVolume(0.5)
  doomE1m1:play()

  -- gun
  gun_png = love.graphics.newImage("gun.png")
  gun_sound = love.audio.newSource("gun.wav", "static")
  gun_sound:setVolume(0.5)

  -- gunBalls
  gunBalls={}

  -- Player
  player = {}
  player.x = 110
  player.y = 110
  player.speed = 80
  player.orientation = 0
  player.fov = 60
  player.resolution = 500
  player.rays = {}
  player.vectors = {}

  -- Génération du niveau
  walls = levelOne.init()

  -- Init de la souris
  love.mouse.setVisible( false )
  --love.mouse.setX(love.graphics.getWidth()/2)
  --love.mouse.setY(love.graphics.getHeight()/2)

  -- background
  -- Rouge et jaune : backgroudGradiant = gradientMesh("vertical", setHexColor(255, 207, 64), {0.2,0.2,0.2}, setHexColor(255, 64, 64))
  backgroudGradiant = gradientMesh("vertical", {0.9,0.9,0.9}, {0,0,0}, {0.9,0.9,0.9})

end

function love.update(dt)

  fps = math.floor(1/dt)

  --love.mouse.setX(love.graphics.getWidth()/2)
  --love.mouse.setY(love.graphics.getHeight()/2)

  -- Calcul "vecteur" Avant
  vector_front = {}
  vector_front.x = math.cos(player.orientation*math.pi/180) * player.speed
  vector_front.y = math.sin(player.orientation*math.pi/180) * player.speed
  player.vectors['z'] = vector_front

  -- Calcul "vecteur" Arrière
  vector_back = {}
  vector_back.x = math.cos((player.orientation+180)*math.pi/180) * player.speed
  vector_back.y = math.sin((player.orientation+180)*math.pi/180) * player.speed
  player.vectors['s'] = vector_back

  -- Calcul "vecteur" Gauche
  vector_left = {}
  vector_left.x = math.cos((player.orientation+90)*math.pi/180) * player.speed
  vector_left.y = math.sin((player.orientation+90)*math.pi/180) * player.speed
  player.vectors['q'] = vector_left

  -- Calcul "vecteur" Droite
  vector_right = {}
  vector_right.x = math.cos((player.orientation+270)*math.pi/180) * player.speed
  vector_right.y = math.sin((player.orientation+270)*math.pi/180) * player.speed
  player.vectors['d'] = vector_right

  -- Déplacement du joueur
  if love.keyboard.isDown("z") then
    player.x = player.x + player.vectors['z'].x*dt
    player.y = player.y - player.vectors['z'].y*dt
  end
  if love.keyboard.isDown("s") then
    player.x = player.x + player.vectors['s'].x*dt
    player.y = player.y - player.vectors['s'].y*dt
  end
  if love.keyboard.isDown("q") then
    player.x = player.x + player.vectors['q'].x*dt
    player.y = player.y - player.vectors['q'].y*dt
  end
  if love.keyboard.isDown("d") then
    player.x = player.x + player.vectors['d'].x*dt
    player.y = player.y - player.vectors['d'].y*dt
  end

  -- orientation du joueur
  if player.orientation < 0 or player.orientation  > 360 then
    player.orientation = 360 - player.orientation
  end

  -- Gestion des rayons
  player.rays = {}
  for alpha = player.fov, 0, -player.fov/player.resolution  do

    local _alpha = alpha + player.orientation - player.fov/2

    ray = {}
    ray.x = player.x + math.cos(_alpha*math.pi/180) * love.graphics.getWidth()*2
    ray.y = player.y - math.sin(_alpha*math.pi/180) * love.graphics.getWidth()*2
    ray.distance = nil
    ray.alpha = _alpha - player.orientation

    for i,wall in ipairs(walls) do

      -- Segment 1
      local x1 = player.x
      local y1 = player.y
      local x2 = ray.x
      local y2 = ray.y

      -- Segment 2
      local x3 = wall.x1
      local y3 = wall.y1
      local x4 = wall.x2
      local y4 = wall.y2


      local den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4)

      local t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den
      local u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den

      if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
        local intersect = {}
        intersect.x = x1 + t*(x2-x1)
        intersect.y = y1 + t*(y2-y1)
        ray.x = intersect.x
        ray.y = intersect.y
        ray.distance = math.sqrt(math.pow((ray.x-player.x), 2)+math.pow(ray.y-player.y, 2))
        ray.distanceVue = math.cos(ray.alpha*math.pi/180) * ray.distance/15
      end

    end


    table.insert(player.rays, ray)
  end

  for i, ball in ipairs(gunBalls) do
    -- Pour le moment la balle se déplace avec le même vecteur vitesse que le joueur, à terme lui créer son propre vecteur vitesse à partir de l'angle d'orientation du joueur
    ball.x = ball.x + ball.vector.x * dt *5
    ball.y = ball.y - ball.vector.y * dt *5

    ball.distanceFromJoueur = math.sqrt(math.pow(player.x-ball.x, 2)+math.pow(player.y-ball.y, 2))
  end

end

-- Gestion du clavier
function love.keypressed(key, scancode, isrepeat)

  -- Touche "Reset"
   if key == "r" then
     doomE1m1:stop()
    love.load()
   end

   -- Touche "Quitter"
   if key == "escape" then
     love.event.quit(0)
   end

   -- Touche "Pause musique"
   if key == "p" then
     if doomE1m1:isPlaying() then
       doomE1m1:pause()
     else
       doomE1m1:play()
     end
   end

   -- Touche "Map"
   if key == "m" then
     viewMap = not viewMap
   end
end

function love.mousemoved( x, y, dx, dy, istouch )
  --player.orientation = player.orientation - dx*0.5
  
  if dx < 0 then
    player.orientation = player.orientation + math.abs(dx) * 0.5
  else
    player.orientation = player.orientation - math.abs(dx) * 0.5
  end
  
end

function love.mousepressed(x, y, button)
   if button == 1 then
     print("PAN !")

     ball = {}
     ball.x = player.x
     ball.y = player.y
     ball.vector = player.vectors['z']
     table.insert(gunBalls,ball)

     local _gun_sound = gun_sound:clone()
     _gun_sound:play()
   end
end

function love.draw()

  if viewMap then
    draw2D()
  else
    draw3D()
  end

  drawHUD()
end

function drawHUD()
love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.rectangle('fill', 10, 10, 200, 50)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS : " .. fps, 20, 20)
  love.graphics.print("Orentation : " .. math.floor(player.orientation) .. "°", 20, 35)
end

function draw2D()
  love.graphics.setColor(1, 1, 1)

  for index, ray in ipairs(player.rays) do
    love.graphics.line(player.x, player.y, ray.x, ray.y)
  end

  love.graphics.setColor(1, 0, 0)
  love.graphics.circle('fill', player.x, player.y, 3, 32)
  love.graphics.line(player.x, player.y, player.x+player.vectors['z'].x, player.y-player.vectors['z'].y)
  for index,wall in ipairs(walls) do
    love.graphics.line(wall.x1, wall.y1, wall.x2, wall.y2)
  end

  for i, ball in ipairs(gunBalls) do
    love.graphics.setColor(0.8, 0.3, 0)
    love.graphics.circle('fill', ball.x, ball.y, 2, 8)
  end

end

function draw3D()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(backgroudGradiant, 0, 0, 0, love.graphics.getDimensions())

  local _lastN2Rays = {}

  for i,ray in ipairs(player.rays) do

    if ray.distance ~= nil then

      --local _distance = ray.distance/15 -- rendu 'fisheye'
      local _distance = ray.distanceVue

      if _distance == 0 then
        rect_height = love.graphics.getHeight()
      else
        rect_height = love.graphics.getHeight()/_distance
      end

    rect_width = love.graphics.getWidth()/player.resolution

      local _colorLevel = (-1/6.5) * _distance + 1
      love.graphics.setColor(_colorLevel+0.1, _colorLevel+0.1, _colorLevel+0.1)

      love.graphics.rectangle('fill', (i-1)*rect_width, love.graphics.getHeight()/2-rect_height/2, rect_width, rect_height)
      --love.graphics.print(ray.distance, (i-1)*rect_width , 10)
   end

  end

  -- Dessin des balles
  --[[for i, ball in ipairs(gunBalls) do
    love.graphics.setColor(0.8, 0.5, 0)
    love.graphics.circle('fill', love.graphics.getWidth()/2, love.graphics.getHeight()-ball.distanceFromJoueur-gun_png:getHeight(), 5, 8)
  end]]

  -- Dessin de l'arme
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gun_png, love.graphics.getWidth()/2 - gun_png:getWidth()/2, love.graphics.getHeight() - gun_png:getHeight())

end


function setHexColor(r,g,b)
  return {r/255, g/255, b/255}
end
------------------------------------------------------------------------------------------
-- Color multipler
local COLOR_MUL = love._version >= "11.0" and 1 or 255

function gradientMesh(dir, ...)
    -- Check for direction
    local isHorizontal = true
    if dir == "vertical" then
        isHorizontal = false
    elseif dir ~= "horizontal" then
        error("bad argument #1 to 'gradient' (invalid value)", 2)
    end

    -- Check for colors
    local colorLen = select("#", ...)
    if colorLen < 2 then
        error("color list is less than two", 2)
    end

    -- Generate mesh
    local meshData = {}
    if isHorizontal then
        for i = 1, colorLen do
            local color = select(i, ...)
            local x = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {x, 1, x, 1, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
            meshData[#meshData + 1] = {x, 0, x, 0, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
        end
    else
        for i = 1, colorLen do
            local color = select(i, ...)
            local y = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {1, y, 1, y, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
            meshData[#meshData + 1] = {0, y, 0, y, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
        end
    end

    -- Resulting Mesh has 1x1 image size
    return love.graphics.newMesh(meshData, "strip", "static")
end
