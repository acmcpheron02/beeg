pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
debug = false

function _init() 
  initsteps()
  poke4(0x5600,unpack(split"0x9.0908,0x.0100,0x1100,0x4620.2100,0x4110.1674,0x7774.7711,0,0x111.7700,0x.0001,0x14.0740,0x1700.0700,0x715.1000,0x.0004,0x110.0010,0x1101.0010,0x105.0011,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x3f3f.3f3f,0x3f3f.3f3f,0x3f3f.3f00,0x3f.3f3f,0x333f.3f00,0x3f.3f33,0xc33.3300,0x33.330c,0x33.3300,0x33.3300,0x3333.3300,0x33.3333,0xfffc.f0c0,0xc0f0.fcff,0xff3f.0f03,0x30f.3fff,0x303.0f0f,0,0,0x7878.6060,0x3c7e.e7c3,0x187e.187e,0xc00,0x.000c,0,0x607.0303,0,0xf0f.0f0f,0x1b1b.1b1b,0,0x1f1b.1f0e,0x.000e,0,0,0x1e3f.3f3f,0xc0c.001e,0x1b1b.1b1b,0,0x66ff.ff66,0x66ff.ff66,0x3f13.7f7e,0x3f7f.647e,0x3873.e7c6,0x63e7.ce1c,0x3f33.3f1e,0x3e7f.e3fe,0x307.0606,0,0x60e.3c38,0x383c.0e06,0x3038.1e0e,0xe1e.3830,0xe1f.1b00,0x.1b1f,0x3f0c.0c00,0xc.0c3f,0,0x307.0606,0x3f00,0x.003f,0,0x303,0x60e.0c0c,0x303.0706,0x6b63.7f3e,0x3e7f.636b,0x181f.1f18,0x7f7f.1818,0x7e60.7f3f,0x7f7f.033f,0x7c60.7f3f,0x3f7f.603c,0x676e.7c78,0x6060.7f7f,0x3f03.7f7f,0x3f7f.607f,0x3f03.7f7e,0x3e7f.637f,0x3870.7f7f,0x307.0e1c,0x3e63.7f3e,0x3e7f.637f,0x7f63.7f3e,0x3f7f.607e,0x.0303,0x303,0x.0606,0x307.0606,0x1f7c.f0c0,0xc0f0.7c1f,0xff.ff00,0xff.ff00,0xf83e.0f03,0x30f.3ef8,0x7c60.7f3f,0xc0c.003c,0xfbdb.ff7e,0xfeff.03fb,0x7e60.7e3e,0x7e7f.637f,0x3f03.0303,0x3f7f.637f,0x637f.3e00,0x3e7f.6303,0x7e60.6060,0x7e7f.637f,0x7f63.7f3e,0x7e7f.037f,0x1f66.7e3c,0x606.061f,0x3f33.7f7e,0x1f3f.381e,0x3f03.0303,0x6363.637f,0x300.0303,0x607.0303,0x3000.3030,0x1e3f.3330,0x3b33.0303,0x333b.1f1f,0x303.0303,0x607.0303,0xffff.6600,0xc3c3.c3db,0x7f3f.0300,0x6363.6363,0x637f.3e00,0x3e7f.6363,0x637f.3f00,0x303.3f7f,0x637f.7e00,0x6060.7e7f,0x3f1f.0300,0x303.0333,0x77f.7e00,0x3f7f.703e,0x3f3f.0606,0x3c3e.0606,0x6363.6300,0x3e7f.6363,0x3f33.3300,0xc0c.1e1e,0xc3c3.c300,0x66ff.ffdb,0x3e77.6300,0x6377.3e1c,0x7f63.6300,0x3f7f.607e,0x387f.7f00,0x7f7f.0e1c,0x606.3e3e,0x3e3e.0606,0x607.0303,0xc0c.0e06,0x3030.3e3e,0x3e3e.3030,0x333f.1e0c,0,0,0xffff,0x607.0303,0,0x7f63.7f3e,0x6363.637f,0x3f63.7f3f,0x3f7f.637f,0x363.7f3e,0x3e7f.6303,0x6363.7f3f,0x3f7f.6363,0x3f03.7f7f,0x7f7f.033f,0x3f03.7f7f,0x303.033f,0x7b03.7f7e,0x3e7f.637b,0x7f63.6363,0x6363.637f,0x1818.ffff,0xffff.1818,0x3030.7e7e,0x1e3f.3330,0x1f3b.7363,0x6373.3b1f,0x303.0303,0x7f7f.0303,0xffff.6666,0xc3c3.dbdb,0xdfcf.c7c3,0xc3e3.f3fb,0x6363.7f3e,0x3e7f.6363,0x6363.7f3f,0x303.3f7f,0x6363.7f3e,0xfeff.7363,0x6363.7f3f,0x6373.3f7f,0x3f03.7f7e,0x3f7f.607e,0x1818.ffff,0x1818.1818,0x6363.6363,0x3e7f.6363,0x66e7.c3c3,0x183c.3c7e,0xdbdb.c3c3,0x6666.ffff,0x3c7e.e7c3,0xc3e7.7e3c,0x7ee7.c3c3,0x1818.183c,0x3870.7f7f,0x7f7f.0e1c,0xe0c.3c38,0x383c.0c0e,0x606.0606,0x606.0606,0x3818.1e0e,0xe1e.1838,0x73fb.dfce,0,0x1f1b.1f1f,0x.001f,0xffff.ffff,0xffff.ffff,0xcccc.3333,0xcccc.3333,0x99ff.ffc3,0x7ec3.e7ff,0xc3c3.ff7e,0x7eff.e7e7,0x3030.0303,0x3030.0303,0xfcfc.0c0c,0x3030.3f3f,0x4f4f.3e00,0x3e7f.7f7f,0x7f7f.3600,0x81c.3e7f,0xe7ff.ff7e,0x7eff.ffe7,0x7f1c.1c00,0x363e.1c7f,0xff7e.3c18,0x6666.7eff,0xc3cf.ff7e,0x7eff.cfc3,0x9999.ff7e,0x7ec3.81ff,0x1818.7838,0xe1f.1f1e,0x99c3.ff7e,0x7eff.c399,0x3f1e.0c00,0xc.1e3f,0x3300,0x.0033,0xc3f3.ff7e,0x7eff.f3c3,0x7f1c.0800,0x6377.3e7f,0x1e3f.3f00,0x3f3f.1e0c,0xe7e7.ff7e,0x7eff.c3c3,0x40e.1f1b,0x2070.f8d8,0xeec7.8301,0x10.387c,0xe799.997e,0x7e99.99e7,0x.ffff,0x.ffff,0x3333.3333,0x3333.3333,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x99ff.8100,0x7ec3.81ff,0xbdff.8100,0x7ec3.bdff,0x99ff.8100,0x7ec3.e7ff,0x9999.ff81,0x7ec3.81ff,0x99bd.ff81,0x7ec3.81ff,0x497f.4100,0x3e63.417f,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x99ff.7e00,0x7ec3.81ff,0x99ff.7e00,0x7ec3.bdff,0x99ff.7e00,0x7eff.81ff,0x99bd.ff7e,0x7ec3.81ff,0x99db.ff7e,0x7ec3.81ff,0x497f.3e00,0x3e63.417f,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x4058.1840,0x545c.5d7e,0x4018.5800,0x141c.5d7e,0x4058.5840,0x145c.5dfe,0x4058.5800,0x141c.5dfe,0x7777.3e00,0x3e77.6341,0x6377.3e00,0x3e77.7741,0x6777.3e00,0x3e77.6741,0x7377.3e00,0x3e77.7341,0x6b5d.3e00,0x3e5d.6b77,0x7f7f.3e00,0x3e7f.7f77,0x637f.3e00,0x3e7f.6349,0xffff,0xffff,0xcccc.cccc,0xcccc.cccc,0,0,0,0,0,0,0x6f3e.1c00,0x1c3e.7f7f"))
  --always use custom font
  poke(0x5f58,0x81)
  --adjust height to allow for outline
  poke(0x5602,10)
