pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
debug = true

actors = {}
player = {}
food_sprites = {
  ["plankton"] = {32},
  ["krill"] = {33},
  ["shrimp"] = {34, 35},
  ["player"] = {0}
}
particles = {}

function _init()
  player = make_player(60, 60, 6, 6)
  cam = make_camera()
  make_actor("plankton", 60, 90, 7, 7, 32)
  make_actor("plankton", 90, 60, 7, 7, 32)
  -- make_actor("plankton", 90, 20, 7, 7, 32)
  -- make_actor("plankton", 20, 20, 7, 7, 32)
  -- make_actor("plankton", 40, 40, 7, 7, 32)
  -- make_actor("plankton", 40, 70, 7, 7, 32)
  -- make_actor("plankton", 70, 40, 7, 7, 32)
  -- make_actor("plankton", 70, 70, 7, 7, 32)
end 

function _update()
  player.move()
  cam.cameraDraw()
  while #actors < 8 do
    spawn_food()
  end
  collisions()
  foreach(particles, update_particles)
end

function _draw()
  cls(1)
  map(0,0,0,0,200,200)
  foreach(particles, draw_particles)
  for i = 1, #actors do
    if(actors[i].kind != "player") then
      actors[i].draw_actor()
    end
  end
  player.draw_actor()
  --debug prints
  if debug == true then
    print(player.x)
    -- print(player.x+player.w)
    -- print(cam.posX)
    -- print(player.radius)
    -- print("bounds = 24")
    -- print("offset = 64")
    -- print("threshold = 88")
    collisions()
  end
end

function collisions()
  for a1 in all(actors) do
   collide(player,a1)
  end
end

function collide(a1, a2)
  if (a1==a2) then return end
  xdist = a1.xCen() - a2.xCen()
  ydist = a1.yCen() - a2.yCen()
  if xdist > 256 or ydist > 256 then
    del(actors, a2)
  end
  if xdist < a1.radius + 4 and ydist < a1.radius + 4 then
    if (a1.radius*a1.radius)>(xdist * xdist + ydist * ydist)-(a2.w*a2.h) then
      collide_event(a1, a2)
    end
  end
end

function collide_event(a1, a2)
  if(a1.kind=="player") then
    if(a2.kind!="player") then
      attach(a1,a2)
    end
  end
end

function make_actor(k,x,y,h,w,s)
  local a = {}
  a.kind = k
  a.x=x or 0
  a.y=y or 0
  a.h=h or 7
  a.w=w or 7
  a.xFlipped = 0
  a.sprite = s
  a.attSp = 0
  function a.xCen() 
    return a.x + a.w/2
  end 
  function a.yCen() 
    return a.y + a.h/2
  end 
  function a.draw_actor()
    spr(a.sprite, a.x, a.y, 1, 1, a.xFlipped)
    if debug == true then
      pset(a.x, a.y, 7)
      pset(a.x, a.y+a.h, 7)
      pset(a.x+a.w, a.y, 7)
      pset(a.x+a.w, a.y+a.h, 7)
    end
  end
  add(actors, a)
  return a
end


function make_player(x,y,h,w)
  local p = {}
  p = make_actor("player", x, y, h, w)
  function p.set_size()
    local increment = 4
    p.size = 2 + flr((p.mass - p.base_mass)/4)
  end
  function p.set_accel()
    local accel = mid(5, p.base_accel - (p.mass - p.base_mass)/10, 0.5)
    p.accel = accel
    return accel
  end
  function p.set_friction()
    local friction = mid(0.95, (p.base_friction + (p.mass - p.base_mass)/50), 0.1)
    p.friction = friction
    return friction
  end
  function p.set_radius()
    local radius = (p.w/2)+p.size
    p.radius = radius
    return radius
  end
  p.dx = 0
  p.dy = 0
  p.x_speed = 0
  p.y_speed = 0
  p.mass = 20
  p.base_accel = 1.2
  p.base_friction = .45
  p.base_mass = 20
  p.max_speed = 4
  p.stop_under = 0.05
  p.size = 2
  p.accel = 0
  p.friction = 0
  p.radius = 5
  p.anim = {
    state = {0},
    idle = 0,
    side = 1,
    up = 2,
    down = 3,
    xFlipped = false
  }
  function p.add_mass(m)
    p.mass += m
    p.set_accel()
    p.set_friction()
    p.set_size()
    p.set_radius()
  end
  
  function p.move()
    p.dx, p.dy = direction_control()
    if(abs(p.x_speed) < p.stop_under and p.dx == 0) then p.x_speed = 0 end
    if(abs(p.y_speed) < p.stop_under and p.dy == 0) then p.y_speed = 0 end
    p.x_speed = p.x_speed + (p.dx * p.accel)
    p.y_speed = p.y_speed + (p.dy * p.accel)
    p.x_speed = mid(p.max_speed, p.x_speed, p.max_speed*-1)
    p.y_speed = mid(p.max_speed, p.y_speed, p.max_speed*-1)
    if p.dx == 0 then p.x_speed = p.x_speed * p.friction end
    if p.dy == 0 then p.y_speed = p.y_speed * p.friction end
    if abs(p.x_speed) < p.stop_under then p.x_speed = 0 end
    if abs(p.y_speed) < p.stop_under then p.y_speed = 0 end
    p.x += p.x_speed
    p.y += p.y_speed
  end
  
  function p.draw_actor()
    ovalfill(p.x-p.size, p.y-p.size, p.x+p.w+p.size, p.y+p.h+p.size, 8)
    spr(p.sprite, p.x, p.y, 1, 1, p.xFlipped)
    if debug == true then
      pset(p.x, p.y, 7)
      pset(p.x, p.y+p.h, 7)
      pset(p.x+p.w, p.y, 7)
      pset(p.x+p.w, p.y+p.h, 7)
    end
  end

  p.add_mass(0)

  return p
