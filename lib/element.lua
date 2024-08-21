local ptt=require('prototype')
local element={}
function element.span(config)
    local class={'span'}
    if type(config.class)=='string' then
        table.insert(class,config.class)
    else
        for i, c in ipairs(config.class or {}) do
            table.insert(class, c)
        end
    end
    config.class=nil
    return table.merge({class=class},config)
end
return element