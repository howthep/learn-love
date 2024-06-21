local Object=require('classic')
local Vec = require('vec')
local Sprite =Object:extend()

function Sprite:new(center,img_path)
    self.center=center or Vec()
    img_path=img_path or 'sheep.png'
    self.img=love.graphics.newImage(img_path)
    self.w,self.h=self.img:getWidth(),self.img:getHeight()
    self.rotation=0
    self.scale=Vec(1,1)
end
function Sprite:move(velocity)
    self.center=self.center+velocity
end
function Sprite:draw()
    print('draw start')
    local x,y=self.center:unpack()
    print(x,y)
    local sx,sy=self.scale:unpack()
    love.graphics.draw(self.img,x,y,self.rotation,sx,sy,self.w/2,self.h/2)
end
return Sprite