local Shape=require('shape').Shape
local Vec=require('vec')
local Transform=require('transform')
local Hexgon=Shape{name='Hexgon'}

function Hexgon:new(vec,r,base_angle)
    Hexgon.super(self,vec)
    self.r=r or 10
    self.base_angle=base_angle or 0
end

function Hexgon:draw()
    local xys={}
    local r = self.r
    local base=self.base_angle/180*math.pi
    local theta=60/180*math.pi
    for i=0,6 do
        local itheta=i*theta+base
        local x,y=self.center.x+r*math.cos(itheta),self.center.y+r*math.sin(itheta)
        table.insert(xys,x)
        table.insert(xys,y)
    end
    love.graphics.line(xys)
end

function Hexgon:move(dt)
end

local HexGrid=Shape{name='HexGrid'}
function HexGrid:new(vec,size,rotate)
    HexGrid.super(self,vec)
    self.size=size or 20.0 -- radius of outer circle 
    self.rotate=rotate
    self.lw=1
end
function HexGrid:touch(x,y)
    print(x,y)
    -- local q,r = self:vec2cube(x,y)
end
local function round(q)
    local fl,cl=math.floor,math.ceil
        if q>=0  then
            if q%1>0.5 then
                return cl(q)
            else
                return fl(q)
            end
        else
            return -round(-q)
        end
end
function HexGrid:vec2cube(vec,y)
    -- local s=0
    -- 1 1 2 1 2
    -- vec is number
    -- 1. project to axis
    -- vec=vec:rotate(-90,true)
    local step =self.size*math.sqrt(3)
    local tr=self:tr()
    local sign=vec:sign()
    -- print(vec,sign)
    local half_step=step/2
    -- local vec_h=tr:inv()*vec
    local vec_h=tr:inv()*vec
    -- vec_h=vec_h:abs():map(math.floor)*vec_h:sign()
    vec_h=vec_h/step
    return vec_h:map(round):unpack()

end
function HexGrid:tr()
    local q,r=self:qr()
    return Transform(
        q.x,r.x,
        q.y,r.y
    )
end
function HexGrid:qr()
    local base_angle=self.rotate+30
    local q_vec=Vec(1,0):rotate(base_angle,true)
    local r_vec=Vec(1,0):rotate(base_angle-60,true)
    return q_vec,r_vec
end
function HexGrid:cube2vec(q,r,s)
    --      ^
    --   q     r
    -- |         |
    -- s    o    s
    -- |         |
    --   -r   -q
    --      v
    local tr=self:tr()
    local step = self.size*math.sqrt(3)
    local ret=tr*Vec(q,r)*step+self.center
    -- at screen space
    return ret
end
function HexGrid:hex_draw(q,r)
    local hexgon=Hexgon(self:cube2vec(q,r),self.size,self.rotate)
    hexgon:draw()
end
function HexGrid:draw()
    love.graphics.setLineWidth(self.lw)
    local n=5
    for i=-n,n do
        for j=-n,n  do
            self:hex_draw(i,j)
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