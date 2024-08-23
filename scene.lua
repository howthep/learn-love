local ui=require('element')
local Color=require('shape').Color
local Class={
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
            text='Main',
            class='p_20'
        },
    }
}
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
    }, ui.span {
        text = 'child_2_lal',
        class = {'blue','p_20'},
        style = {
            size = 40,
            bg = Color(1, 0, .5),
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
