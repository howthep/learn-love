local Array=require('array')
local rectsize=require('data.rectsize')
local Vec=require('vec')
local grid={}
---comment
---@param self css
---@param element table
---{column,row,flow,gap}
function grid.grid_layout(self,element)
    local st=self:get_style(element)
    local is_two_dimension=st.row and st.column
    if is_two_dimension then
        self:grid_2d(element)
    else
        self:grid_1d(element)
    end
end
---comment
---@param self css
---@param element any
function grid.grid_1d(self,element)
    local st=self:get_style(element)
    local is_row =st.row and true or false
    local frs=st.row or st.column
    local dir=is_row and Vec(0,1) or Vec(1,0)
    local size_key=is_row and 'height' or 'width'
    local another_key=is_row and 'width' or 'height'
    local sum=Array(frs):reduce(FP.add)
    local parent_size=element.content[size_key]
    local previous
    for i,child in ipairs(element.children) do
        local x,y=0,0
        if not previous then
            x,y=element.content.x,element.content.y
        else
            local prevc=previous.content
            local anchor=Vec(prevc.x,prevc.y)+dir*Vec(prevc.width,prevc.height)
            x,y=anchor:unpack()
        end
        local fr=frs[i] or 1
        local child_size=fr/sum*parent_size
        child.content=rectsize( x,y )
        child.content[size_key]=child_size
        child.content[another_key]=element.content[another_key]
        previous=element.children[i]
    end
end
---like this: column=5,row=-1
---@param self css
---@param element any
function grid.grid_2d(self,element)
    local st=self:get_style(element)
end
return grid