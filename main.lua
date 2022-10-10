Vector = require "librairies/vector"
MathUtils = require "librairies/mathUtils"
AnimationUtils = require "librairies/animationUtils"

HUD = require "hud"
Raycast = require "raycast"
Level = require "level"
Player = require "player"
Minimap = require "minimap"


function love.load()

  -- Theme
  doomE1m1 = love.audio.newSource("resources/audio/doom.wav", "stream")
  doomE1m1:setLooping(true)
  doomE1m1:setVolume(0.5)
  doomE1m1:play()

  -- Shotgun
  shotgun_sound = love.audio.newSource("resources/audio/shotgun.wav", "static")
  shotgun_sound:setVolume(1)

  -- Shotgun spritesheet
  shotgunAnimation = AnimationUtils:new(love.graphics.newImage("resources/img/Shotgun spritesheet.png"), 135, 140, 1.5)
  heartAnimation = AnimationUtils:new(love.graphics.newImage("resources/img/Heart spritesheet.png"), 234, 268, 0.3)

  -- Base texture
  baseTextureData = love.image.newImageData('resources/img/base texture.png')
  baseTextureData_width = baseTextureData:getWidth()
  baseTextureData_height = baseTextureData:getHeight()
  --baseTextureData = love.image.newImageData('resources/img/bricks.png')

  -- Switch mode "texturé" ou mode "simple"
  texturesOn = false

  -- Font utilisé pour les fps
  middleFont = love.graphics.newFont(20)

  love.mouse.setRelativeMode(true)
  love.mouse.setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  love.mouse.setGrabbed(true)

  Level:init()
  Player:init(15, 0)
  Raycast:init(60,800) -- Raycast:init(60,800)

  HUD:init()
  Minimap:init(20, 20, 175, 100)

  mode = "3D"
  displayCasting = false

end



function love.update(dt)
  Player:update(dt)
  Raycast:update(dt)
  HUD:update(dt)
end




function love.keypressed(key, scancode, isrepeat)

   -- Touche "Quitter"
   if key == "escape" then
     love.event.quit(0)
   elseif key == "m" then
     if mode == "3D" then
       mode = "2D"
     elseif mode == "2D" then
       mode = "3D"
     end
   elseif key == "c" then
     if displayCasting then
       displayCasting = false
     else
       displayCasting = true
     end
   elseif key == "p" then
     if doomE1m1:isPlaying() then
        doomE1m1:pause()
      else
        doomE1m1:play()
      end
    elseif key == "t" then
      if texturesOn == true then
        texturesOn = false
      else
        texturesOn = true
      end
   end

end


function love.draw()

  if mode == "2D" then
    Level:draw()
    if displayCasting then Raycast:draw2D() end
    Player:draw2D()
  elseif mode == "3D" then
    Raycast:draw3D()
    Player:draw3D()
    HUD:draw()
  end

end
