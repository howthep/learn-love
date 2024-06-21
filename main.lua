-- require('lldebugger').start()
print(_VERSION)
local Vec= require("vec")
local Shape = require("shape")
local Hex=require("hexgon")
local Sprite=require('sprite')
local config={}
local Shapes={}
local sheep
local velocity=Vec()

function love.draw()
    -- love.graphics.print("hi love",400,300)
    love.graphics.setColor(1,.5,.5)
    for k,v in pairs(Shapes) do
        v:draw()
    end
    love.graphics.setColor(1,1,1)
    sheep:draw()
end
function love.update(dt)
    local mx,my=love.mouse.getPosition()
    local direction = Vec(mx,my)-sheep.center
    local speed = 7
    local attract_force = direction:normal() * dt * speed
    velocity = velocity + attract_force
    local rotation=-math.pi/2+velocity:theta()
    sheep.rotation=rotation
    sheep:move(velocity)
    for i=1,#Shapes do
        Shapes[i]:move(dt)
    end
end

function love.load()
    love.graphics.setBackgroundColor(.1,.1,.1)
    love.graphics.setLineWidth(4)

    local Rec = Shape.Rect(100,100,100,100,300)
    local Cir = Shape.Circle(100,200,100,200)
    -- local hex=Hex.Hexgon(200,300,40)
    local p_center = Vec(200,200)
    local hex=Hex.HexGrid(p_center,300)
    -- Shapes={Rec,Cir,hex=hex}

    -- Sound = love.audio.newSource('beat.wav','static')

    config.w,config.h,_=love.window.getMode()
    local img_center=Vec(config.w/2,config.h/2)
    sheep=Sprite(img_center)
end
function love.mousemoved(x,y)
    -- Shapes.hex.center:set(x,y)
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