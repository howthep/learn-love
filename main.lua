-- require('lldebugger').start()
package.path=package.path.. './lib/?.lua'
print(_VERSION)
local Vec= require("vec")
local Shape = require("shape")
local Hex=require("hexgon")
local Sprite=require('sprite')
local Trans=require('transform')
local config={}
local T=1
local hexgon
local nvec=Vec(1,-1)
local position=Vec()
local screen_center
local function axis(end_vec)
    local cx,cy=screen_center:unpack()
    local dx,dy=end_vec:unpack()
    love.graphics.line(cx,cy,dx,dy)
end
local function log(...)
   love.graphics.print(...) 
end
function love.draw()
    local font=love.graphics.newFont(30)
    love.graphics.setFont(font)
    love.graphics.setColor(.3,.4,.4)

    hexgon:draw()

    love.graphics.setColor(1,1,0)
    local q,r=hexgon:qr()
    local end_vec =screen_center+r:normal()*200
    axis(end_vec)
    love.graphics.setColor(0,1,0)
    log("R",end_vec.x,end_vec.y)
    end_vec =screen_center+q:normal()*200
    axis(end_vec)
    love.graphics.setColor(.0,0.3,.9)
    log("Q",end_vec.x,end_vec.y)
    -- love.graphics.print(T, 10, 10)

    love.graphics.setColor(1,.5,.5)
    -- mouse end
    axis(position)
    love.graphics.setColor(.5,.5,.5)
    love.graphics.setColor(0,1,1)

    local q_value,r_value = hexgon:vec2cube(position-screen_center)
    log('q:'..q_value,10,40)
    log('r:'..r_value,10,80)
    local step=hexgon.size*math.sqrt(3)
    -- step=1
    -- print(step)
    axis(q*q_value*step+screen_center)
    axis(r*r_value*step+screen_center)

    love.graphics.setColor(1,215/255,0)
    hexgon:hex_draw(q_value,r_value)
end
function love.update(dt)
    T=T+dt
    -- sheep:move(velocity)
end

function love.load()
    love.graphics.setBackgroundColor(.1,.1,.1)
    love.graphics.setLineWidth(4)

    -- Sound = love.audio.newSource('beat.wav','static')

    config.w,config.h,_=love.window.getMode()
    screen_center=Vec(config.w/2,config.h/2)

    hexgon = Hex.HexGrid(screen_center,40)
end
function love.mousereleased(x,y)
    hexgon:touch(x,y)
end
function love.mousemoved(x,y)
    position:set(x,y)
    -- hexgon.center:set(x,y)
end
function love.keypressed(key,scancode,isrepeat)
    if key =='escape'then
        love.event.quit(0)
    elseif key == 'f' then
        local isFull,_=love.window.getFullscreen()
        if not isFull then
            love.window.setFullscreen(true, 'desktop')
        else
            love.window.setMode(config.w,config.h)
        end
    end
end