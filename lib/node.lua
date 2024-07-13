local proto = require('prototype')
local Vec=require('vec')
local Node=proto{name="Node",center=Vec()}
function Node:new(config)
    config=config or {}
    if config.name=='Vec' then
        self.center = config:clone()
    else
        -- config is table
        local v = config.vec or Vec()
        self.center = v:clone()
        config.vec=nil
        table.merge(self,config)
    end
    -- Node.super(config)
end
return Node