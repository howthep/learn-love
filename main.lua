-- require('lldebugger').start()
print(_VERSION)
local Vec= require("vec")
local rotation=0
local p_center = Vec(200,300)
local p_dir = Vec(2,3)*50

function love.draw()
    -- love.graphics.print("hi love",400,300)
    love.graphics.setColor(1,.5,.5)
    for i=1,#Shapes do
        -- Shapes[i]:draw()
    end
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Img,100,300,rotation)
    local p_end = p_center+p_dir
    -- print(p_center,p_end)
    local x,y=p_center:unpack()
    local z,u=p_end:unpack()
    -- print(x,y,z,u)
    local ps={x,y,z,u}
    -- print(#ps)
    love.graphics.line(ps)
end
function love.update(dt)
    -- print(p_dir)
    p_dir=p_dir:rotate(dt*2)
    -- print(p_dir)
    rotation=rotation+dt*2
    for i=1,#Shapes do
        Shapes[i]:move(dt)
    end
end

function love.load()
    love.graphics.setBackgroundColor(.1,.1,.1)
    love.graphics.setLineWidth(4)

    local Shape = require("shape")
    local Hex=require("hexgon")
    local Rec = Shape.Rect(100,100,100,100,300)
    local Cir = Shape.Circle(100,200,100,200)
    local hex=Hex.Hexgon(200,300,40)
    -- local hex=Hex.HexGrid(200,300)
    Shapes={Rec,Cir,hex}

    -- Sound = love.audio.newSource('beat.wav','static')
    Img = love.graphics.newImage('sheep.png')


end
function love.mousemoved(x,y)
    Shapes[3].x=x
    Shapes[3].y=y
end
function love.keypressed(key,scancode,isrepeat)
    if key =='escape'then
        love.event.quit(0)
    end
end