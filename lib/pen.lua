-- draw everything
-- normal coordinate [-1,1]
-- manage drawing, coloring, font
local Color=require('shape').Color
local Vec=require('vec')
local Pen={}
local fonts={}
---comment
---@param config table {mode,x,y,w,h,color}
function Pen.rect(config)
    local env={love=love,_G=_G}
    table.update(env,config)
    setfenv(1,env)
    love.graphics.setColor(color:table())
    love.graphics.rectangle(mode,x,y,w,h)
    _G.setfenv(1,_G)
end
---comment
---@param config table {text,x,y,limit,align,color,size}
function Pen.text(config)
    local env={love=love,_G=_G}
    table.update(env,config)
    setfenv(1,env)
    love.graphics.setFont(Pen.get_font(size))
    love.graphics.setColor(color:table())
    love.graphics.printf(text,x,y,limit,align)
    _G.setfenv(1,_G)
end
function Pen.get_font(size)
    if not fonts[size] then
        fonts[size]=love.graphics.newFont(size)
    end
    return fonts[size]
end
return Pen