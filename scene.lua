local ui=require('element')
local Vec=require('vec')
local Color=require('shape').Color
local TODO='sprite attack, HP '
local Hex=require('hexgon').HexGrid
local spire=require('spire')
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
local Scene = {
    class = 'viewport',
    style={
        display='grid',
        row={1,1,16}
    },
    children={
        status,
        relices,
        spire,
    }
}
return {
    ui=Scene,
    class=Class,
}
