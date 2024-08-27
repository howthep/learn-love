local Array=require('array')
local pen=require('pen')
---@class css
local export={}
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
function export:sorted_child(element)
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
        return zs[c1]<zs[c2]
    end)
    local i=0
    return function ()
        i=i+1
        local c=sorted_c[i]
        if c then
            return i,c
        end
    end
end
return export