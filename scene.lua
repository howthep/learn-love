local style=require('style')
local element=require('element')
local Color=require('shape').Color
local Scene={}

Scene.drawable={}
Scene.collidable={}
local bottom_style=style{
            position='absolute',
            bottom=0,
            left=0,
            height='10vh',
            bg=Color(.2,.4,.6),
            width='100vw',
            color=Color(1,1,1),
            display='grid',
            column={1,3,1},
            gap=10,
        }
local text_style=style{
    bg = Color(.5, .8, 1),
    color=Color(0,0,0),
    align='center',
    hover=style{
        bg=Color(.9,.5,.7)
    }
}
local bottom_ui = element.div {
        element.span {
            text = 'draw',
            style = text_style,
        },
        element.span{
            text='cards',
            style = text_style,
        }:add_style{
            bg=Color(.9,.2,.4),
        },
        element.span {
            text = 'discard',
            style = text_style,
        },
        element.span {
            text = 'discard',
            style = text_style,
        },
        element.span {
            text = 'discard',
            style = text_style,
        },
    }:add_style(bottom_style)
:add_style({
    bottom=0
})
Scene.root=element.div{
    bottom_ui
}
return Scene
