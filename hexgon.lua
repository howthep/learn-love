local prototype=require('prototype')
local Array=require('array')
local Vec=require('vec')
local Transform=require('transform')
---@class Hexgon
local Hexgon=prototype{name='Hexgon',center=Vec()}
function Hexgon:new(vec,r,base_angle)
    self.center=vec
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

---@class HexGrid
---@operator call:HexGrid
local HexGrid=prototype{name='HexGrid',rotate=0,size=50,center=Vec()}
function HexGrid:new(vec,size,rotate)
    self.center=vec
    self.size=size  -- radius of outer circle 
    self.rotate=rotate 
    self.lw=1
    self.ground = love.graphics.newImage('assets/ground.png')
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
local function vec2qrs(vec_qr)
    local q,r=vec_qr:unpack()
    return q,r,-q-r
end
---return q,r
---@param vec any
---@return number
---@return number
function HexGrid:vec2cube(vec)
    local step =self.size*math.sqrt(3)
    local xy2qr=self:tr():inv()
    local vec_qr=xy2qr*vec
    vec_qr=vec_qr/step
    return vec_qr:map(round):unpack()
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
function HexGrid:draw_qr(q,r)
    local x,y=self:cube2vec(q,r):unpack()
    self:draw_xy(x,y)
    -- local hexgon=Hexgon(self:cube2vec(q,r),self.size,self.rotate)
    -- hexgon:draw()
end
function HexGrid:draw_xy(x,y)
    local ground=self.ground
    local w, h = ground:getWidth(), ground:getHeight()
    local scale = 2 * self.size / w
    love.graphics.draw(ground, x, y, 0, scale, scale, w / 2, h / 2)
end
function HexGrid:draw()
    love.graphics.setLineWidth(self.lw)
    local n=5
    for i=-n,n do
        for j=-n,n  do
            self:draw_qr(i,j)
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