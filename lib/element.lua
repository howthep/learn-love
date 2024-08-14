local prototype=require('prototype')
local style=require('style')
local Vec=require('vec')
local Array=require('array')
local Pen=require('pen')
--- prototype for all ui elements
---@class element:prototype
---@field children table
---@field style style
---@field parent element|nil
---@field anchor Vec2
---@field size Vec2
---@field index number
local element=prototype{
    name = 'element prototype',
    style = style(), children = Array(), parent = nil,
    anchor = Vec(), size = Vec()
}
function element:render(T)
    if not self.style.display then
        return
    end
    self.style:apply(self)
    self:draw()
    self.children:each(function (child)
        child:render()
    end)
end
function element:previous_element()
    if self.parent and self.index~=1 then
        return self.parent.children[self.index-1]
    end
end
function element:is_hover()
    local mx,my=love.mouse.getPosition()
    local x,y=self.anchor:unpack()
    local w,h=self.size:unpack()
    if mx >=x and my>=y and mx<=x+w and my<=y+h then
        return true
    end
    return false
end
function element:push(child)
    self.children:push(child)
    child.parent=self
    child.index=#self.children
    print(child,child.index)
end
function element:draw(...)
    
end
function element:onhover()
    print(self..': unwritten hover function')
end
function element:offhover()
    print(self..' offhover')
end
function element:__tostring()
    return string.format('%s',self.name)
end
function element:__concat(str)
    return tostring(self)..str
end
function element:add_style(style_)
    self.style=style(self.style)
    self.style:update(style_ or {},'_backup')
    self.style:backup()
    return self
end

---@class div:element
---@field font_size number
local div=element{
    name = 'div', 
    font_size = 30,
    style=style{
        display='block'
    }
 }
function div:new(elements)
    self.children=Array()
    for i,child in ipairs(elements) do
        if type(child)=='table' and not child.is then
            self:push(div(child))
        elseif child:is(element) then
            self:push(child)
        end
    end
end
function div:draw()
    local x,y=self.anchor:unpack()
    local w,h=self.size:unpack()
    Pen.rect({
        x = x,
        y = y,
        w = w,
        h = h,
        mode = 'fill',
        color = self.style.bg
    })
end

---@class span:element
---@field text string
local span = element {
    name = 'span',
    text = 'no text',
    style = style {
        display = 'inline',
        font_size = 30,
        align='left',
    },
    width=9999
}

function span:new(config)
    self:update(config,'style')
    self.style=style(self.style)
    self.style:update(config.style or {},'_backup')
    self.style:backup()
end
function span:draw(config)
    local x,y=self.anchor:unpack()
    local w,h=self.size:unpack()
    if self.style.bg then
        Pen.rect{
            x=x,y=y,w=w,h=h,
            mode='fill',color=self.style.bg
        }
    end
    local xy=self.text_anchor or self.anchor
    x,y=xy:unpack()
    Pen.text{
        text=self.text,
        x=x,
        y=y,
        color=self.style.color,
        limit=self.style.width,
        align=self.style.align
    }
end
function span:__tostring()
    return string.format('%s: %s',self.name,self.text)
end
---@class button:element
local button = element {
    name = 'button',
    style = style{
        display='inline'
    },
    children={span{text='button'}}
 }
function button:new(children,style_)
    self.children=children
    self.style=style_
end
function button:render(config)
    local x,y,w,h=config.x,config.y,config.w,config.h
    love.graphics.rectangle('fill',x,y,w,h)
end
return {
    div=div,
    span=span,
    button=button,
}