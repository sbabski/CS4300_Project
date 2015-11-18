debug = true
winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
p1 = {x = 0, y = winH-35, w = winW, h = 35}
p2 = {x = 300, y = 325, w = 170, h = 35}
p3 = {x = 450, y = 225, w = 130, h = 35}
p4 = {x = 670, y = 160, w = 300, h = 35}
platforms = {p1, p2, p3, p4}
player = {x = 0, y = 0,
          w = 0, h = 0, 
          xV = 150, yV = 0, 
          right= true, img = nil}
gravity = -400
jV = 300
acc = 100
floor = p1
initCeiling = {x = 0, y = 0, w = winW, h = 0}
ceiling = {}
test = 'false'
test2 = 'false'


function love.load(arg)
  player.img = love.graphics.newImage("assets/sprite.png")
  player.y = floor.y - player.img:getHeight()
  player.w = player.img:getWidth()
  player.h = player.img:getHeight()
  ceiling = initCeiling
end

function love.update(dt)
  -- KEYBOARD INPUT
  if love.keyboard.isDown('left') then
    if player.x > 0 then
      if player.right then
        player.xV = 150
      end
      player.right = false
      player.x = player.x - player.xV*dt
      player.xV = player.xV + acc*dt
    end
  end
  if love.keyboard.isDown('right') then
    if player.x < (winW - player.w) then
      if player.right == false then
        player.xV = 150
      end
      player.right = true
      player.x = player.x + player.xV*dt
      player.xV = player.xV + acc*dt
    end
  end

  -- JUMPING
  if player.yV ~= 0 then
    if player.y <= ceiling.y + ceiling.h + 5 then
      player.yV = 0 - (winH - (ceiling.y + ceiling.h));
    end
    player.y = player.y - player.yV*dt
    player.yV = player.yV + gravity*dt
    if player.y >= floor.y - 50 then
      player.yV = 0
      player.y = floor.y - player.h
    end
  end

  -- REPLACE FLOOR
  if player.y + player.h >= p2.y and player.y <= p2.y + p2.h then
    if colX() then
      floor = p2
    else
      if player.yV == 0 then
        player.yV = 1
      end
      floor = p1
    end
  else
    floor = p1
  end

  -- REPLACE CEILING
  if colX() and player.y >= p2.y then
    ceiling = p2
  else
    ceiling = initCeiling
  end
end

function colX()
  if player.x + player.w >= p2.x and player.x <= p2.x + p2.w then
    return true;
  else
    return false;
  end
end

function colY()
  if player.y <= p2.y + p2.h and player.y + player.h >= p2.y then
    return true
  else 
    return false
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push('quit')
  end
  if key == " " then
    if player.yV == 0 then
      player.yV = jV
    end
  end
end

function love.draw(dt)
  --[[
  if colX() and colY() then
    love.graphics.print('collision')
  end
  ]]--
  for i=1, #platforms do
    love.graphics.rectangle('fill', platforms[i].x, platforms[i].y, platforms[i].w, platforms[i].h)
  end  
  if player.right then
    love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 0)
  else
    love.graphics.draw(player.img, player.x, player.y, 0, -1, 1, player.img:getWidth(), 0)
  end
end