end

function direction_control ()
  local dx = 0
  local dy = 0

  if(btn(0)) then dx = -1 end
  if(btn(1)) then dx = 1 end
  if(btn(2)) then dy = -1 end
  if(btn(3)) then dy = 1 end
  if(btn(0)) and (btn(1)) then dx = 0 end
  if(btn(2)) and (btn(3)) then dy = 0 end
  if(dx != 0) and (dy != 0) then
    local dist = sqrt(dx*dx+dy*dy)
    dx /= dist
    dy /= dist
  end
  return dx, dy
end

function make_camera()
  local c = {}
  c.posX = 0
  c.posY = 0
  function c.cameraDraw()
    local bounds = 24
    local offset = 64
    --right bounds
    if (player.x+player.w-offset > c.posX + bounds) then c.posX = player.x + player.w - offset - bounds end
    --left bounds
    if (player.x-offset < c.posX - bounds) then c.posX = player.x - offset + bounds end
    --lower bounds
    if (player.y+player.h-offset > bounds + c.posY) then c.posY = player.y + player.h - offset - bounds end
    --upper bounds
    if (player.y-offset < c.posY - bounds) then c.posY = player.y - offset + bounds end
    camera(c.posX, c.posY)
  end
  return c
end

function attach(pl, t)
  local tr = 75 --target ratio
  local er = sqrt(pl.size)*0.4 --eat range
  t.x=(pl.x*t.attSp + t.x*tr)/(t.attSp+tr)
  t.y=(pl.y*t.attSp + t.y*tr)/(t.attSp+tr)
  if abs(t.x-pl.x) < er and abs(t.y-pl.y) < er then
    eat(pl, t)
  else t.attSp += 1
  end
end

function eat(pl, t)
  eated = true
  eat_fx(pl, t)
  del(actors, t)
  pl.add_mass(4)
end

function spawn_food()
  local spawnDir = flr(rnd(4))
  local offset = flr(rnd(128))-64
  local x
  local y
  if spawnDir == 0 then x,y = 70,offset end
  if spawnDir == 1 then x,y = -70,offset end
  if spawnDir == 2 then x,y = offset,70 end
  if spawnDir == 3 then x,y = offset,-70 end
  --printh(spawnDir)
  printh(cam.posX)
  make_actor("food", x+cam.posX+64, y+cam.posY+64, 7, 7, 32) --make_actor(k,x,y,h,w,s)
end

function eat_fx (pl, t)
  local sp = 4.5 --speed
  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = sp, sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)

  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = sp, -sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)
  
  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = -sp, sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)
  
  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = -sp, -sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)

  local sp = 6

  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = sp, 0, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)

  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = -sp, 0, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)
  
  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = 0, sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)
  
  local fx = {}
  fx.dx,fx.dy,fx.dur,fx.pal,fx.x,fx.y = 0, -sp, 20, 7, pl.xCen(), pl.yCen()
  add(particles, fx)

end

function update_particles(fx)
  if fx.dur > 0 then
    fx.x += fx.dx
    fx.y += fx.dy
    fx.dur -= 1
    fx.dx *= .6
    fx.dy *= .6
    if fx.dur <= 0 then del(particles, fx) end
  end
end

function draw_particles(fx)
  if fx.dur != 7 and fx.dur != 6 and fx.dur != 2 then 
    pset(fx.x, fx.y, fx.pal) else return 
  end
end







__gfx__
00990990000990990990990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900900070700009909900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000707000000700700a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0a0a0e0000a00ae00000e000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e0a00a0000000000a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000909000000000000909000e00000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009000000900000009000000909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099000000000000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111c111111111111c11111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111c1c1111cc1111c1c1111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111c1111c11c1111c11111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111c11111111c11c1111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111c1c11111111cc11111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111c11111111111111111111c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b00000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b000b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00033b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0bb00b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b00000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000121212121212121212121200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000001212120000000000000000001212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000012121200000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000012000000000000000000000000000000001212000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000121212000000000000000000000000000000121200000000000000000000000000000000121200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000012120000000000000000000000000000000012000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000012000000000000000000000000000000001200000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000001200000000000000000000000000000000121200000000000000000000000000000000000000001212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000120000000000000000121212121212121212121200000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000012120000000000000012120000000000000012001212120000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001212000000000000000012000000000000000012121200120000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000121200000000000000001212000000000000000000001212121200000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000120000000000000000001200000000000000000000000000001212120000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012121212121212121200001200000000000000000000000000001200001212120000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012001200000000000012121200000000000000000000000000001200000000001212120000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012001200000000000000001212000000000000000000000000001200000000000000121212000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012001200000000000000000012000000000000000000000000001200000000000000000012120000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012001200000000000000000012120000000000000000000000121200000000000000000012120000000000001200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012001212000000000000000000121200000000000000000000120000000000000000000012000000000000001200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012000012000000000000000000000012120000000000000012120000000000000000121200000000000000121200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000012000012000000000000000000000000121212120000000012000000000000000012120000000000000012120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000120000120000000000000000000000000000121212121212000000000000001212000000000000001212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000121200120000000000000000000000000000000000121212120000001212120000000000000000121200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001212001200000000000000000000000000000000121200121212121200000000000000121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000012121212000000121212121212121212121212121212000000001212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
