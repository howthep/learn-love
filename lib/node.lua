local proto = require('prototype')
local Vec=require('vec')
local Node=proto{name="Node",center=Vec()}
function Node:new(config)
    config=config or {}
    if config.name=='Vec' then
        local center=config
        self.center = center:clone()
    else
        -- config is table
        local v = config.center or Vec()
        self.center = v:clone()
        config.vec=nil
        table.merge(self,config)
    end
    -- Node.super(config)
end

function Node:cwh2xywh(center,size)
    local lt=center-size/2
    return lt.x,lt.y,size.x,size.y
end
return Node