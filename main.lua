local rotation=0
function love.draw()
    -- love.graphics.print("hi love",400,300)
    love.graphics.setColor(1,.5,.5)
    for i=1,#Shapes do
        Shapes[i]:draw()
    end
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Img,100,300,rotation)
end
function love.update(dt)
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
    -- local hex=Hex.Hexgon(200,300,40)
    local hex=Hex.HexGrid(200,300)
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