local Vec = require('vec')
local prototype=require('prototype')
local pen=require('pen')
local Color=require('color')
local timer=require('timer')
---@class Sprite
---@field center Vec2
local Sprite =prototype{name='Sprite',center=Vec()}
function Sprite:attack(enemy)
    enemy=enemy[1]
    print('attack',enemy)
    timer.interval(function (time)
        local end_time=.6
        if time>end_time then
            self.attack_draw=function ()
            end
            enemy:hurt(2)
            return true
        end
        self.attack_draw = function()
            local deg90=math.pi/2
            local rotate=math.cos(time/end_time*deg90)*-90
            self.rotation=rotate*math.pi/180
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(5)
            local x, y = self.center:unpack()
            local end_vec = self.center + (enemy.center - self.center):rotate(rotate, true) * 1.5
            love.graphics.line(x, y, end_vec:unpack())
        end
    end)
end

function Sprite:new(center,img_path,width,ops)
    self.center=center
    self.img_path=img_path or 'assets/me.png'
    self.img=love.graphics.newImage(img_path)
    self.iw,self.ih=self.img:getWidth(),self.img:getHeight()
    self.width=width  or self.iw
    self.rotation=0
    self.range=1
    self.color=Color()
    -- quad
    if ops then
        self.quad=ops.quad
        self.frames = {}
        local fw, fh ,maxf= unpack(ops.quad)
        -- print(maxf)
        self.fw,self.fh=fw,fh
        local max_column=math.floor(self.iw/self.fw)-1
        local max_row=math.floor(self.ih/self.fh)-1
        for j = 0, max_row do
            for i = 0, max_column do
                local quad = love.graphics.newQuad(i * fw, j*fh, fw, fh, self.img)
                table.insert(self.frames, quad)
                if #self.frames>= maxf then
                    break
                end
            end
        end

    end

end
function Sprite:draw(frame_id)
    -- print('draw start')
    love.graphics.setColor(self.color:table())
    local x,y=self.center:unpack()
    -- print(x,y)
    local sclae=self.width/self.iw
    if frame_id then
        if frame_id<1 or frame_id >#self.frames then
            local fmt="%s, frame_id: %s out of range"
            error(string.format(fmt,self.img_path,frame_id))
        end
        love.graphics.draw(self.img, self.frames[frame_id],
        x, y, self.rotation, sclae, sclae, self.fw / 2, self.fh / 2)
    else
        love.graphics.draw(self.img,
        x, y, self.rotation, sclae, sclae, self.iw / 2, self.ih / 2)
    end
    if self.hurt_info then
        self:show_hurt(self.hurt_info)
    end
    self:attack_draw()
end
function Sprite:show_hurt(config)
    local x,y=self.center:unpack()
    local sclae=self.width/self.iw
    pen.text{
        text=config.text,
        offset=Vec(x-self.width/2,y-self.ih*sclae/1.5)+config.offset,
        color=config.color,
        width=self.width,
        size=40
    }
end
function Sprite:attack_draw()
    
end
function Sprite:hurt(damage)
    print('damage',damage)
    timer.interval(function (time)
        local end_time=2
        local alpha=1-time/end_time
        self.hurt_info={
            text=damage,
            offset=Vec(10*math.sin(time*6),-time*30),
            color=Color(1,0,0,math.sin(alpha*math.pi/2))
        }
        if time>end_time then
            self.hurt_info=nil
            return true
        end
    end)
end
function Sprite:__tostring()
    return string.format('%s,%s',self.img_path,self.center)
end
return Sprite