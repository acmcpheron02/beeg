pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
debug = false

function _init() 
    initsteps()
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
  
  if scene == "title" then title_update() end
  if scene == "trans" then trans_update() end
  if scene == "lvl1" then lvl1_update() end
  if scene == "gameover" then gameover_update() end
end

function _draw()
  --define palette changes
  pal(1, 140, 1)
  pal(3, 138, 1)
  pal(4, 143, 1)
  pal(10, 135, 1)
  poke(0x5f2e,1)

  if scene == "title" then title_draw() end
  if scene == "trans" then trans_draw() end
  if scene == "lvl1" then lvl1_draw() end
  if scene == "gameover" then gameover_draw() end
end

function title_update()
  adv_frame()
  pulse = 1
  if ani < 64 then pulse = 1 + ((ani/256)) end
  if ani >= 64 then pulse = 1.25 - ((ani%64)/256) end
  --if ani >= 120 then pulse = 1 end
  if btnp(5) then scene = "trans" end
end

function title_draw()
  cls(4)
  circfill(5, 20, 12, 10)
  rectfill(0,88,128,10028,1)
  sspr(64, 32, 64, 16, ani/2-64, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2, (ani/32)%2 + 80)
  sspr(64, 32, 64, 16, ani/2+64, (ani/32)%2 + 80)
  sspr(0, 32, 64, 32, 32-(32*pulse-32), 20-(16*pulse-16), 64*pulse, 32*pulse)
  print("by cody mcpheron", 32, 62, 8) --16 char
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
  if ti < 500 then
    title_draw()
  end
  if ti >= 500 then
    lvl1_draw()
  end
end

function lvl1_init()
  player = make_player(300, 300, 6, 6)
  cam = make_camera()
  make_krill(270, 300)
  make_plankton(330, 300)
  -- make_food("food", 330, 300, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 300, 330, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 270, 300, 7, 7, food_sprites["plankton"], 16)
  -- make_food("food", 300, 270, 7, 7, food_sprites["plankton"], 16)
end

function lvl1_draw()
  cls(1)
  foreach(particles, draw_particles)

  for i = 1, #actors do
    actors[i].draw_actor() 
  end

  player.draw_actor()

  --UI elements
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
  -- while #actors < 18 do
  --   spawn_food()
  -- end
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
  print("game over!", cam.posx + 48, cam.posy+26, 7)
  print("YOU AREN'T", cam.posx + 48, cam.posy+50, 7)
  print("beeg", cam.posx + 60, cam.posy+60, 8)
  print("ENOUGH TO CONTINUE!", cam.posx +28 , cam.posy+70, 7)
  print("press x to try again!", cam.posx +28 , cam.posy+94, 7)
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
  p.mass = 18.0
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
    ovalfill(p.x-p.size, p.y-p.size, p.x+p.w+p.size, p.y+p.h+p.size, 8)
    sspr(psprite[1], psprite[2], psprite[3], psprite[4], p.x, p.y, psprite[3], psprite[4], p.xFlipped)
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
    function a.xCen() 
      return a.x + a.w/2
    end 
    function a.yCen() 
      return a.y + a.h/2
    end 
    function a.draw_actor()
      -- frame = flr((ani%16)/8)+1
      -- local sprnow = a.sprite[frame]
      -- if sprnow == 37 then sspr(32,16,16,16,a.x,a.y,1,1) end
      -- if sprnow == 38 then sspr(48,16,16,16,a.x,a.y,1,1) end
      -- if sprnow != 37 and sprnow != 38 then spr(sprnow, a.x, a.y, 1, 1, a.xFlipped) end
    end
    function a.move_actor()
      -- if a.aniseed == nil then
      --   a.aniseed = flr(rnd(a.interval))
      -- end
      -- if ani%16 == a.aniseed then
      --   a.x += rnd(4)-2
      --   a.y += rnd(4)-2
    end

    return a
  end

  function make_plankton(x,y)
      --make_food(k,x,y,h,w)
    local a = make_food("plankton",x,y,6,6)
    a.drawloop = {}
    a.updateloop = {}

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

    add(actors, a)
    return a
  end

  function make_krill(x,y)
    --make_food(k,x,y,h,w)
  local a = make_food("krill",x,y,8,8)
  a.drawloop = {}
  a.updateloop = {}

  function a.loop_draw()
    for i=1,16 do
      add(a.drawloop, 2)
    end
    for i=1,8 do
      add(a.drawloop, 1)
    end
  end

  function a.loop_update()
    local range = 4
    local target = flr(rnd(range))+1
    for i=1,range do
      if i==target then
        add(a.updateloop, 2)
      else
        add(a.updateloop, 1)
      end
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

  function a.update_actor()
    if #a.updateloop <= 0 then
      a.loop_update()
    end
    if a.updateloop[1] == 1 then
      deli(a.updateloop, 1)
    end
    if a.updateloop[1] == 2 then
      local xoff = rnd(2)-1
      local yoff = rnd(4)-2.5
      print(xoff, 340, 300, 11)
      a.x += xoff
      a.y += yoff
      if xoff > 0 then a.xFlipped = true end
      if xoff < 0 then a.xFlipped = false end
      deli(a.updateloop, 1)
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
    end
    return c
  end
  
  function attach(pl, t)
    local tr = 4 --target ratio
    local er = mid(1, sqrt(pl.size)*0.5, 100) --eat range
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
    if t.sprite == food_sprites["plankton"] then calorie = 1.1 end
    if t.sprite == food_sprites["krill"] then calorie = 2.5 end
    if t.sprite == food_sprites["fish"] then calorie = 5 end
    pl.add_mass(calorie)
  end
  
  function spawn_food()
    local spawnDir = flr(rnd(4))
    local offset = flr(rnd(128))-64
    local soff = flr(rnd(24))
    local food_seed = flr(rnd(player.mass*player.mass))
    local x
    local y
    if spawnDir == 0 then x,y = 64+soff,offset end
    if spawnDir == 1 then x,y = -64-soff,offset end
    if spawnDir == 2 then x,y = offset,64+soff end
    if spawnDir == 3 then x,y = offset,-64-soff end
    if food_seed <= 250 then
      make_food("food", x+cam.posx+64, y+cam.posy+64, 6, 6, food_sprites["plankton"],16)
    end
    if food_seed <= 900 and food_seed > 250 then
      make_food("food", x+cam.posx+64, y+cam.posy+64, 6, 6, food_sprites["krill"],16)
    end
    if food_seed > 900 then
        make_food("food", x+cam.posx+64, y+cam.posy+64, 6, 6, food_sprites["fish"],16)
    end
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