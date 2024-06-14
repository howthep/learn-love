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
        local x,y=self.x+r*math.cos(itheta),self.y+r*math.sin(itheta)
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
    self.size=20.0
end
function HexGrid:cube2vec(q,r,s)
    -- q  r  s
    --    o
    -- -s -r -q
    local x,y=0,0
end
function HexGrid:draw()
    local size = 20.0
    local center= self.center
    local hexgon=Hexgon(center,size)
    local n=10
    for i=1,n do
        hexgon:draw()
        hexgon.x=hexgon.x+size*1.5
        hexgon.y=hexgon.y+size*math.sqrt(3)/2
    end
end
function HexGrid:move(dt)
end
local export={
    HexGrid=HexGrid,
    Hexgon=Hexgon
}
return export