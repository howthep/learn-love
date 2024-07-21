-- container auto layout its content
local proto=require('prototype')
local Node=require('node')
local Shape=require('shape')
local Vec=require('vec')
local Container=Node{name='Container',size=Vec(100,100)}
function Container:new(vec,config)
    Container.super(self,vec)
    table.update(self,config or {})
end
function Container:render()
    -- local rect=Shape.Rect{center=self.center,size=self.size}
    -- rect:render()
end
return Container