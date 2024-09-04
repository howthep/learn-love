local prototype=require('prototype')
local TIME=0 --- in second
local timer={name='timer'}
local Array=require("array")
local queue=Array()

---@param func any
---@param period_ms number|nil milisecond
function timer.interval(func,period_ms)
    queue:push{
        f=func,
        period_ms=period_ms or 0,
        start=TIME,
        times=0,
    }
end
function timer.oneshot(func,delay_ms)
    timer.interval(function (...)
        func(...)
        return true
    end,delay_ms)
end
function timer.update(t)
    TIME=TIME+t

    local pop_index=Array()
    queue:each(function (v,i)
        local period=v.period_ms/1000
        local dt=TIME-v.start
        if dt>period*(v.times+1) then
            v.times=v.times+1
            local stop = v.f(dt)
            if stop == true then
                pop_index:push(i)
            end
        end
    end)
    pop_index:reversed():each(function (index)
        queue:remove(index)
    end)
end
return timer