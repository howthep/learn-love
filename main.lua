local rectsize = require "data.rectsize"
-- require('lldebugger').start()
print(_VERSION)
local Vec= require("vec")
local Shape = require("shape")
local Color=Shape.Color
local Array=require('array')
local FP=require('FP')
local Spire=require('spire')
local timer=require('timer')

local T=0
local font_size=30
-- local font=love.graphics.newFont('simhei.ttf',font_size)


local css = require('css')(require('style_class'))
local spire=Spire()

function love.draw()
    css:render(spire)
end
--- see https://www.love2d.org/wiki/love.run
--- after update, call origin,clear,draw
function love.update(dt)
    timer.update(dt)
end

function love.load()
    print('load')
    -- timer.oneshot(function (t)
    --     print(t,'oneshot')
    -- end,1000)
    -- local w,h,_=love.window.getMode()
    -- love.mouse.setPosition(w/2,h/2)
    -- pen.size=Vec(200,200)
    -- pen:push(Shape.Line(pen.center,Vec(100,100)))
end
function love.resize(w,h)
    spire.content=rectsize(0,0,w,h)
end
function love.mousereleased(x,y)
end
function love.mousemoved(x,y)
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