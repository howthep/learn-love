local Object=require('classic')
local Vec = Object:extend()
local function degree2radian(degree)
    return degree/180*math.pi
end

function Vec:new(x,y)
    self.x=x or 0
    self.y=y or 0
end
function Vec:__add( new_vec)
    local x, y = self.x + new_vec.x, self.y + new_vec.y
    return Vec(x,y)
end
function Vec:__sub(new_vec)
    return self+new_vec*-1
end
function Vec:set(vec,y)
    if type(y)=="number" then
        local x= vec
        self.x=x
        self.y=y
    else
        self.x = vec.x
        self.y = vec.y
    end
end
function Vec:__mul(mul)
    local x,y=self:unpack()
    if type(mul)=="number"  then
        -- div is a number
        return Vec(x*mul,y*mul)
    else
        -- div is a vec
        local dx,dy=mul:unpack()
        return Vec(x * dx, y * dy)
    end
end
function Vec:__div(div)
    local x,y=self:unpack()
    if type(div)=="number" and div~=0 then
        -- div is a number
        return Vec(x/div,y/div)
    else
        -- div is a vec
        local dx,dy=div:unpack()
        if dx*dy ~=0 then
            return Vec(x/dx,y/dy)
        end
    end
end
function Vec:__tostring()
    return string.format("Vec(%s, %s)",self.x,self.y)
end
function Vec:unpack()
   return self.x,self.y
end
function Vec:clone()
    return Vec(self.x,self.y)
end
function Vec:abs()
    local x,y=self:unpack()
    return Vec(math.abs(x),math.abs(y))
end
function Vec:quadrant()
    local x,y=self:unpack()
    if x>0 then
        if y>0 then
            return 1
        else
            return 2
        end
    elseif x<0 then
        if y>0 then
            return 3
        else
            return 4
        end
    end
end
function Vec:len()
    local x,y=self:unpack()
    return math.sqrt(x^2+y^2)
end
function Vec:normal()
    local len = self:len()
    if len==0 then
        return nil
    end
    return self:clone()/len
    
end
function Vec:theta(is_degree)
    local x,y=self:unpack()
    local basic_theta= math.atan2(y,x)
    if is_degree then
        basic_theta =degree2radian(basic_theta)
    end
    return basic_theta
end
function Vec:rotate(theta,is_degree)
    if is_degree then
        theta=degree2radian(theta)
    end
    local current_theta = self:theta()
    theta=theta+current_theta
    local len=self:len()
    local v=Vec(math.cos(theta),math.sin(theta))
   return v*len
end
return Vec