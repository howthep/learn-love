local prototype = require('prototype')
local Array     = require('array')
local pen       = require('pen')
local Vec       = require('vec')
local cm        = require('spire.card')
local Hexgrid   = require('hexgon').HexGrid
local FP        = require('FP')

---@class combat
---@operator call:combat
---@field content rectsize
local combat=prototype{name='combat'}

function combat:new(config)
    self.hexgrid=Hexgrid(Vec(),config.hex_size or 50)
    self.spire=config.spire
    self.style={
        z_index=-1,
        display='grid',
        row={3,1}
    }
    self.children={
        {},
        cm(self.spire)
    }
end

---start a combat with enemy and each qr coordinate
---@param config table {enemy,qrs,player}
function combat:start(config)
    self.enemy=config.enemy
    self.qrs=config.qrs
    self.player=self.spire.player
    self.pos2enemy={}
end

function combat:draw(config)
    love.graphics.setColor(1, 1, 1)
    self.hexgrid:draw()
    for i,e in ipairs(self.enemy) do
        local q,r=unpack(self.qrs[i])
        self.pos2enemy[q..','..r]=e
        e.center=self.hexgrid:cube2vec(q,r)
        e:draw()
    end
    local player=self.spire.player
    player:draw()
    local player_qr=Vec(self.hexgrid:vec2cube(player.center))
    local mx,my=love.mouse.getPosition()
    local q, r = self:get_qr(mx,my)
    local is_inside=self.content:is_hover(mx,my)
    local selected_card=self.spire.selected_card
    local out_range=true
    --- show hex at mouse
    -- love.graphics.setColor(0,1,0,.8)
    -- self.hexgrid:hex_draw(q,r)
    if selected_card then
        if is_inside then
            local range=selected_card.range or 0
            self:highlight(range,selected_card.target)
            local dir=(player_qr-Vec(q,r))
            local a,b=dir:unpack()
            out_range=Array(a,b,-a-b):exist(function (v)
                return math.abs(v)>range
            end)

            love.graphics.push()
            love.graphics.origin()
            local cx, cy = selected_card.content:center()
            local bezier = love.math.newBezierCurve({ cx, cy, cx, my, mx, my })
            pen.bezier(bezier)
            love.graphics.pop()
        end

        if not love.mouse.isDown(1)  then
            local has_target = self['has_' .. selected_card.target](self,q,r)
            print(is_inside,selected_card,not out_range,has_target)
            if is_inside and selected_card and not out_range and has_target then
                -- self.player.center=self.hexgrid:cube2vec(q,r)
                selected_card:use({
                    player = self.player,
                    qr = Vec(q, r),
                    xy = self.hexgrid:cube2vec(q, r),
                    target=has_target,
                })
            end
            self.spire.selected_card = nil
        end
    end
end
---return q,r
---@param x number
---@param y number
---@return  number
---@return  number
function combat:get_qr(x,y)
    return self.hexgrid:vec2cube(Vec(x, y) - Vec(self.content:center()))
end
---@return number
---@return number
function combat:player_qr()
    return self.hexgrid:vec2cube(self.player.center)
end
function combat:highlight(range,target)
    target=target or 'space'
    local center=Vec(self:player_qr())
    if range<1 then
        return
    end
    love.graphics.setColor(0,.8,1,.6)
    for q=-range,range do
        for r=-range,range do
            local s=-q-r
            local hex_qr = Vec(q,r) + center
            local test_fn=self['has_'..target]
            if math.abs(s)<=range and test_fn(self,hex_qr.x,hex_qr.y) then
                self.hexgrid:hex_draw(hex_qr:unpack())
            end
        end
    end
end
function combat:has_enemy(q,r)
    q,r=Vec(q,r):map(FP.remove_minus_0):unpack()
    return self.pos2enemy[q..','..r]
end
function combat:has_space(q,r)
    local no_enemy= not self:has_enemy(q,r)
    local no_player= Vec(self:player_qr())~=Vec(q,r)
    return no_enemy and no_player
end
return combat