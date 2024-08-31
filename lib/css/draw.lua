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
    local offset_to_leftup=self:set_transform(element_root,parent)

    local add_info={ text = element_root.text, offset=offset_to_leftup,element=element_root}
    local element_info = table.merge( style, element_root.content, add_info)

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
    local no_z_child=Array()
    local zs={}
    local pz_child=Array()
    local nz_child=Array()
    for i,child in ipairs(element.children or {})do
        local st=self:get_style(child)
        if st.z_index>0 then
            pz_child:push(child)
        elseif st.z_index<0 then
            nz_child:push(child)
        else
            no_z_child:push(child)
        end
        zs[child] = st.z_index
    end
    local sort_f=function (c1,c2)
            return zs[c1] < zs[c2]
    end
    local sorted_c = nz_child:sorted(sort_f) + no_z_child +
        pz_child:sorted(sort_f)
    if reverse then
        sorted_c=sorted_c:reversed()
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