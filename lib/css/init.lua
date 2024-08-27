local Array=require('array')
local Vec=require('vec')
local Shape=require('shape')
local Color=Shape.Color
local prototype=require('prototype')
local rectsize=require('data.rectsize')
---@class css
local css=prototype{name='css'}

local _path=(...)
local libs={'grid','layout','style','draw','interact'}
for i,lib in ipairs(libs) do
    table.update(css, require(_path..'.'..lib))
end

local style_table_default = {
    default = {
        align = 'left',
        color = Color(1, 1, 1),
        limit = 999999,
        size=30,
    },
    span = {
        size = 30,
        display='inline',
    },
    div={
        display='block'
    },
    red = {
        color = Color(1, 0, 0),
    },
    blue={
        color = Color(0, 0, 1),
    },
}

---init by style_table
---@param t table class table
function css:new(t)
    self.style_table=table.merge(style_table_default,t)
end
---comment
function css:render(element_root)
    element_root.content = rectsize(
        0, 0,
        self:get_width(element_root),
        self:get_height(element_root)
    )
    self:layout(element_root)
    self:interact(element_root)
    self:draw(element_root)
end
---move to origin, set rotation
---@param element_root any
---@param parent any
---@return unknown
function css:set_transform(element_root,parent)
    local style=self:get_style(element_root)
    parent = parent or {content=rectsize()}
    local ex,ey
    if style.origin then
        ex,ey=element_root.content:get(unpack(style.origin))
    else
        ex,ey=element_root.content:center()
    end
    element_root.content:set_origin(ex, ey)
    local px,py=parent.content:origin()
    local x=ex-px
    local y=ey-py
    love.graphics.translate(x,y)
    love.graphics.rotate(style.rotate or 0)
    return Vec(element_root.content:left_up())-Vec(ex,ey)
    
end
return css