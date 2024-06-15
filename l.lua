if os.getenv("LOCAL_lua_debugger_vscode") == "1" then
require('lldebugger').start()
end
local Array=require('array')
local arr = Array(1,2,3)
arr=arr+{"bili","tv"}
print(arr)
print(arr:pop(),arr)
print(arr:shift("hi"),arr)
print(arr:unshift(),arr)