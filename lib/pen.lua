-- draw everything
-- normal coordinate [-1,1]
-- manage drawing, coloring, font
local Color=require('shape').Color
local Vec=require('vec')
local Pen={}
function Pen.rect(config)
    local env={love=love,_G=_G}
    table.update(env,config)
    setfenv(1,env)
    love.graphics.setColor(color:table())
    love.graphics.rectangle(mode,x,y,w,h)
    _G.setfenv(1,_G)
end
function Pen.text(config)
    local env={love=love,_G=_G}
    table.update(env,config)
    setfenv(1,env)
    love.graphics.setColor(color:table())
    love.graphics.printf(text,x,y,limit,align)
    _G.setfenv(1,_G)
end
return Pen