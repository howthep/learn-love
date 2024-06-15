if os.getenv("LOCAL_lua_debugger_vscode") == "1" then
require('lldebugger').start()
end
local People={}
local mt={}
mt.__index=mt
People.mt=mt
People.new=function (name)
    local p=setmetatable({},People.mt)
    p.name=name
    return p
end

function mt:hi()
    print("hi",self.name)
end
local p=People.new('bob')
p:hi()