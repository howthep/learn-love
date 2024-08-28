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
        top=0,
        left=0,
        z_index=0,
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
return css