end 

function initsteps()
    scene = "title"
    ani = -1
    ti = 5
    timer = 0
    actors = {}
    player = {}
    particles = {}
    cam = nil
    camera(0,0)
end

function _update()
  adv_frame()
  if scene == "title" then title_update() end
  if scene == "trans" then trans_update() end
  if scene == "lvl1" then lvl1_update() end
  if scene == "gameover" then gameover_update() end
end

function _draw()
  --define palette changes
  pal(1, 129, 1)
  --pal(3, 138, 1)
  pal(4, 143, 1)
  pal(10, 135, 1)
  pal(11, 131, 1)
  pal(5, 142, 1)
  poke(0x5f2e,1)

  if scene == "title" then title_draw() end
  if scene == "trans" then trans_draw() end
  if scene == "lvl1" then lvl1_draw() end
  if scene == "gameover" then gameover_draw() end
end

function title_update()
  
  pulse = 1
  if ani < 64 then pulse = 1 + ((ani/256)) end
  if ani >= 64 then pulse = 1.25 - ((ani%64)/256) end
  --if ani >= 120 then pulse = 1 end
  if btnp(5) then scene = "trans" end
end

function title_draw()
  cls(4)
  pal(1, 140, 1)
  circfill(5, 20, 12, 10)
  rectfill(0,88,128,10028,1)
  sspr(64, 32, 64, 16, ani/2-64, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2+64, (ani/32)%2 + 80)
  sspr(0, 32, 64, 32, 32-(32*pulse-32), 14-(14*pulse-14), 64*pulse, 32*pulse)
  print("by", 56, 59, 2) --16 char
  print("by", 55, 58, 8) --16 char
  print("cody mCpheron", 13, 69, 2) --16 char
  print("cody mCpheron", 12, 68, 8) --16 char
  print("press ❎ to", 8, 101, 11) --20 char
  print("press ❎ to", 7, 100, 6) --20 char
  print("become beeg!", 32, 113, 11)
  print("become beeg!", 31, 112, 6)
