local ui=require('element')
local Color=require('shape').Color

local Scene = {
    class = 'rosef',
    style = {
        color = Color(.9, .8, .9),
        bg = Color(.1, .1, .1),
        border_color = Color(.3, .7, .8),
        align = 'center'
    },
    children = { ui.span {
        text = 'child',
        style = {
            bg = Color(0, 0.5, 1),
        },
    }, ui.span {
        text = 'child_2_lal',
        class = 'blue',
        style = {
            width=120,
            size = 40,
            bg = Color(1, 0, .5)
        }
    }, ui.span {
        text = 'child_3_lisad',
        style = {
            color = Color(0, 0, 0),
            size = 20,
            bg = Color(.5, 1, .5)
        }
    }
    }
}
return Scene
