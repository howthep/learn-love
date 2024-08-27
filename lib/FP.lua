local FP={}
function FP.add(x,y)
    return x+y
end
function FP.mul(x,y)
    return x*y
end
function FP.chain(...)
    local fns={...}
    return function (x)
        for i, fn in ipairs(fns) do
            x=fn(x)
        end
        return x
    end
end
function FP.clamp(x,min,max)
        if x<min then
            x=min
        elseif x > max then
            x = max
        end
        return x
end
function FP.is_zero(v)
    return v==0
end
function FP.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end
function FP.relu(x)
    if x>0 then
        return x
    else
        return 0
    end
end
return FP