end

function trans_update ()
  ti *= 1.1
  if ti < 500 then
    title_update()
    camera(0, flr(ti)-5)
  end
  if ti >= 600 and #actors == 0 then
    lvl1_init()
  end
  if ti >= 600 then
    lvl1_update()
  end
  if ti > 2200 then
    scene = "lvl1"
  end
end

function trans_draw()
  if ti < 500 then
    title_draw()
  end
  if ti > 150 and ti <= 220 then
    pal(1, 131, 1)
  end
  if ti > 220 and ti <= 300 then
    pal(1, 1, 1)
  end
  if ti > 300 and ti <= 400 then
    pal(1, 129, 1)
  end
  if ti > 400 and ti <= 600 then
    pal(1, 0, 1)
  end
  if ti >= 600 then
    lvl1_draw()
    rectfill(cam.posx, cam.posy, cam.posx+128, cam.posy+240-ti/6, 0) -- mid(0,800-ti/2,128)
  end
end

function lvl1_init()
  player = make_player(550, 300, 6, 6)
  cam = make_camera()
  make_krill(570, 300)
  make_plankton(530, 300)
  -- make_food("food", 330, 300, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 300, 330, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 270, 300, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 300, 270, 7, 7, food_sprites["plankton"], 16)
end

function lvl1_draw()
  cls(1)
  cam.cameraDraw()
  foreach(particles, draw_particles)

  for i = 1, #actors do
    actors[i].draw_actor() 
  end
  player.draw_actor()

  --UI elements
  circfill(cam.posx+14, cam.posy, 30, 8)
  print("size:", cam.posx + 4, cam.posy + 3, 2) 
  print("size:", cam.posx + 3, cam.posy + 2, 10) 
  print(format(player.mass, 1), cam.posx + 4, cam.posy + 13, 2)
  print(format(player.mass, 1), cam.posx + 3, cam.posy + 12, 10)
  circfill(cam.posx+113, cam.posy, 30, 8)
  print("time:", cam.posx + 90, cam.posy + 3, 2)
  print("time:", cam.posx + 89, cam.posy + 2, 10)
  print(flr(timer), cam.posx + 127 - #tostr(flr(timer))*8, cam.posy + 13, 2)
  print(flr(timer), cam.posx + 126 - #tostr(flr(timer))*8, cam.posy + 12, 10)
end

function lvl1_update()
  player.move()
  cam.cameraDraw()
  while #actors < 18 do
    spawn_food()
  end
  collisions()
  foreach(particles, update_particles)
  for i = 1, #actors do
    actors[i].update_actor()
  end
  timer += 0.033
end

function gameover_update()
  if btnp(5) then initsteps() end
end

function gameover_draw()
  print("game over", cam.posx + 48, cam.posy+26, 7)
  print("YOU AREN'T", cam.posx + 48, cam.posy+50, 7)
  print("beeg", cam.posx + 60, cam.posy+60, 8)
  print("ENOUGH TO CONTINUE!", cam.posx +28 , cam.posy+70, 7)
  print("press x to try again", cam.posx +28 , cam.posy+94, 7)
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
  if abs(xdist) > 250 or abs(ydist) > 250 then
    del(actors, a2)
  end
  if xdist < a1.radius + 4 and ydist < a1.radius + 4 then
    if a1.radius+a2.w > sqrt(xdist * 0x0.0001 * xdist + ydist * 0x0.0001 * ydist) * 0x100 then ---(a2.w*a2.h)
      collide_event(a1, a2)
    end
  end
end

function collide_event(a1, a2)
  if(a1.kind=="player") and (a2.kind!="player") then
    attach(a1,a2)
  end
end

function make_player(x,y,h,w)
  local p = {}
  p.kind = "player"
  p.x=x or 0
  p.y=y or 0
  p.h=h or 7
  p.w=w or 7
  function p.set_size()
    local increment = 4
    p.size = 2 + flr((p.mass - p.base_mass)/4)
  end
  function p.set_accel()
    local accel = mid(2, p.base_accel - (p.mass - p.base_mass)/10, 0.25)
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
  function p.xCen() 
    return p.x + p.w/2
  end 
  function p.yCen() 
    return p.y + p.h/2
  end 
  p.dx = 0
  p.dy = 0
  p.x_speed = 0
  p.y_speed = 0
  p.mass = 22
  p.base_accel = 0.55
  p.base_friction = .45
  p.base_mass = 20
  p.max_speed = 3
  p.stop_under = 0.05
  p.size = 2
  p.accel = 0
  p.friction = 0
  p.radius = 5
  p.xFlipped = false
  p.anim = {
    ["idle"] = {0,0,7,7},
    ["side"] = {8,0,7,7},
    ["up"] = {16,0,7,7},
    ["down"] = {24,0,7,7},
  }
  function p.add_mass(m)
    p.mass += m
    if p.mass <= 9.9 then scene = "gameover" end
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
    if ani%6 == 0 then bubbles_fx(p) end
    if p.dx != 0 or p.dy != 0 then
      local cost = -0.002 * p.mass
      p.add_mass(cost)
    end
  end
  
  function p.draw_actor()
    if p.dx < 0 then p.xFlipped = true end
    if p.dx > 0 then p.xFlipped = false end
    
    psprite = p.anim["idle"]
    if p.dx != 0 then psprite = p.anim["side"] end
    if p.dy > 0 then psprite = p.anim["down"] end
    if p.dy < 0 then psprite = p.anim["up"] end
    ovalfill(p.x-p.size, p.y-p.size, p.x+p.w+p.size+1, p.y+p.h+p.size+1, 2)
    ovalfill(p.x-p.size, p.y-p.size, p.x+p.w+p.size, p.y+p.h+p.size, 8)
    sspr(psprite[1], psprite[2], psprite[3], psprite[4], p.x, p.y, psprite[3], psprite[4], p.xFlipped)
  end

  p.add_mass(0)
  return p
end

--actors list is always a creature
function make_food(k,x,y,h,w)
    local a = {}
    a.kind = k
    a.x=x
    a.y=y
    a.h=h
    a.w=w
    a.xFlipped = 0
    a.frame = 0
    a.atsp = 0
    a.eatreq = 1000
    function a.xCen() 
      return a.x + a.w/2
    end 
    function a.yCen() 
      return a.y + a.h/2
    end 
    function a.draw_actor()
    end
    function a.move_actor()
    end

    return a
  end

function make_plankton(x,y)
  local a = make_food("plankton",x,y,6,6) --make_food(k,x,y,h,w)
  a.eatreq = 1 
  a.updateloop = {}
  a.drawloop = {}

  function a.loop_update()
    local range = 10
    local target = flr(rnd(range))+1
    for i=1,range do
      if i==target then
        add(a.updateloop, 2)
      else
        add(a.updateloop, 1)
      end
    end
  end

  function a.update_actor()
    if #a.updateloop <= 0 then
      a.loop_update()
    end
    if a.updateloop[1] == 1 then
      deli(a.updateloop, 1)
    end
    if a.updateloop[1] == 2 then
      local xoff = rnd(2)-1
      local yoff = rnd(2)-1
      a.x += xoff
      a.y += yoff
      deli(a.updateloop, 1)
    end
  end

  function a.loop_draw()
    for i=1,12 do
      add(a.drawloop, 1)
    end
    for i=1,6 do
      add(a.drawloop, 2)
    end
    for i=1,12 do
      add(a.drawloop, 1)
    end
    for i=1,6 do
      add(a.drawloop, 3)
    end
  end

  function a.draw_actor()
    if #a.drawloop <= 0 then
      a.loop_draw()
    end
    if a.drawloop[1] == 1 then
      sspr(0, 16, 6, 6, a.x, a.y)
      deli(a.drawloop, 1)
    end
    if a.drawloop[1] == 2 then
      sspr(8, 16, 6, 6, a.x, a.y)
      deli(a.drawloop, 1)
    end
    if a.drawloop[1] == 3 then
      sspr(8, 16, 6, 6, a.x, a.y, 6, 6, 1)
      deli(a.drawloop, 1)
    end
  end

  add(actors, a)
  return a
end

function make_krill(x,y)
  local a = make_food("krill",x,y,8,8) --make_food(k,x,y,h,w)
  a.updateloop = {}
  a.drawloop = {}

  function a.loop_update()
    local range = 12
    local target = flr(rnd(range))+1
    for i=1,range do
      if i==target then
        add(a.updateloop, 2)
      else
        add(a.updateloop, 1)
      end
    end
  end
  
  function a.update_actor()
    if #a.updateloop <= 0 then
      a.loop_update()
    end
    if a.updateloop[1] == 1 then
      local yoff = -0.3
      a.y += yoff
      deli(a.updateloop, 1)
    end
    if a.updateloop[1] == 2 then
      local xoff = rnd(2)-1
      local yoff = -0.3
      print(xoff, 340, 300, 0)
      a.x += xoff
      a.y += yoff
      if xoff > 0 then a.xFlipped = true end
      if xoff < 0 then a.xFlipped = false end
      deli(a.updateloop, 1)
    end
  end

  function a.loop_draw()
    for i=1,16 do
      add(a.drawloop, 2)
    end
    for i=1,8 do
      add(a.drawloop, 1)
    end
  end
  
  function a.draw_actor()
    if #a.drawloop <= 0 then
      a.loop_draw()
    end
    if a.drawloop[1] == 1 then
      sspr(16, 16, 8, 8, a.x, a.y, 8, 8, a.xFlipped, false)
      deli(a.drawloop, 1)
    end
    if a.drawloop[1] == 2 then
      sspr(24, 16, 8, 8, a.x, a.y, 8, 8, a.xFlipped, false)
      deli(a.drawloop, 1)
    end
  end

  add(actors, a)
  return a
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
    map( 0, 0, c.posx/1.21, c.posy/1.2, 1024, 512)
  end
  return c
end

function attach(pl, t)
  local tr = 4 --target ratio
  local er = mid(1, sqrt(pl.size)*0.5, 100) --eat range
  t.x=(pl.x*t.atsp + t.x*tr)/(t.atsp+tr)
  t.y=(pl.y*t.atsp + t.y*tr)/(t.atsp+tr)
  if abs(t.x-pl.x) < er and abs(t.y-pl.y) < er then
    eat(pl, t)
  else t.atsp += 0.8
  end
end

function eat(pl, t)
  if t.kind == "plankton" then calorie = 1 end
  if t.kind == "krill" then calorie = 2.5 end
  if t.kind == "fish"  then calorie = 5 end
  pl.add_mass(calorie)
  eat_fx(pl, t)
  del(actors, t)
end

function spawn_food()
  local spawnDir = flr(rnd(4))
  local offset = flr(rnd(32))+70
  local smalloff = flr(rnd(32))-16
  local food_seed = flr(rnd(player.mass*player.mass))
  local x
  local y
  if spawnDir == 0 then x,y =  smalloff, offset end
  if spawnDir == 1 then x,y =  smalloff,-offset end
  if spawnDir == 2 then x,y =  offset, smalloff end
  if spawnDir == 3 then x,y = -offset, smalloff end
  if food_seed <= 250 then
    make_plankton(cam.posx+64+x,cam.posy+64+y)
  end
  if food_seed <= 900 and food_seed > 250 then
    make_krill(cam.posx+64+x,cam.posy+64+y)
  end
  -- if food_seed > 900 then
  --   make_food("food", x+cam.posx+64, y+cam.posy+64, 6, 6, food_sprites["fish"],16)
  -- end
end

function bubbles_fx(pl)
  local sp = 3
  local fx = {dx=sp*pl.dx*-1,dy=sp*pl.dy*-1,dur=20,spr=8,x=pl.xCen(),y=pl.yCen()}
  add (particles, fx);
end

function eat_fx (pl)
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
  if fx.spr == nil then
    if fx.dur != 7 and fx.dur != 6 and fx.dur != 2 then 
      pset(fx.x, fx.y, fx.pal) else return 
    end
  end
  if fx.pal == nil then
    spr(8,fx.x, fx.y)
  end
end

function adv_frame()
  local reset = 127
  if ani < reset then ani += 1 end
  if ani >= reset then ani = 0 end
end