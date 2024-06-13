function love.draw()
    love.graphics.print("hi love",400,300)
    love.graphics.rectangle('fill',x,100,100,100)
end
function love.update(dt)
    if not sound:isPlaying() then
        love.audio.play(sound)
    end
    _x,y,w ,h= love.window.getSafeArea()
    print(w,h)
    x=x+2
    x=x%w
end
function love.keypressed(key,scancode,isrepeat)
    if key =='escape'then
        love.event.quit(0)
    end
end

function love.load()
    sound = love.audio.newSource('beat.wav','static')
    x=100
end