-- require('lldebugger').start()
local function addpath(folder)
    package.path = package.path .. ';./'..folder..'/?.lua'
end
addpath('lib')
print(_VERSION)
local __verson=require('version')
local Vec= require("vec")
local Shape = require("shape")
local Hex = require("hexgon")
local Container=require('container')
local Pen = require('pen')
local Sprite=require('sprite')
local Array=require('array')
local config = {}
local T=1
local position=Vec()
local pen = Pen()
function love.draw()
    pen:draw()
end
function love.update(dt)
    T=T+dt
    local hex_grid=pen.child['hex_grid']
    local q,r=hex_grid:vec2cube(position-pen.center)
    local player=pen.child['player']
    player.center:set(hex_grid:cube2vec(q,r))
    local hx=Hex.Hexgon(player.center,hex_grid.size,30)
    hx.color=Shape.Color(.5,.5,.99)
    pen:push(hx)
    -- print(q,r)
    -- player.center:set(+hex.center)
    -- print(hex.center)
end

function love.load()
    -- pen.size=Vec(200,200)
    -- pen:push(Shape.Line(pen.center,Vec(100,100)))
    local arr=Array{1,2,3}
    print(arr)
    local cards=Container()
    local hex = Hex.HexGrid(pen.center,40)
    hex.color=Shape.Color(1,.5,.5)
    pen:push(hex,'hex_grid')
    local player=Sprite(hex:cube2vec(1,1))
    pen:push(player,'player')
    print(pen)
end
function love.mousereleased(x,y)
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