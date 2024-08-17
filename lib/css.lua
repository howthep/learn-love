local el=require('element')
local Array=require('array')
local Color=require('shape').Color
local prototype=require('prototype')
local pen=require('pen')
---@class css
---@field style_table table
local css=prototype{name='css'}
local style_table_default = {
    dfs = {
        align = 'left',
        color = Color(1, 1, 1),
        limit = 999999,
    },
    span = {
        size = 30,
    },
    red = {
        color = Color(1, 0, 0),
    },
    blue={
        color = Color(0, 0, 1),
    },
}

---init by style_table
---@param t table
function css:new(t)
    self.style_table=table.merge({},style_table_default,t)
end
function css:render(element_root)
    local st=self.style_table
    local style = Array(element_root.class):reduce(function (accu_style,class_name)
        local s=st[class_name]
        if s.compose then
            local composed=table.merge(Array(s.compose):map(function (name)
                return st[name]
            end):unpack())
            s.compose=nil
            s=table.merge(composed,s)
            st[class_name]=s
        end
        return table.merge(accu_style,s)
    end,{})
    pen.text(table.merge(st.dfs,style ,{
        text = element_root.text,
        x = 100,
        y = 100,
    }))
end
return css