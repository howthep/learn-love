local ui=require('element')
local Color=require('shape').Color
local TODO='dragable'
local Class={
    text_center={
        align='center'
    },
    viewport={
        width='100vw',
        height='100vh',
    },
    full_width={
        width='100vw',
        display='block',
    },
    p_20={
        padding={0,20}
    },
    rosef = {
    compose={'blue'},
    size=30,
    -- border_radius=20,
    -- width=200,
    -- height=200,
    border_width=10,
    },
}
local status={
    style={
        bg=Color(.1,.2,.2)
    },
    children={
        ui.span{
            text='status',
            class='p_20'
        }
    }
}
local relices={
    style={
    },
    children={
        ui.span{
            text='R',
            class='p_20'
        },
        ui.span{
            text='E',
            class='p_20'
        },
    }
}
local battle={
    style={
        bg=Color(0,.5,.6),
    },
    children={
        ui.span{
            text='TODO: '..TODO,
            class='p_20'
        },
    }
}
local function card(text,style)
    local r=math.random()
    local g=math.random()
    local b=math.random()
    local c={
        style=table.merge({
            display='inline-grid',
            -- width=100,
            height='100%',
            wh_ratio=4/5,
            row={1,1},
            border_width=5,
            -- border_radius=10,
            border_color=Color(.8,.8,.9),
            post_draw=true,
            -- bg=Color(.6,.2,.2)
        },style),
        cache={},
        on_hover=function (self,x,y)
            local st =self.style
            if not self.last_frame_hovered then
            self.cache['border_color']=st.border_color
            end
            st.border_color=Color(.9,.7,.3)
            st.z_index=10
            st.rotate=.2
            
            print(text,'hovered')
        end,
        off_hover=function (self)
            local st =self.style
            self.style.border_color= self.cache['border_color']
            self.style.z_index=0
            st.rotate=.0
            print('off hover')
        end,
        children={
            {
                 text = '###',
                 class='text_center',
                 style={
                    bg=Color(r,g,b)
                 }
            },
            {
                text = text,
                class='text_center',
                style={
                    bg=Color(.3,.3,.3)
                }
            }
        }
    }
    return c
end
local bottom_cards= {
    name='bottom_cards',
    class = 'rosef',
    style = {
        color = Color(.9, .8, .9),
        bg = Color(.3, .4, .3),
        border_color = Color(.3, .7, .8),
        align = 'center',
        display='grid',
        column={1,6,1}
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
            z_index=10,
            size = 40,
            bg = Color(1, 0, .5),
            -- display='grid',
            -- column={1,1,1,1,1}
        },
        -- on_hover=function (self,x,y)
        --     print(x,y,'hovered')
        -- end,
        -- off_hover=function (self)
        --     print('off hover')
        -- end,
        children={
            card('strike', {
            }),
            card('draw',{
            }),
            card('defend',{ }),
            card('curse',{ }),
            card('power',{ }),
        }
    }, ui.span {
        text = 'discarded',
        class={'p_20','text_center'},
        style = {
            color = Color(0, 0, 0),
            size = 30,
            bg = Color(.5, 1, .5)
        }
    }
    }
}
local Scene = {
    class = 'viewport',
    style={
        display='grid',
        row={1,1,9,3}
    },
    children={
        status,
        relices,
        battle,
        bottom_cards,
    }
}
return {
    ui=Scene,
    class=Class,
}
