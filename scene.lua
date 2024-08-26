local ui=require('element')
local Color=require('shape').Color
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
            text='TODO: translate origin',
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
            display='grid',
            row={1,1},
            border_width=5,
            -- border_radius=10,
            border_color=Color(.8,.8,.9),
            post_draw=true,
            -- bg=Color(.6,.2,.2)
        },style),
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
    class = 'rosef',
    style = {
        color = Color(.9, .8, .9),
        bg = Color(.3, .4, .3),
        border_color = Color(.3, .7, .8),
        align = 'center',
        display='grid',
        column={1,3,1}
    },
    children = { ui.span {
        text = 'child',
        style = {
            bg = Color(0, 0.5, 1),
            padding = { 0, 10 },
        },
    }, {
        style = {
            size = 40,
            bg = Color(1, 0, .5),
            display='grid',
            column={1,1,1}
        },
        children={
            card('strike',{
                rotate = .1,
                origin = { 0, 50 },
            }),
            card('draw',{
                origin = { 50, 50 },
            }),
            card('defend',{
                origin = { 100, 0 },
            }),
        }
    }, ui.span {
        text = 'child_3_lisad',
        class={'p_20'},
        style = {
            color = Color(0, 0, 0),
            size = 20,
            bg = Color(.5, 1, .5)
        }
    }
    }
}
local Scene = {
    class = 'viewport',
    style={
        display='grid',
        row={1,1,5,3}
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
