local Vec=require('vec')
local FP=require('FP')
local Array=require('array')

---@class combat
local combat={}
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
---get nearest hex center 
---@param vec Vec2
---@return Vec2
function combat:nearest_center(vec)
    local grid=self.hexgrid
    local q,r=grid:vec2cube(vec)
    return grid:cube2vec(q,r)
end
function combat:highlight(range,target)
    target=target or 'space'
    local center=self.player.center
    if range<1 then
        return
    end
    love.graphics.setColor(0,.6,.9,.4)
    for q=-range,range do
        for r=-range,range do
            local s=-q-r
            local at_center = q==0 and r==0
            local hex_xy = self.hexgrid:cube2vec(q,r) + center
            if math.abs(s)<=range and not at_center then
                self.hexgrid:draw_xy(hex_xy:unpack())
            end
        end
    end
end
---@param config table {qr,range}
---@return any
function combat:has_enemy(config)
    if config.qr then
        local q, r = config.qr:map(FP.remove_minus_0):unpack()
        return Array(self.pos2enemy[q .. ',' .. r])
    end
    if config.range then
        local player=Vec(self:player_qr())
        local enemy = Array()
        local range = config.range
        for q = -range, range do
            for r = -range, range do
                local s = -q - r
                local at_center = q == 0 and r == 0
                if math.abs(s) <= range and not at_center then
                    local e = self:has_enemy { qr = Vec(q, r)+ player}
                    if #e>0 then
                        enemy:push(e[1])
                    end
                end
            end
        end
        return enemy
    end
end
function combat:has_space(q,r)
    local qr=Vec(q,r)
    local no_enemy= not self:has_enemy{qr=qr}
    local no_player= Vec(self:player_qr())~=qr
    return no_enemy and no_player
end
return combat