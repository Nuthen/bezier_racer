game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:enter()
    local x = love.graphics.getWidth()/2
    local y = love.graphics.getHeight()/2

    local r = 300

    self.curve = love.math.newBezierCurve({x, y-r, x+r, y, x, y+r, x-r, y, x, y-r})
    self.derivative = self.curve:getDerivative()

    self.time = 0
    self.speed = 0.1

    self.floating = 0.5
end

function game:update(dt)
    self.time = self.time + dt

    if love.keyboard.isDown("space") then
        self.floating = math.min(1, self.floating + dt)
    else
        self.floating = math.max(0, self.floating - dt)
    end
end

function game:keypressed(key, code)

end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[48])

    local coordinates = self.curve:render(5)
    love.graphics.line(coordinates)

    local pos = (self.time * self.speed) % 1

    local x, y = self.curve:evaluate(pos)
    --love.graphics.circle('fill', x, y, 5)

    local dx, dy = self.derivative:evaluate(pos)
    local angle = math.atan2(dy, dx)

    local bound1 = vector(x + math.cos(angle + math.pi/2) * 20, y + math.sin(angle + math.pi/2) * 20)
    local bound2 = vector(x + math.cos(angle + math.pi*3/2) * 20, y + math.sin(angle + math.pi*3/2) * 20)

    local pos = (bound2 - bound1) * self.floating + bound1

    love.graphics.line(bound1.x, bound1.y, bound2.x, bound2.y)
    love.graphics.circle('fill', bound1.x, bound1.y, 3)
    love.graphics.circle('fill', bound2.x, bound2.y, 3)

    love.graphics.setColor(255, 255, 255)
    for i = 1, 50 do
        local x, y = self.curve:evaluate(i/50)

        local dx, dy = self.derivative:evaluate(i/50)
        local angle = math.atan2(dy, dx)

        local bound1 = vector(x + math.cos(angle + math.pi/2) * 20, y + math.sin(angle + math.pi/2) * 20)
        local bound2 = vector(x + math.cos(angle + math.pi*3/2) * 20, y + math.sin(angle + math.pi*3/2) * 20)
        
        love.graphics.circle('fill', bound1.x, bound1.y, 3)
        love.graphics.circle('fill', bound2.x, bound2.y, 3)
    end

    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', pos.x, pos.y, 3)
end