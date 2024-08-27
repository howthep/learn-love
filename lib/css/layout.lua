local rectsize=require('data.rectsize')
local pen=require('pen')
local Vec=require('vec')
local Shape=require('shape')
local FP=require('FP')
local Color=Shape.Color
---@class css
local export={}
---set x,y,width,height
---@param element_root any
---@param parent any
function export:layout(element_root,parent)
    -- if not element_root.content then
    --     element_root.content = rectsize(
    --          0,  0,
    --         self:get_width(element_root),
    --         self:get_height(element_root)
    -- )
    -- end
    if element_root.children then
        self:set_children_position(element_root)
        for i, c in ipairs(element_root.children)do
            self:layout(c, element_root)
        end
    end
end
function export:get_height(element,parent)
    local style=self:get_style(element)
    if style.height then
        return self:unit_convert('height',element,parent)
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
function export:get_width(element,parent)
    local style=self:get_style(element)
    if style.width then
        return self:unit_convert('width',element,parent)
    end
    if style.wh_ratio then
        return self:get_height(element,parent)*style.wh_ratio
    end
    if style.display=='inline' and element.text then
        local font = pen.get_font(style.size)
        local width,_=font:getWidth(element.text)
        if style.padding then
            width=width+2*style.padding[2]
        end
        return  width
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
    return style.width or parent.content.width
end
function export:set_child_wh(element,parent)
    element.content=rectsize()
    element.content.width=self:get_width(element,parent)
    element.content.height=self:get_height(element,parent)
end
---set w,h,x,y
---@param element_root any
function export:set_children_position(element_root)
    local parent_display=self:get_style(element_root).display
    if parent_display and parent_display:find('grid')>0 then
        self:grid_layout(element_root)
        return
    end

    for i,child in ipairs(element_root.children or {}) do
        self:set_child_wh(child,element_root)
    end
    local previous
    for i, child in ipairs(element_root.children or {}) do
        local st=self:get_style(child)
        local display=st.display or 'inline'
        local dir = display:find('inline')>0 and Vec(1, 0) or Vec(0, 1)
        if not previous then
            --- the first child follow the parent
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

return export