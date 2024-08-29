local ui=require('element')
local Vec=require('vec')
local Color=require('shape').Color
local TODO='battle map; sprite attack HP move '
local Hex=require('hexgon').HexGrid
local me=love.graphics.newImage('assets/me.png')
local he=love.graphics.newImage('assets/he.png')
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
        bg=Color(0,.5,.6),
    },
    children={
        ui.span{
            text='R',
            class='p_20'
        },
        ui.span{
            text='TODO: '..TODO,
            class='p_20'
        },
    }
}
local hex_r=50
local hexgrid=Hex(Vec(),hex_r,0)
local battle={
    style={
        z_index=-1
    },
    draw = function(config)
        print(love.timer.getFPS())
        love.graphics.setColor(1, 0, .5)
        local rs=300
        love.graphics.stencil(function ()
            local t=love.timer.getTime()
            -- love.graphics.rectangle('fill',-rs,-rs,rs,rs)
            love.graphics.circle('fill',0,0,rs+100*math.sin(t))
        end)
        love.graphics.setStencilTest('greater',0)
        hexgrid:draw()
        love.graphics.setColor(1, 1, 1)
        local w,h= me:getWidth(),me:getHeight()
        local scale=2*hex_r/w
        -- scale=1
        local x,y=hexgrid:cube2vec(-1,1):unpack()
        love.graphics.draw(me,x,y,0,scale,scale,w/2,h/2)
        x,y=hexgrid:cube2vec(1,2):unpack()
        love.graphics.draw(he,x,y,0,scale,scale,w/2,h/2)
        love.graphics.setStencilTest()
        love.graphics.setStencilTest()
    end,
    children={
    }
}
local function card(text,style)
    local r=math.random()
    local g=math.random()
    local b=math.random()
    local c={
        style=table.merge({
            display='inline-grid',
            height='100%',
            wh_ratio=4/5,
            row={1,1},
            border_width=5,
            dragable=true,
            border_color=Color(.6,.6,.7),
            post_draw=true,
            top=20,
        },style),
        on_hover=function (self,x,y)
            local st =self.style
            if not self.last_frame_hovered then
                st.border_color = st.border_color + Color(.4,.2,-.2)
            end
            st.z_index=10
            st.top=0
        end,
        off_hover=function (self)
            local st =self.style
            st.top=20
            st.left=0
            st.border_color=st.border_color-Color(.4,.2,-.2)
            self.style.z_index=0
            st.rotate=.0
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
        },
        children={
            card('strike', {}),
            card('draw', {}),
            card('defend', {}),
            card('curse', {}),
            card('power', {}),
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
