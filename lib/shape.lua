local proto=require('prototype')
local Node=require('node')
local Vec = require('vec')
local Array=require('array')
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
local Rect = Shape{name='Rect',size=Vec(100,100)}
-- Rect
function Rect:new(config)
    Rect.super(self,config)
end
function Rect:draw()
    local x,y,w,h=self:cwh2xywh(self.center,self.size)
    love.graphics.rectangle('fill',x,y,w,h)
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
function Line:new(from,to,color)
    self.from=from
    self.to=to
    self.width=2
    self.color=color
end
function Line:draw()
    local a,b=self.from:unpack()
    local c,d=self.to:unpack()
    love.graphics.line(a,b,c,d)
end
local Polygon = Shape{name='Polygon',vertices={100,100,200,100,200,200},color=Color(.6,.4,.4)}
function Polygon:new(vertices)
    self.vertices=vertices
end
function Polygon:draw()
    local mode='fill'
    love.graphics.polygon(mode,self.vertices)
end
function Polygon:vec_table()
    local vec_num=#self.vertices/2
    local xys=self.vertices
    local vecs={}
    for i=1,vec_num do
        local x,y=xys[i*2-1],xys[i*2]
        table.insert(vecs,Vec(x,y))
    end
    return vecs
end
function Polygon:normal()
    -- for collid, normal of edge 
    -- return: Array of Vec
    local vecs=Array(self:vec_table())

    return vecs:map(function (v,i,arr)
        local line
        if i~=#arr then
            line = arr[i + 1] - arr[i]
        else
            line = arr[1] - arr[i]
        end
        return line:prep()
    end)
end
function Polygon:center()
    local vecs=Array(self:vec_table())
    local sum=Vec()
    vecs:each(function (v)
        sum=sum+v
    end)
    return sum/#vecs
end
local export={}
export.Rect=Rect
export.Circle=Circle
export.Line=Line
export.Color=Color
export.Shape=Shape
export.Polygon=Polygon
return export