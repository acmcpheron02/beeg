pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
debug = false

scene = "title"
ani = -1
ti = 5
timer = 0
actors = {}
player = {}
title = {
  ["size"] = 1,
  ["posx"] = 32,
  ["posy"] = 32,
  ["w"] = 62,
  ["h"] = 32
  }

food_sprites = {
  ["plankton"] = {32},
  ["krill"] = {33},
  ["shrimp"] = {34, 35},
  ["player"] = {0}
}
particles = {}

function _init() end 

function _update()
  adv_frame()
  if scene == "title" then title_update() end
  if scene == "trans" then trans_update() end
  if scene == "lvl1" then lvl1_update() end
end

function _draw()
  if scene == "title" then title_draw() end
  if scene == "trans" then trans_draw() end
  if scene == "lvl1" then lvl1_draw() end
  --debug prints
  if debug == true then
  end
end

function title_update()
  pulse = 1
  if ani < 64 then pulse = 1 + ((ani/256)) end
  if ani >= 64 then pulse = 1.25 - ((ani%64)/256) end
  --if ani >= 120 then pulse = 1 end
  if btn(5) then scene = "trans" end
end

function title_draw()
  cls(0)
  circfill(5, 20, 12, 6)
  rectfill(0,88,128,10028,1)
  sspr(64, 32, 64, 16, ani/2-64, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2+64, (ani/32)%2 + 80)
  sspr(0, 32, 64, 32, 32-(32*pulse-32), 20-(16*pulse-16), 64*pulse, 32*pulse)
  print("by cody mcpheron", 32, 62, 6) --16 char
  print("press x to get beeg!", 26, 106, 6) --20 char
end

function trans_update ()
  if ti < 500 then
    ti *= 1.1
    title_update()
    camera(0, flr(ti)-5)
  end
  if ti >= 500 then
    ti = 5
    scene = "lvl1"
    lvl1_init()
  end
end

function trans_draw()
  title_draw()
end

function lvl1_init()
  player = make_player(600, 600, 6, 6)
  cam = make_camera()
  make_actor("plankton", 620, 620, 7, 7, 32)
  make_actor("plankton", 620, 580, 7, 7, 32)
end

