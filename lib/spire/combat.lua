local prototype=require('prototype')
local Array=require('array')
local pen=require('pen')
local Vec=require('vec')
local cm=require('spire.card')
local Hexgrid=require('hexgon').HexGrid

---@class combat_manager
---@operator call:combat_manager
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
end

function combat:draw(config)
    local rs=300
    love.graphics.stencil(function ()
        local t=love.timer.getTime()
        love.graphics.circle('fill',0,0,rs+100*math.sin(t))
        -- local x,y=config.offset:unpack()
        -- love.graphics.rectangle('fill',x,y,content.width,content.height)
    end)
    love.graphics.setStencilTest('greater',0)
    love.graphics.setColor(1, 1, 1)
    self.hexgrid:draw()
    for i,e in ipairs(self.enemy) do
        e.center=self.hexgrid:cube2vec(unpack(self.qrs[i]))
        e:draw()
    end
    local player=self.spire.player
    player:draw()
    local player_qr=Vec(self.hexgrid:vec2cube(player.center))
    local mx,my=love.mouse.getPosition()
    local q, r = self.hexgrid:vec2cube(Vec(mx, my) - Vec(self.content:center()))
    local is_inside=self.content:is_hover(mx,my)
    local selected_card=self.spire.selected_card
    local out_range=true
    if selected_card then
        if is_inside then
            local range=selected_card.range or 9999
            local dir=(player_qr-Vec(q,r))
            local a,b=dir:unpack()
            out_range=Array(a,b,-a-b):exist(function (v)
                return math.abs(v)>range
            end)
            -- print(player_qr,q,r,distance)
            local color=not out_range and 1 or .2
            love.graphics.setColor(0,color,color,.7)
            self.hexgrid:hex_draw(q,r)
            love.graphics.setStencilTest()

            love.graphics.push()
            love.graphics.origin()
            local cx, cy = selected_card.content:center()
            local bezier = love.math.newBezierCurve({ cx, cy, cx, my, mx, my })
            pen.bezier(bezier)
            love.graphics.pop()
        end
    end
    if not love.mouse.isDown(1) then
        if is_inside and selected_card and not out_range then
            -- self.player.center=self.hexgrid:cube2vec(q,r)
            selected_card:use({
                player=self.player,
                qr=Vec(q,r),
                xy=self.hexgrid:cube2vec(q,r)
            })
        end
        self.spire.selected_card=nil
    end
    love.graphics.setStencilTest()
end
return combat