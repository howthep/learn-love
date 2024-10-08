local Color = require('color')
local ui=require('element')
local prototype = require('prototype')
local Card = prototype { name = 'card' }
---comment
---@param config table {text,style,spire}
function Card:new(config)
    local text = config.description
    -- config.text=nil
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
    config.style=nil
    config.img='assets/card/'..config.img
    self.children = {
        {
            -- text = '###',
            class = 'text_center',
            style = {
                img=config.img,
                color=Color(1,1,1)
                -- bg = Color(r, g, b)
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
    table.update(self,config)
end

function Card:use()
    print('unwritten use function')
end
function Card:__tostring()
    return self.description
end

function Card:on_hover(x, y)
    local st = self.style
    if not self.last_frame_hovered then
        st.border_color = st.border_color + Color(.4, .2, -.2)
    end
    st.z_index = 10
    st.top = 0
    if love.mouse.isDown(1) and not self.spire.selected_card then
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

local Card_Manager= prototype{name='card_manager'}
function Card_Manager:new()
end
function Card_Manager:draw()
end

local function cm(Spire)
    
local bottom_cards= {
    name='bottom_cards',
    -- class = 'rosef',
    style = {
        color = Color(.9, .8, .9),
        -- bg = Color(.3, .4, .3),
        border_color = Color(.3, .7, .8),
        align = 'center',
        display='grid',
        column={1,6,1},
    },
    children = { ui.span {
        text = 'to_draw',
        class={'text_center'},
        style = {
            bg = Color(0, 0.5, 1),
            padding = { 0, 10 },
        },
        }, {
            style = {
                z_index = 10,
                size = 40,
                -- bg = Color(1, 0, .5),
            },
            children = {
                Card { description = 'strike 3',damage=3,
                    spire = Spire, range = 1, target = 'enemy',
                    img='strike.png',
                    use = function(self,config)
                        config.target:hurt(self.damage)
                    end
                },
                Card { description = 'move 2',
                spire = Spire, range = 2, target = 'space',
                img='move.png',
                    use = function(self, config)
                        config.player.center = config.xy
                    end
                },
            }
    }, ui.span {
        text = 'discarded',
        class={'p_20','text_center'},
        style = {
            color = Color(0, 0, 0),
            size = 30,
            bg = Color(.5, 1, .5)
        }
    },
    }
}
return bottom_cards
end
return cm
