local prototype=require('prototype')
local turn=prototype{name='turn'}
function turn:new()
    self.count=0
end
function turn:__tostring()
    return string.format('turn: %d',self.count)
end
return turn