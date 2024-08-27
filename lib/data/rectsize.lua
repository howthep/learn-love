local prototype=require('prototype')
local Vec=require('vec')
---@class rectsize
local rectsize=prototype{name='rectsize'}
function rectsize:new(x,y,w,h)
    self.x=x or 0
    self.y=y or 0
    self.width=w or 0
    self.height=h or 0
end
function rectsize:center()
    return self:get(50,50)
end
---get corrdinate by (x,y)+(w,h)*(u,v)/100
---@param u number
---@param v number
---@return  number
---@return  number
function rectsize:get(u,v)
    local xy=Vec(self.x,self.y)
    local wh=Vec(self.width,self.height)
    return (xy+wh*Vec(u,v)/100):unpack()
end
function rectsize:left_up()
    return self:get(0,0)
end
function rectsize:set_origin(ox,oy)
    local cx,cy=self:center()
    self.ox=ox or cx
    self.oy=oy or cy
end
function rectsize:origin()
    local cx,cy=self:center()
    return self.ox or cx,self.oy or cy
end
return rectsize