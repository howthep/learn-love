local Array=require('array')
local grid={}
function grid.grid_layout(self,element)
    local st=self:get_style(element)
    local frs=st.row or st.column
    local children=element.children
    local sum=Array(frs):reduce(FP.add)
    local parent_size=element.content.height
    local previous
    for i,fr in ipairs(frs) do
        local x,y=0,0
        if not previous then
            x,y=element.content.x,element.content.y
        else
            x=previous.content.x
            y=previous.content.y+previous.content.height
        end
        local h=fr/sum*parent_size
        local w=element.content.width
        element.children[i].content={
            x=x,y=y,
            height=h,width=w,
        }
        previous=element.children[i]
    end
end
return grid