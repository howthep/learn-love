local Color = require('color')
local prototype = require('prototype')
local Card = prototype { name = 'card' }
---comment
---@param config table {text,style,spire}
function Card:new(config)
    local text = config.text
    config.text=nil
    local r = math.random()
    local g = math.random()
    local b = math.random()
    self.style = table.merge({
        display = 'inline-grid',
        height = '100%',
        wh_ratio = 4 / 5,
        row = { 1, 1 },
        border_width = 5,
        -- dragable=true,
        border_color = Color(.6, .6, .7),
        post_draw = true,
        top = 20,
    }, config.style or {})
    self.children = {
        {
            text = '###',
            class = 'text_center',
            style = {
                bg = Color(r, g, b)
            }
        },
        {
            text = text,
            class = 'text_center',
            style = {
                bg = Color(.3, .3, .3)
            }
        }
    }
    config.style=nil
    table.update(self,config)
end

function Card:use()
    print('unwritten use function')
end

function Card:on_hover(x, y)
    local st = self.style
    if not self.last_frame_hovered then
        st.border_color = st.border_color + Color(.4, .2, -.2)
    end
    st.z_index = 10
    st.top = 0
    if love.mouse.isDown(1) then
        self.spire.selected_card = self
    end
    -- print(self.content)
end

function Card:off_hover()
    local st = self.style
    st.top = 20
    st.left = 0
    st.border_color = st.border_color - Color(.4, .2, -.2)
    self.style.z_index = 0
    st.rotate = .0
end

return Card
