---@class css
local export={}
function export:interact(element)
    local x,y=love.mouse.getPosition()
    local is_hovered=element.content:is_hover(x,y)
    if element.on_hover and  is_hovered then
        element:on_hover(x,y)
        element.last_frame_hovered=true
    end
    local is_just_off_hover = element.last_frame_hovered and not is_hovered
    if element.off_hover and is_just_off_hover then
        element:off_hover(x,y)
        element.last_frame_hovered=false
    end
    for i,c in ipairs(element.children or {}) do
        self:interact(c)
    end

end
return export