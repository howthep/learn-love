local Array=require('array')
---@class css
local export={}
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
    return t+z_child:sorted(function (c1,c2)
        return zs[c1]<zs[c2]
    end)
end
return export