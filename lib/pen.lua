-- draw everything
-- normal coordinate [-1,1]
-- manage drawing, coloring, font
local Node=require('node')
local Color=require('shape').Color
local Vec=require('vec')
local Pen=Node{name="Pen"}
local function cwh2xywh(center,size)
    local lt=center-size/2
    return lt.x,lt.y,size.x,size.y
end
function Pen:new(center,size)
    local config={vec=center or self:screen_center()}
    Pen.super(self,config)
    self.size=size or self.center*2
    self.color=Color()
    self.lw=2
    self.child={}
    self.temp={}
end
function Pen:push(drawable,name)
    if drawable.draw and name then
        self.child[name]=drawable
    else
        table.insert(self.temp,drawable)
    end
end
function Pen:draw()
    local x,y,w,h=cwh2xywh(self.center,self.size)
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
