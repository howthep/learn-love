local Object=require('classic')
local Vec=require('vec')
local Hexgon=Object:extend()

function Hexgon:new(vec,r)
    self.center=vec
    self.r=r
end

function Hexgon:draw()
    local xys={}
    local r = self.r
    local theta=60/180*math.pi
    for i=0,6 do
        local itheta=i*theta
        local x,y=self.center.x+r*math.cos(itheta),self.center.y+r*math.sin(itheta)
        table.insert(xys,x)
        table.insert(xys,y)
    end
    love.graphics.line(xys)
end

function Hexgon:move(dt)
end

local HexGrid=Object:extend()
function HexGrid:new(vec)
    self.center=vec
    self.size=20.0 -- radius of outer circle 
    self.rotate=0
end
function HexGrid:cube2vec(q,r,s)
    --      ^
    --   q     r
    -- |         |
    -- s    o    s
    -- |         |
    --   -r   -q
    --      v
    local base_angle=30
    local q_vec=Vec(1,0):rotate(base_angle,true)
    local r_vec=Vec(1,0):rotate(base_angle+60,true)
    local step = self.size*math.sqrt(3)
    local center=self.center
    local ret= center+q_vec*step*q+r_vec*step*r
    -- print(ret)
    return ret
end
function HexGrid:draw()
    local size = self.size
    local hexgon=Hexgon(self.center:clone(),size)
    hexgon:draw()
    local center= hexgon.center
    local n=5
    for i=-n,n do
        for j=-n,n  do
        center:set(self:cube2vec(i,j))
        hexgon:draw()
        end
    end
end
function HexGrid:move(dt)
end
local export={
    HexGrid=HexGrid,
    Hexgon=Hexgon
}
return export