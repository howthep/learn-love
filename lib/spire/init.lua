local prototype=require('prototype')
local pen=require('pen')
local Vec=require('vec')
local Color=require('color')
local Spirte=require('sprite')
local ui=require('element')
local path=(...)
local Combat=require('spire.combat')
local card=require(path..'.card')

local TODO='sprite attack animation, HP '

---@class Spire
local Spire = prototype {
    name = 'Spire',
    class = 'viewport',
    style = {
        display = 'grid',
        row = { 1, 1, 16 },
    },
}
function Spire:new()
    self.combat = Combat({
        spire = Spire
    })
    
    local width = self.combat.hexgrid.size * 2
    Spire.player=Spirte(self.combat.hexgrid:cube2vec(1,0),'assets/me.png',width)
    local he=Spirte(Vec(),'assets/he.png',width)
    local ye=Spirte(Vec(),'assets/he.png',width)
    local combat_setting={
        enemy = { he,ye},
        qrs = {
            { 1, 2 },
            {2,0},
        }
    }
    self.combat:start(combat_setting)
    self.status = {
        style = {
            bg = Color(.1, .2, .2)
        },
        children = {
            ui.span {
                text = 'status',
                class = 'p_20'
            }
        }
    }
    self.relices = {
        style = {
            bg = Color(0, .5, .6),
        },
        children = {
            ui.span {
                text = 'R',
                class = 'p_20'
            },
            ui.span {
                text = 'TODO: ' .. TODO,
                class = 'p_20'
            },
        }
    }
    self.children={
        self.status,
        self.relices,
        self.combat
    }
end


return Spire