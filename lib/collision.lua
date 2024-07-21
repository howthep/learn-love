local Array=require('array')
local Color=require('shape').Color
local proto=require('prototype')
local Line=require('shape').Line
local Collid=proto{name="collid"}
function Collid:new()
    self.drawables=Array{}
end
function Collid:sat(c1,point)
    local collid=self
    c1.color=Color(.1,.3,.1)
    self.drawables:push(c1)
    local normals=c1:normal()
    local center=c1:center()
    normals:each(function (dir)
        local to=center+dir*100
        collid.drawables:push(Line(center,to))
    end)
    local vertices=Array(c1:vec_table())
    local is_collid=not normals:exist(function (normal,i,arr)
        -- if not exists a normal where no overlap, so collid
        local projects=vertices:map(function (vertex)
            return vertex:project(normal)-center:project(normal)
        end)
        local pj=point:project(normal)-center:project(normal)
        return not self:check_overlap(projects,{pj},normal,center)
    end)
    if is_collid then
            c1.color=Color(.3,.6,.6)
    end
end
function Collid:check_overlap(pj1,pj2,normal,center)
    local function get_max_min(t)
        local min,max=t[1],t[1]
        Array(t):each(function (v)
            if v <min then
                min=v
            end
            if v>max then
                max=v
            end
        end)
        return max,min
    end
    local max1,min1=get_max_min(pj1)
    local max2,min2=get_max_min(pj2)
    self.drawables:push(Line(center+normal*max1,center+normal*min1,Color(.9,.2,.7)))
    self.drawables:push(Line(center+normal*(max2+5),center+normal*min2,Color(.3,.9,.1)))
    if (max1>min2 and min1<min2) or
        (max1 > max2 and min1 <max2) then
        return true
    else
        return false
    end
end
function Collid:remove_parallel_axis(axis)
    
end
function Collid:render()
    print("drawables len: "..#self.drawables)
    self.drawables:each(function (v,i)
        v:render()
    end)
    self.drawables=Array{}
end
local function test()
    local arr=Array{1,2,3} + {10,9,8}
    print(arr)
end
-- test()
-- love.event.quit()
return Collid