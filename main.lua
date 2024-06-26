-- require('lldebugger').start()
package.path=package.path.. './lib/?.lua'
print(_VERSION)
local Vec= require("vec")
local Shape = require("shape")
local Hex=require("hexgon")
local Sprite=require('sprite')
local config={}
local sheep
local velocity=Vec()
local Img
local frames={}
local T=1
local player

function love.draw()
    love.graphics.print(T, 10, 10)
    love.graphics.print(package.path, 10, config.h-20)
    if T > 1 then
        local row, col = 5, 5
        for i = 0, row do
            for j = 0, col do
                local v = math.random()
                local mode = 'line'
                love.graphics.rectangle(mode, j * 100, i*100, 100, 100)
                if v > .5 then
                    mode = 'fill'
                    love.graphics.rectangle(mode, j * 100, i*100, 100, 100)
                end
            end
        end
    end
end
function love.draw_()
    -- love.graphics.print("hi love",400,300)
    love.graphics.setColor(1,1,1)
    sheep:draw()
    local dt=1/12*3
    local frame_id = math.floor(T/dt)%#player.frames+1
    player:draw(frame_id)
end
function love.update(dt)
    T=T+dt
    local mx,my=love.mouse.getPosition()
    local direction = Vec(mx,my)-sheep.center
    local speed = 7
    local attract_force = direction:normal() * dt * speed
    velocity = velocity + attract_force
    local rotation=-math.pi/2+velocity:theta()
    sheep.rotation=rotation
    -- sheep:move(velocity)
end

function love.load()
    love.graphics.setBackgroundColor(.1,.1,.1)
    love.graphics.setLineWidth(4)

    -- Sound = love.audio.newSource('beat.wav','static')

    config.w,config.h,_=love.window.getMode()
    local img_center=Vec(config.w/2,config.h/2)
    sheep=Sprite(img_center,'sheep.png')
    player=Sprite(Vec(300,100),'jump.png',{quad={117,233,5}})

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