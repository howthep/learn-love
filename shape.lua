local Object = require("classic")
local Shape = Object:extend()
-- Shape
function Shape:new(x,y,speed)
   self.x=x
   self.y=y
   self.speed=speed
end
function Shape:move(dt)
    self.x=self.x+self.speed*dt
end
local Rect = Shape:extend()
-- Rect
function Rect:new(x,y,w,h,speed)
    self.super:new(x,y,speed)
    self.w=w
    self.h=h
end
function Rect:draw()
    love.graphics.rectangle('line',self.x,self.y,self.w,self.h)
end
-- Circle
local Circle = Shape:extend()
function Circle:new(x,y,r,speed)
    self.super:new(x,y,speed)
    self.r=r
end
function Circle:draw()
    love.graphics.circle('line',self.x,self.y,self.r)
end
local export={}
export.Rect=Rect
export.Circle=Circle
return export