-- container auto layout its content
local proto=require('prototype')
local Node=require('node')
local Container=Node{name='Container'}
Container.w=100
Container.h=100
function Container:new(vec,config)
    Container.super(self,vec)
    self.w=0
    table.update(self,config or {})
    -- print(self.w,self.h)
end
return Container