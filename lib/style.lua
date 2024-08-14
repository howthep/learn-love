local prototype=require('prototype')
local Vec=require('vec')
local Color=require('shape').Color
local function get_vwh()
    local vw,vh,_=love.window.getMode()
    return vw,vh
end


---@class style:prototype
---@field fonts table all fonts with different size
---@field bg Color
---@field color Color
---@field display boolean|string 'block','inline','grid'
---@field grid table
---@field font_size number
---@field width number
---@field height number
---@field position string 
---@field bottom number|string 
---absolute number 100
---relative to view size '30vh','50vw'
---@field top number|string
---@field left number|string
---@field right number|string
---@field column table  for grid {1,2,3}
---@field row table     for grid {1,3,1}
---@field gap number|string for grid
local style = prototype {
    name = 'style',
    width = 9999,
    font_size = 30,
    display = 'block',
    margin=2,
    color=Color(0.4,0.4,0.4,1),
    position='static',
    fonts={},
    bg=Color(0,0,0,0),
    gap=0,
 }
 style.hover=style()
function style:new(config)
    self:update(config or {},{'super',"_backup"})
    self:backup()
end
function style:apply(element)
    self:restore()
    local fn=self[element.name] or function (...)
        print(element.name .. ' unknown')
    end
    fn(self,element) -- get anchor and size of element
    if element:is_hover() then
        element.last_frame_hovered=true
    -- if true then
        self:update(self.hover:table() )
        element:onhover()
    else
        if element.last_frame_hovered then
            element.last_frame_hovered=false
            element:offhover()
        end
    end
end
function style:div(element)
    element.anchor=self:get_anchor(element)
    local w,h=self:unit_convert({'width','height'})
    element.size=Vec(w,h)
    if self.display=='grid' then
        self:gird_layout(element)
    end
end
function style:gird_layout(element)
    local w,h=element.size:unpack()
    local len = #element.children
    local frs=self.column or self.row
    local direction=self.column and Vec(1,0) or Vec(0,1)
    local dir_key=self.column and 'width' or 'height'
    local gap = self.gap
    local total=self.column and w or h
    total =total  - (len - 1) * gap

    local fr_sum = 0
    for i = 1, len do
        fr_sum = fr_sum + (frs[i] or 1)
    end

    local prev = nil
    element.children:each(function(child, index)
        local fr = frs[index] or 1
        child.style[dir_key] = total * fr / fr_sum
        if prev then
            local offset = prev.style[dir_key] + gap
            child.anchor = prev.anchor + direction *offset
        else
            --- the first one
            child.anchor = element.anchor:clone()
        end
        prev = child
    end)
end

function style:span(element)
    local font = self:get_font()
    love.graphics.setFont(font)

    local wrap_width, wrap_text = font:getWrap(element.text, self.width)
    local line_h = font:getHeight()
    local w=math.max(wrap_width,rawget(self,'width') or 0)
    local h=self.height or line_h * #wrap_text
    local text_size=Vec(wrap_width,line_h*#wrap_text)
    element.size = Vec(w, h)
    element.anchor = self:get_anchor(element)
    if self.vlign=='center' then
        element.text_anchor=element.anchor+Vec(0,(h-text_size.y)/2)
    elseif self.vlign=='bottom' then
        element.text_anchor=element.anchor+Vec(0,h-text_size.y)
    end
end
---@param element element
---@return Vec2
function style:get_anchor(element)
    if element.parent and element.parent.style.display=='grid' then
        return element.anchor
    end
    if self.position=='absolute' then
        return self:absolute(element)
    end

    local before = element:previous_element()
    local anchor=Vec()
    local offset=Vec()
    if before then
        anchor=before.anchor
        if element.style.display=='block' or before.style.display=='block' then
            offset.y=before.size.y
            offset.x=-anchor.x
        else
            offset.x=before.size.x
        end
    elseif element.parent then
        anchor=element.parent.anchor
    end
    return anchor+offset
end
function style:absolute(element)
        local vw,vh=get_vwh()
        local w,h=element.size:unpack()
        local x=self.left or vw-self.right-w
        local y=self.top or vh-self.bottom-h
        return Vec(x,y)
end
---get font
function style:get_font()
    local font_size=tostring(self.font_size)
    if not self.fonts[font_size] then
        self.fonts[font_size]=love.graphics.newFont(self.font_size)
    end
    return self.fonts[font_size]
end
function style:restore()
    for k,v in pairs(self._backup) do
        -- print(k,v)
        self[k]=v
    end
end
function style:backup()
    self._backup=self:table()
end
function style:table()
    local t={}
    for k,v in pairs(self) do
        t[k] = v
    end
    for i,k in ipairs{'super','_backup'} do
        t[k]=nil
    end
    return t
end
---convert unit to number
---@param keys table|number|string
---@return table
function style:unit_convert(keys)
    if type(keys)~='table' then
        keys={keys}
    end
    local t={}
    for i,key in ipairs(keys) do
    local x=self[key]
    if type(x)=='string' then
        local vw,vh=get_vwh()
        local map={vw=vw,vh=vh}
        local num,unit=string.match(x,'([%d%.]+)(%a+)')
        x=map[unit]*num/100
    end
    table.insert(t,x)
    end
    return unpack(t)
end
return style