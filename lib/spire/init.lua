local prototype=require('prototype')
local pen=require('pen')
local Vec=require('vec')
local Color=require('shape').Color
local Spirte=require('sprite')
local ui=require('element')
local path=(...)
local Combat=require('spire.combat')
local card=require(path..'.card')
---@class Spire
local Spire=prototype{name='battle_manager'}

local combat=Combat({
    spire=Spire
})
local width=combat.hexgrid.size*2
Spire.player=Spirte(Vec(),'assets/me.png',width)
local he=Spirte(Vec(),'assets/he.png',width)
combat:start({
    enemy = { he },
    qrs = {
    {1,3}
    }
})

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
            z_index=10,
            size = 40,
            -- bg = Color(1, 0, .5),
        },
        children={
            card{text='strike', style={},spire=Spire},
            card{text='move 2', spire=Spire,range=2,
            use=function (self,config)
                config.player.center=config.xy
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
Spire.style = {
        display = 'grid',
        row={3,1},
        z_index=-1,
     }
    Spire.children={
        combat,
        bottom_cards,
    }
return Spire
-- return battle_manager