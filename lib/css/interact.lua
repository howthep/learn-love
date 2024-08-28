local Vec=require('vec')
---@class css
local export={}
function export:drag_it(element)
    local is_mouse_down=love.mouse.isDown(1)
    if not is_mouse_down then
        if self.draging == element then
            if element.off_hover then
            element:off_hover()
            element.last_frame_hovered=false
            end
            self.drag_start=nil
            self.draging=nil
        end
        -- element.style.left=0
        return false
    end
    --- click
    local st=self:get_style(element)
    local x,y=love.mouse.getPosition()
    local is_hovered=element.content:is_hover(x-st.left,y-st.top)

    if is_mouse_down and self.draging == nil and is_hovered then
        self.draging=element
        self.drag_before=Vec(st.left,st.top)
    end

    if is_mouse_down and self.draging ==element then
        if self.drag_start == nil then
            self.drag_start = Vec(x, y)
        end
        local s = element.style
        local offset = Vec(x, y) - self.drag_start+self.drag_before
        s.left,s.top=offset:unpack()
        return true
    end
end
function export:interact(element)
    local st=self:get_style(element)
    local x,y=love.mouse.getPosition()
    local is_hovered=element.content:is_hover(x-st.left,y-st.top)
    if st.dragable then
        local stop= self:drag_it(element)
        if stop ==true then
            return stop
        end
    end
    if element.on_hover and  is_hovered then
        local stop_detect = element:on_hover(x,y)
        element.last_frame_hovered=true
        if stop_detect then
            return stop_detect
        end
    end
    local is_just_off_hover = element.last_frame_hovered and not is_hovered
    if element.off_hover and is_just_off_hover then
        element:off_hover(x,y)
        element.last_frame_hovered=false
    end
    for i,c in self:sorted_child(element,true) do
        local stop=self:interact(c)
        if stop==true then
            break
        end
    end

end
return export