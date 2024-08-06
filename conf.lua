local function addpath(folder)
    local p=string.format('%s;./%s/?.lua',package.path,folder)
    package.path = p
    -- package.path = package.path .. ';./'..folder..'/?.lua'
    -- print(package.path)
end
addpath('lib')
-- local __verson=require('version')
function love.conf(t)
    t.console=false
    t.window.width=1024
    t.window.height=768
    t.window.title='raid the gloom'
    t.window.borderless=false
    -- t.window.resizable=true
end