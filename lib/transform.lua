local Vec=require('vec')
local Object=require('classic')
local Transform  = Object:extend()

function Transform:new(a,b,c,d)
    if a==nil then
        self.data = {
            1, 0,
            0, 1 }
    else
        self.data = {
            a, b,
            c, d }
        
    end
end
function Transform:set(a,b,c,d)
    self.data = {
        a, b,
        c, d }
end
function Transform:clone()
    local a,b,c,d =self:unpack()
    return Transform(a,b,c,d)
end
function Transform:__mul(n)
    -- n is number
    if type(n)=="number" then
        
    local tr=self:clone()
    for i=1,4 do
        tr.data[i]=tr.data[i]*n
    end
    return tr
    -- n is vector
    elseif n:is(Vec) then
        local a,b,c,d=self:unpack()
        local x,y=n:unpack()
        return Vec(a*x+b*y,c*x+d*y)
    end
    -- n is transform
end
function Transform:inv()
    local a,b,c,d =self:unpack()
    local det = self:det()
    local tr=Transform()
    if det~=0 then
        tr:set(d,-b,-c,a)
    end
    return tr*(1/det)
end
function Transform:__tostring()
    local a,b,c,d=self:unpack()
    return string.format("Transform\n[%4s,%4s,\n %4s,%4s]",a,b,c,d)
end
function Transform:unpack()
    return unpack(self.data)
end
function Transform:det()
    -- a,b
    -- c,d
    local a,b,c,d =self:unpack()
    return a*d-c*b
end
return Transform