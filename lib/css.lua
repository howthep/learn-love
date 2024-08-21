local Array=require('array')
local Vec=require('vec')
local Shape=require('shape')
local Color=Shape.Color
local prototype=require('prototype')
local pen=require('pen')
---@class css
---@field style_table table
local css=prototype{name='css'}
local style_table_default = {
    default = {
        align = 'left',
        color = Color(1, 1, 1),
        limit = 999999,
        size=30,
    },
    span = {
        size = 30,
        display='inline',
    },
    div={
        display='block'
    },
    red = {
        color = Color(1, 0, 0),
    },
    blue={
        color = Color(0, 0, 1),
    },
}

---init by style_table
---@param t table
function css:new(t)
    self.style_table=table.merge(style_table_default,t)
end
---comment
function css:render(element_root)
    self:layout(element_root)
    self:draw(element_root)
end
function css:draw(element_root)
    local st=self.style_table
    local style=self:get_style(element_root)
    pen.draw_element(table.merge(
        style, element_root.content,
        { text = element_root.text })
    )
   
    if element_root.children then
        for i,child in ipairs(element_root.children or {}) do
            self:draw(child)
        end
    end
end
function css:get_height(element,parent)
    local style=self:get_style(element)
    if style.height then
        return style.height
    end
    if element.children then
        local h=0
        for i,c in ipairs(element.children) do
            local st=self:get_style(c)
            if st.display=='inline' then
                h=math.max(h,c.content.height)
            elseif st.display=='block' then
                h=h+c.content.height
            end
        end
        return h
    elseif element.text then
            local font = pen.get_font(style.size)
            local wraped_width, wraped_text = font:getWrap(element.text, element.content.width)
            local h = font:getHeight()
            return h * #wraped_text
    end
    return 0
end
function css:get_width(element,parent)
    local style=self:get_style(element)
    if style.width then
        return style.width
    end
    if element.children then
        local w=0
        for i,c in ipairs(element.children) do
            local st =self:get_style(c)
            if st.display=='inline' and c.content then
                w=w+c.content.width
            end
        end
        return w
    end
    if style.display=='inline' and element.text then
        local font = pen.get_font(style.size)
        local width,_=font:getWidth(element.text)
        return  width
    end
    return style.width or parent.content.width
end
function css:set_children_position(element_root,parent)
    local st=self:get_style(element_root)
    local dir=st.display=='block' and Vec(0,1) or Vec(1,0)
    local previous
    for i, child in ipairs(element_root.children) do
        if not previous then
            previous=element_root
            child.content.x = previous.content.x
            child.content.y = previous.content.y
        else
            local prec=previous.content
            local size=Vec(prec.width,prec.height)
            local anchor=Vec(prec.x,prec.y)+dir*size
            local x,y=anchor:unpack()
            child.content.x = x
            child.content.y = y
        end
        previous = child
    end
end
---set x,y,width,height
---@param element_root any
---@param parent any
function css:layout(element_root,parent)
    -- local style=self:get_style(element_root)
    local layout_table = {
        x = 0,
        y = 0,
    }
    element_root.content=layout_table
    --- mainly for text element
    layout_table.width=self:get_width(element_root,parent)
    if element_root.children then
        for i,child in ipairs(element_root.children or {}) do
            self:layout(child,element_root)
        end
        self:set_children_position(element_root)
    end
    layout_table.height = self:get_height(element_root,parent)
    layout_table.width=self:get_width(element_root,parent)
end
---from a class_table to a style_table
---@param class_table table
---@return table
function css:get_class_style(class_table)
    local st=self.style_table
    local style = Array(class_table):reduce(function (accu_style,class_name)
        local s=st[class_name]

        if s.compose then
            local composed=self:get_class_style(s.compose)
            s.compose=nil
            s=table.merge(composed,s)
            st[class_name]=s
        end

        return table.merge(accu_style,s)
    end,{})
    return style
end
function css:get_style(element)
    local class_style = self:get_class_style(element.class)
    local style = table.merge(self.style_table.default,
        class_style, element.style or {})
    return style
end
local function get_vwh()
    local vw,vh,_=love.window.getMode()
    return vw,vh
end
function css:unit_convert(keys)
    if type(keys)~='table' then
        keys={keys}
    end
    local t={}
    for i,key in ipairs(keys) do
        local x = self[key]
        if type(x) == 'string' then
            local vw, vh = get_vwh()
            local map = { vw = vw, vh = vh }
            local num, unit = string.match(x, '([%d%.]+)(%a+)')
            x = map[unit] * num / 100
        end
        table.insert(t, x)
    end
    return unpack(t)
end
return css