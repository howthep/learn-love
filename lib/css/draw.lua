local Array=require('array')
local Vec=require('vec')
local pen=require('pen')
local Shape=require('shape')
local Color=Shape.Color
local rectsize=require('data.rectsize')
---@class css
local export={}
---set transform  
---sorted_child  
---then draw  
---@param element_root any
---@param parent any
function export:draw(element_root,parent)
    local style=self:get_style(element_root)
    love.graphics.push()
    local offset=self:set_transform(element_root,parent)

    local add_info={ text = element_root.text, offset=offset}
    local element_info = table.merge( style, element_root.content, add_info)

    self:sorted_child(element_root)
    pen.draw_element(style.post_draw and nil or element_info)

    for i,child in self:sorted_child(element_root) do
        self:draw(child,element_root)
    end

    pen.draw_element(style.post_draw and element_info or nil)

    love.graphics.pop()
end
local function local_table()
    local index=1
    local t={}
    while true do
        local name,value=debug.getlocal(2,index)
        if not name then
            break
        else
            t[name]=value
        end
        index=index+1
    end
    return t
end
---return a child iterator sorted by z_index
---use like this  
---```
---for i,child in self:sorted_child(element)
---```
---@param element any
---@return function
function export:sorted_child(element,reverse)
    local t=Array()
    local zs={}
    local z_child=Array()
    for i,child in ipairs(element.children or {})do
        local st=self:get_style(child)
        if st.z_index then
            z_child:push(child)
            zs[child]=st.z_index
        else
            t:push(child)
        end
    end
    local sorted_c= t+z_child:sorted(function (c1,c2)
            return zs[c1] < zs[c2]
    end)
    if reverse then
        local len=#sorted_c
        sorted_c=sorted_c:map(function (value,index,arr)
            return arr[len-index+1]
        end)
    end
    local i=0
    return function ()
        i=i+1
        local c=sorted_c[i]
        if c then
            return i,c
        end
    end
end
---move to origin, set rotation  
---return offset to left_up 
---@param element_root any
---@param parent any
---@return Vec2
function export:set_transform(element_root,parent)
    local style=self:get_style(element_root)
    parent = parent or {content=rectsize()}
    local ex,ey
    if style.origin then
        ex,ey=element_root.content:get(unpack(style.origin))
    else
        ex,ey=element_root.content:center()
    end
    element_root.content:set_origin(ex, ey)
    local px,py=parent.content:origin()
    local x=ex-px
    local y=ey-py
    love.graphics.translate(x+style.left,y+style.top)
    love.graphics.rotate(style.rotate or 0)
    return Vec(element_root.content:left_up())-Vec(ex,ey)
    
end
return export