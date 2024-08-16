local el=require('element')
local Array=require('array')
local css={}
local Color=require('shape').Color
local pen=require('pen')
function css:new(classes)
    self.classes=classes
end
local Cls={
    span={
        size=30,
    },
    red={
        color=Color(1,0,0),
    }
}
local elem={
    class={'span','red'},
    text='haha',
    id='cs'
}
local dfs = {
    align = 'left',
    color = Color(1, 1, 1),
    limit=999999,
}
function css.render(element_root)
    local style = Array(elem.class):reduce(function (accu_style,class_name)
        return table.merge(accu_style,Cls[class_name])
    end,{})
    pen.text(table.merge(dfs,style ,{
        text = elem.text,
        x = 100,
        y = 100,
    }))
end
return css