local Object=require('classic')
local Vec = Object:extend()

function Vec:new(x,y)
    self.x=x or 0
    self.y=y or 0
end