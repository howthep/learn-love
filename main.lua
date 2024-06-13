function love.draw()
    for i=1,#fruits do
        love.graphics.print(fruits[i],400,300+i*30,0,3)
    end
    love.graphics.print("hi love",400,300)
    love.graphics.rectangle('fill',x,100,100,100)
end
function love.update(dt)
    local v =400
    if not sound:isPlaying() then
        love.audio.play(sound)
    end
    _x,y,w ,h= love.window.getSafeArea()
    if love.keyboard.isDown('right') then
        x = x + v * dt
    else
        x = x - v * dt
    end
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
    fruits  ={'apple','banana'}
    table.insert(fruits,'orange')
    table.insert(fruits,'lemon')
    table.remove(fruits,2)
end