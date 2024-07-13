local proto=require('prototype')
local Node=require('node')
local Vec = require('vec')
local Color = proto{
    name='Color',
    r=1,
    b=1,
    g=1,
    a=1,
}
function Color:new(r,g,b,a)
    self.r=r or 1
    self.g=g or 1
    self.b=b or 1
    self.a=a or 1
end
function Color:table()
    return {self.r,self.g,self.b,self.a}
end
-- Shape
local Shape = Node{name='Shape',lw=2,color=Color()}
function Shape:new(config)
    Shape.super(self,config)
end
function Shape:move(dt)
    -- self.x=self.x+self.speed*dt
end
function Shape:set_env()
    love.graphics.setColor(self.color:table())
    love.graphics.setLineWidth(self.lw)
end
function Shape:render()
    self:set_env()
    self:draw()
end
function Shape:draw()
    
end
local Rect = Shape{name='Rect'}
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
local Circle = Shape{name='Circle'}
function Circle:new(x,y,r,speed)
    self.super:new(x,y,speed)
    self.r=r
end
function Circle:draw()
    love.graphics.circle('line',self.x,self.y,self.r)
end
local Line = Shape{name='Line'}
function Line:new(from,to)
    self.from=from
    self.to=to
    self.width=2
end
function Line:draw()
    local a,b=self.from:unpack()
    local c,d=self.to:unpack()
    love.graphics.line(a,b,c,d)
end
local export={}
export.Rect=Rect
export.Circle=Circle
export.Line=Line
export.Color=Color
export.Shape=Shape
return export