function lvl1_draw()
  cls(1)
  foreach(particles, draw_particles)
  for i = 1, #actors do
    if(actors[i].kind != "player") then
      actors[i].draw_actor()
    end
  end
  player.draw_actor()
  circfill(cam.posx+8, cam.posy, 22, 8)
  print("size:", cam.posx + 3, cam.posy + 2, 10) 
  print(format(player.mass, 2), cam.posx + 3, cam.posy + 10, 10)
  circfill(cam.posx+119, cam.posy, 22, 8)
  print("time:", cam.posx + 107, cam.posy + 2, 10)
  print(flr(timer), cam.posx + 126 - #tostr(flr(timer))*4, cam.posy + 10, 10)
end

function lvl1_update()
  player.move()
  cam.cameraDraw()
  while #actors < 16 do
    spawn_food()
  end
  collisions()
  foreach(particles, update_particles)
  timer += 0.033
end

function format(n,d)
  return
    flr(n) .. "." ..
    flr(n%1 * 10^d)
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
  if abs(xdist) > 150 or abs(ydist) > 150 then
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
  p.mass = 20.0
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
  c.posx = player.x - 62
  c.posy = player.y - 62
  function c.cameraDraw()
    local bounds = 24
    local offset = 64
    --right bounds
    if (player.x+player.w-offset > c.posx + bounds) then c.posx = player.x + player.w - offset - bounds end
    --left bounds
    if (player.x-offset < c.posx - bounds) then c.posx = player.x - offset + bounds end
    --lower bounds
    if (player.y+player.h-offset > bounds + c.posy) then c.posy = player.y + player.h - offset - bounds end
    --upper bounds
    if (player.y-offset < c.posy - bounds) then c.posy = player.y - offset + bounds end
    camera(c.posx, c.posy)
  end
  return c
end

function attach(pl, t)
  local tr = 4 --target ratio
  local er = sqrt(pl.size)*0.4 --eat range
  t.x=(pl.x*t.attSp + t.x*tr)/(t.attSp+tr)
  t.y=(pl.y*t.attSp + t.y*tr)/(t.attSp+tr)
  if abs(t.x-pl.x) < er and abs(t.y-pl.y) < er then
    eat(pl, t)
  else t.attSp += 0.8
  end
end

function eat(pl, t)
  eated = true
  eat_fx(pl, t)
  del(actors, t)
  pl.add_mass(1.1)
end

function spawn_food()
  local spawnDir = flr(rnd(4))
  local offset = flr(rnd(128))-64
  local soff = flr(rnd(24))
  local x
  local y
  if spawnDir == 0 then x,y = 64+soff,offset end
  if spawnDir == 1 then x,y = -64-soff,offset end
  if spawnDir == 2 then x,y = offset,64+soff end
  if spawnDir == 3 then x,y = offset,-64-soff end
  make_actor("food", x+cam.posx+64, y+cam.posy+64, 7, 7, 32) --make_actor(k,x,y,h,w,s)
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

function adv_frame()
  local reset = 127
  if ani < reset then ani += 1 end
  if ani >= reset then ani = 0 end
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
111111111111c1c1111cc1111c1c1111000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111c1111c11c1111c11111000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111c11111111c11c11111111110061cc600060060000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111c1c11111111cc11111111111c6c11ccccc16c16c00000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111c11111111111111111111c1111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
b00000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b000b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00033b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0bb00b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b00000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee8882000000000ee88888888888200ee88888888888200000e888888882000000000000000000060000000000000000060000000000000000000000000000
ee88888888820000ee88888888888882ee8888888888888200ee88888888882000006000000000000c60000000000000000c6000006006000000600000000000
e888888888882000e888888888888882e8888888888888820ee88888888888820000c6000000000061cc6000600600c00061cc60cc16cc600000c60000600000
e88888888888822ee888888888888882e888888888888882ee8888888888888200061cc6000600c6c11ccccc16c16c1cc6c11ccc11111cc666061cc600c60060
888888888888882e88888888888888828888888888888882e8888888888888820c6c11ccccc16c111111111111116111111111111111111ccc6c11ccccc16c16
888820008888882e88888888888888208888888888888820e888888888888882c111111111116111111111111111c61111111111111111111111111111111111
8888200088888828888888200000000088888820000000008888882008888882111111111111c6111111111111161cc611161111116111111111111111111111
88882000088888288888820000000000888882000000000088888200008888821111111111161cc6111111611c6c11ccccc16c1111c6111111c6c11ccccc16c1
888820000888882888882000000000008888200000000000888882000088888211161111cc6c11ccccc11116c111111111111111161cc6111611111111111111
8888200028888828888820000000000088882000000000008888820000888882111c6111111111111111111111116111111111116c11ccccc11111111c611111
88882000888888288888200000022220888820000002222088888200008888821161cc6111111111111111111116c6111161111c11111111111111111cc61111
8888222288888828888820002228888288882000222888828888820000888880c6c11ccccc1111c611111661111111111c1611166111111111111111c61cc611
88888888888882288888222288888882888822228888888288888200000000001111111111111c6cc611ccc6611611111111111ccc6111611611111c61111cc6
888888888882000888888888888888828888888888888882888882000000000011166111111cc6111111111cc66ccc61111111611ccccc16c16c111111111111
88888888888820088888888888888882888888888888888288888202222222221cc1ccc111c6111111111111111111111111c6c1111111111111111111111111
88888888888882088888888888888882888888888888888288888208888888821111111111111111111111111111111111111111111111111111111111111111
88888888888888288888888888888882888888888888888088888208888888820000000000000000000000000000000000000000000000000000000000000000
88888888888888288888888888888820888888888888888088888208888888820000000000000000000000000000000000000000000000000000000000000000
88888888888888288888888888882000888888888888200088888208888888820000000000000000000000000000000000000000000000000000000000000000
88882000888888288888888882000000888888888200000088888200008888820000000000000000000000000000000000000000000000000000000000000000
88882000888888288888820000000000888882000000000088888200000888820000000000000000000000000000000000000000000000000000000000000000
88882000088888288888200000000000888820000000000088888200000888820000000000000000000000000000000000000000000000000000000000000000
88882000088888288888200000000000888820000000000088888200000888820000000000000000000000000000000000000000000000000000000000000000
88882000288888288888200000000000888820000000000088888820002888820000000000000000000000000000000000000000000000000000000000000000
88882000888888288888200000022200888820000002222088888882228888820000000000000000000000000000000000000000000000000000000000000000
88882222888888288888822222288820888882222228888288888888888888820000000000000000000000000000000000000000000000000000000000000000
88888888888888288888888888888882888888888888888288888888888888820000000000000000000000000000000000000000000000000000000000000000
88888888888880088888888888888882888888888888888288888888888888820000000000000000000000000000000000000000000000000000000000000000
888888888888000e8888888888888882888888888888888288888888888888820000000000000000000000000000000000000000000000000000000000000000
8888888888800000e888888888888882e888888888888882e8888888888888800000000000000000000000000000000000000000000000000000000000000000
e888888880000000ee88888888888882eee88888888888820ee88888888888200000000000000000000000000000000000000000000000000000000000000000
eeeeee000000000000eeee888888820000eeee8888888200000eee88888882000000000000000000000000000000000000000000000000000000000000000000
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
