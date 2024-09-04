local pen    = require('pen')
local Vec    = require('vec')
local cm     = require('spire.card')
local FP     = require('FP')

---@class combat
local combat={}
function combat:update()
    local player=self.spire.player
    local player_qr=Vec(self.hexgrid:vec2cube(player.center))
    local mx,my=love.mouse.getPosition()
    local q, r = self:get_qr(mx,my)
    local is_inside=self.content:is_hover(mx,my)
    local mouse_click=love.mouse.isDown(1) and is_inside
    if mouse_click then
        if not self.click_start then
            self.click_start=Vec(mx,my)
            self.click_before=player.center:clone()
            if player_qr == Vec(q, r) then
                self.clicked = player
                self.click_size=player.width
                player.width=player.width+10
                pen.get_sound('assets/sound/tilepickup.ogg'):play()
            end
        end
        if self.clicked==player then
            player.center = Vec(mx, my) - self.click_start + self.click_before
        end
    elseif self.click_start then
        if self.clicked then
            player.width = self.click_size
            player.center=self:nearest_center(player.center)
            pen.get_sound('assets/sound/tiledrop.ogg'):play()
            local enemy=self:has_enemy{range=1}
            if #enemy>0 then
                player:attack(enemy)
            end
        end
        self.click_start=nil
        self.clicked=nil
    end
    
end
function combat:draw(config)
    self:update()
    love.graphics.setColor(1, 1, 1)
    self.hexgrid:draw()
    for i,e in ipairs(self.enemy) do
        local q,r=unpack(self.qrs[i])
        self.pos2enemy[q..','..r]=e
        e.center=self.hexgrid:cube2vec(q,r)
        e:draw()
    end
    if self.clicked == self.player then
        self:highlight(1)
    end
    self.player:draw()
    --- show hex at mouse
    -- love.graphics.setColor(0,1,0,.8)
    -- self.hexgrid:hex_draw(q,r)
end
return combat