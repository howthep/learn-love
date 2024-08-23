-- require('lldebugger').start()
print(_VERSION)
local Vec= require("vec")
local Shape = require("shape")
local Color=Shape.Color
local Hex = require("hexgon")
local Array=require('array')
local FP=require('FP')
local scene=require('scene')
-- local Scene=require('scene')
local config = {}
local T=0
local position=Vec()
local font_size=30
local font=love.graphics.newFont('simhei.ttf',font_size)
love.graphics.push()


local css = require('css')(scene.class)
function love.draw()
    -- Scene.root:render(T)

    css:render(scene.ui)
end
function love.update(dt)
    T=T+dt
end

function love.load()
    local w,h,_=love.window.getMode()
    love.mouse.setPosition(w/2,h/2)
    -- pen.size=Vec(200,200)
    -- pen:push(Shape.Line(pen.center,Vec(100,100)))
end
function love.mousereleased(x,y)
end
function love.mousemoved(x,y)
    position:set(x,y)
    -- hexgon.center:set(x,y)
end
function love.mousepressed(x,y,button,istouch,times)
    -- print(button,times)
end
function love.textinput(t)
    -- print(t)
end
function love.keypressed(key,scancode,isrepeat)
    -- print(key)
    if key =='escape'then
        love.event.quit(0)
    end
end