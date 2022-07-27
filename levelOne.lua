local function _createWall(x1, y1, x2, y2)
  local wall = {}
  wall.x1 = x1
  wall.y1 = y1
  wall.x2 = x2
  wall.y2 = y2
  return wall
end

LevelOne = {

  init = function()
    local _walls = {}

    -- Couloir de début
    table.insert(_walls,_createWall(100,100,200,100))
    table.insert(_walls,_createWall(100,100,100,120))
    table.insert(_walls,_createWall(100,120,180,120))

    -- Couloir 90°
    table.insert(_walls,_createWall(200,100,200,200))
    table.insert(_walls,_createWall(180,120,180,200))

    -- Salle octogonale
    table.insert(_walls,_createWall(180,200,140,240))
    table.insert(_walls,_createWall(200,200,240,240))
    table.insert(_walls,_createWall(140,240,140,260))
    table.insert(_walls,_createWall(140,260,180,300))
    table.insert(_walls,_createWall(240,260,200,300))

    -- Alcove sale octogonale
    table.insert(_walls,_createWall(180,300,180,320))
    table.insert(_walls,_createWall(200,300,200,320))
    table.insert(_walls,_createWall(180,320,200,320))

    -- Couloir de sortie
    table.insert(_walls,_createWall(240,240,340,240))
    table.insert(_walls,_createWall(240,260,340,260))

    -- Grande salle
    table.insert(_walls,_createWall(340,240,340,180))
    table.insert(_walls,_createWall(340,260,340,320))
    table.insert(_walls,_createWall(360,160,420,160))
    table.insert(_walls,_createWall(420,160,440,180))
    table.insert(_walls,_createWall(360,340,420,340))
    table.insert(_walls,_createWall(420,340,440,320))
    table.insert(_walls,_createWall(440,180,440,320))



    --[[-- Pilier 1 grande salle
    table.insert(_walls,_createWall(380,200,400,200))
    table.insert(_walls,_createWall(380,200,380,220))
    table.insert(_walls,_createWall(400,200,400,220))
    table.insert(_walls,_createWall(380,220,400,220))

    -- Pilier 2 grande salle
    table.insert(_walls,_createWall(380,300,400,300))
    table.insert(_walls,_createWall(380,300,380,280))
    table.insert(_walls,_createWall(400,300,400,280))
    table.insert(_walls,_createWall(380,280,400,280))--]]

    return _walls
  end


}



return LevelOne
