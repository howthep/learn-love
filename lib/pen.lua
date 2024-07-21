-- draw everything
-- normal coordinate [-1,1]
-- manage drawing, coloring, font
local Node=require('node')
local Color=require('shape').Color
local Vec=require('vec')
local Pen=Node{name="Pen"}
function Pen:new(center,size)
    Pen.super(self,center or self:screen_center())
    self.size=size or self.center*2
    self.color=Color()
    self.lw=2
    self.child={}
    self.temp={}
end
function Pen:push(drawable,name)
    if drawable.render then
        if name then
            self.child[name] = drawable
        else
            table.insert(self.temp, drawable)
        end
    end
end
function Pen:draw()
    local x,y,w,h=self:cwh2xywh(self.center,self.size)
    love.graphics.setScissor(x,y,w,h)
    for k,v in pairs(self.child) do
        v:render()
    end
    for k,v in ipairs(self.temp) do
        v:render()
    end
    self.temp={}
end
function Pen:screen_center()
    local w,h,_=love.window.getMode()
    return Vec(w/2,h/2):map(math.floor)
end
return Pen
