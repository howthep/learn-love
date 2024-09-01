---@diagnostic disable: param-type-mismatch, undefined-global
-- draw everything
-- normal coordinate [-1,1]
-- manage drawing, coloring, font
local Color=require('color')
local Vec=require('vec')
local Pen={}
local fonts={}
function Pen.bezier(bezier)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.line(bezier:render())
end
function Pen.draw_element(config)
    if not config then
        return
    end

    if config.element.draw then
        config.element:draw(config)
        return
    end

    if config.border_radius then
        Pen.round_rect(config)
    else
        Pen.rect(config)
    end
    if config.text then
        Pen.text(config)
    end
end
---comment
---@param config table {border,border_radius,x,y,width,height}
function Pen.round_rect(config)
    local deg90=math.pi/2
    local env={love=love,_G=_G,math=math}
    table.update(env,config)
    setfenv(1,env)
    local border_radius=math.min(border_radius,height/2,width/2)
    love.graphics.setColor(color:table())
    --[[
            270
            |
            |
    180 ----------> 0
            |     x
            | y
            v 
            90
    --]]
    if bg then
        local mode='fill'
        local arc_type='pie'
        love.graphics.setColor(bg:table())
        local tx,ty=x+border_radius,y+border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,2*deg90,3*deg90)
        tx=x+width-border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,3*deg90,4*deg90)
        tx,ty=x+width-border_radius,y+height-border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,0*deg90,1*deg90)
        tx=x+border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,1*deg90,2*deg90)
        love.graphics.rectangle(mode,x+border_radius,y,width-2*border_radius,height)
        love.graphics.rectangle(mode,x,y+border_radius,width,height-2*border_radius)
    end
    if border_width then
        local mode='line'
        local arc_type='open'
        local segment=border
        love.graphics.setColor(border_color:table())
        local lw=love.graphics.getLineWidth()
        love.graphics.setLineWidth(border_width)
        local tx,ty=x+border_radius,y+border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,2*deg90,3*deg90,segment)
        love.graphics.line(x+border_radius,y,x+width-border_radius,y)
        tx=x+width-border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,3*deg90,4*deg90,segment)
        love.graphics.line(x+width,y+border_radius,x+width,y+height-border_radius)
        tx,ty=x+width-border_radius,y+height-border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,0*deg90,1*deg90,segment)
        love.graphics.line(x+width-border_radius,y+height,x+border_radius,y+height)
        tx=x+border_radius
        love.graphics.arc(mode,arc_type,tx,ty,border_radius,1*deg90,2*deg90,segment)
        love.graphics.line(x,y+height-border_radius,x,y+border_radius)
        love.graphics.setLineWidth(lw)
    end
    _G.setfenv(1,_G)
end
---comment
---@param config table {mode,x,y,w,h,color}
function Pen.rect(config)
    local env={love=love,_G=_G}
    table.update(env,config)
    setfenv(1,env)
    local x,y=offset:unpack()
    if border_width then
        local lw=love.graphics.getLineWidth()
        love.graphics.setLineWidth(border_width)
        love.graphics.setColor(border_color:table())
        love.graphics.rectangle('line',x,y,width,height)
        love.graphics.setLineWidth(lw)
    end
    if bg then
        love.graphics.setColor(bg:table())
        love.graphics.rectangle('fill',x,y,width,height)
    end
    _G.setfenv(1,_G)
end
---comment
---@param config table {text,x,y,width,align,color,size}
function Pen.text(config)
    local env = { love = love, _G = _G}
    table.update(env,config)
    setfenv(1,env)
    local font=Pen.get_font(size)
    local limit=width or font:getWidth(text)
    local x,y=offset:unpack()
    if padding then
        x=x+padding[2]
        y=y+padding[1]
        limit=limit-padding[2]*2
    end
    love.graphics.setFont(font)
    love.graphics.setColor(color:table())
    ---text,x,y,limit,align, rotate,scale_x,scale_y,offset_x,offset_y, shearing
    love.graphics.printf(text,x,y,limit,align,0,1,1,0,0)
    _G.setfenv(1,_G)
end
function Pen.get_font(size)
    if not fonts[size] then
        fonts[size]=love.graphics.newFont(size)
    end
    return fonts[size]
end
return Pen