local Object=require('classic')
local Vec = require('vec')
local Sprite =Object:extend()

function Sprite:new(center,img_path,ops)
    self.img_path=img_path
    self.center=center or Vec()
    img_path=img_path or 'sheep.png'
    self.img=love.graphics.newImage(img_path)
    self.w,self.h=self.img:getWidth(),self.img:getHeight()
    self.rotation=0
    self.scale=Vec(1,1)
    -- quad
    if ops then
        self.quad=ops.quad
        self.frames = {}
        local fw, fh ,maxf= unpack(ops.quad)
        -- print(maxf)
        self.fw,self.fh=fw,fh
        local max_column=math.floor(self.w/self.fw)-1
        local max_row=math.floor(self.h/self.fh)-1
        for j = 0, max_row do
            for i = 0, max_column do
                local quad = love.graphics.newQuad(i * fw, j*fh, fw, fh, self.img)
                table.insert(self.frames, quad)
                if #self.frames>= maxf then
                    break
                end
            end
        end

    end

end
function Sprite:move(velocity)
    self.center=self.center+velocity
end
function Sprite:draw(frame_id)
    -- print('draw start')
    local x,y=self.center:unpack()
    -- print(x,y)
    local sx,sy=self.scale:unpack()
    if frame_id then
        if frame_id<1 or frame_id >#self.frames then
            local fmt="%s, frame_id: %s out of range"
            error(string.format(fmt,self.img_path,frame_id))
        end
        love.graphics.draw(self.img, self.frames[frame_id],
        x, y, self.rotation, sx, sy, self.fw / 2, self.fh / 2)
    else
        love.graphics.draw(self.img,
        x, y, self.rotation, sx, sy, self.w / 2, self.h / 2)
    end
end
return Sprite