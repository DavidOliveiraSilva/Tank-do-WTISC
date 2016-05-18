bullet = class:new()
bullet.x = 0
bullet.y = 0
bullet.speed = 1000
bullet.angle = 0
bullet.raio = 10

function bullet:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('fill', self.x, self.y, self.raio)
end

function bullet:update(dt)
    self.x = self.x + dt*self.speed*math.cos(self.angle)
    self.y = self.y + dt*self.speed*math.sin(self.angle)
end

tank = {}
tank.x = width/2
tank.y = height/2
tank.vx = 0
tank.vy = 0
tank.speed = 300
tank.raio = 40
tank.color = {0, 0, 255}
tank.angle = 0
tank.size = 60
tank.bullets = {}
tank.health = 100
tank.pontuacao = 0

function tank:draw()
    love.graphics.setColor(self.color)
    --love.graphics.circle("fill", self.x, self.y, self.raio)
    love.graphics.draw(ufo, self.x, self.y, self.angle*2, self.raio*2/32, self.raio*2/32, 16, 16)
    local x_cano = self.x + self.size*math.cos(self.angle)
    local y_cano = self.y + self.size*math.sin(self.angle)  

    love.graphics.setLineWidth(5)
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(self.x, self.y, x_cano, y_cano)
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
    love.graphics.setColor(0, 0, 0)
    local pont = string.format("%d", self.pontuacao)
    love.graphics.print(pont, width - 0.5*myfont:getWidth(pont), 0, 0, 0.5, 0.5)
    
    if self.health >= 0 then
        if self.health > 50 then
            love.graphics.setColor(0, 200, 0)
        elseif self.health > 20 then
            love.graphics.setColor(200, 200, 0)
        else
            love.graphics.setColor(255, 0, 0)
        end
        love.graphics.rectangle("fill", 0, 0, 2*self.health, 20, 10)
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 0, 0, 200, 20, 10)
end

function tank:update(dt)
    if self.health <= 0 then
        game_over = true
        go_song:play()
        musica:stop()
    end
    self.x = self.x + self.speed*self.vx*dt
    self.y = self.y + self.speed*self.vy*dt
    self.angle = math.atan2(love.mouse.getY() - self.y,
                            love.mouse.getX() - self.x)
    if self.x < self.raio then
        self.x = self.raio
    end
    if self.x > width - self.raio then
        self.x = width - self.raio
    end
    if self.y < self.raio then
        self.y = self.raio
    end
    if self.y > height - self.raio then
        self.y = height - self.raio
    end
    for i = 1, #self.bullets do
        self.bullets[i]:update(dt)
    end
    for i = 1, #self.bullets do
        if fora_da_tela(self.bullets[i].x,
            self.bullets[i].y) then
            table.remove(self.bullets, i)
            break
        end
    end
    for i = 1, #controle_meteoro.bullets do
        local xm = controle_meteoro.bullets[i].x
        local ym = controle_meteoro.bullets[i].y
        local rm = controle_meteoro.bullets[i].raio
        local sm = controle_meteoro.bullets[i].speed
        if distance(tank.x, tank.y, xm, ym) <= self.raio + rm then
            local explosion = exp:clone()
            explosion:play()
            self.health = self.health - rm/10
            controle_meteoro.bullets[i].death = true
        end
        for j = 1, #self.bullets do
            if distance(self.bullets[j].x, 
                self.bullets[j].y, xm, ym) <= self.bullets[j].raio + rm then
                self.pontuacao = self.pontuacao + 1
                controle_meteoro.bullets[i].death = true
                
                controle_meteoro:explodir(i)
                table.remove(self.bullets, j)
                break
            end
        end
    end

end  

function tank:shot()
    local p = pew:clone()
    p:play()
    table.insert(self.bullets, bullet:new({x = self.x, 
        y = self.y, angle = self.angle}))
end

function fora_da_tela(x, y)
    if x < 0 or x > width or y < 0 or y > height then
        return true
    end
end

meteoro = class:new()
meteoro.x = 0
meteoro.y = 0
meteoro.speed = 1000
meteoro.angle = 0
meteoro.raio = 25
meteoro.death = false
meteoro.color = {255, 0, 0}

function meteoro:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.raio)
end

function meteoro:update(dt)
    self.x = self.x + dt*self.speed*math.cos(self.angle)
    self.y = self.y + dt*self.speed*math.sin(self.angle)
end

controle_meteoro = {}
controle_meteoro.bullets = {}
controle_meteoro.freq = 0.3
controle_meteoro.temp = 0
controle_meteoro.last_m = 0

function controle_meteoro:draw()
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
end
function controle_meteoro:explodir(i, max)
    local explosion = exp:clone()
    explosion:play()
    if not max then
        max = 7
    end
    local xm = self.bullets[i].x
    local ym = self.bullets[i].y
    local rm = self.bullets[i].raio
    local limit = love.math.random(1+max)
    local d_angle = math.pi/limit
    for k = 3, limit do
        table.insert(controle_meteoro.bullets, 
            meteoro:new({x = xm + rm*math.cos(k*d_angle), y = ym + rm*math.sin(k*d_angle), speed = 300 + k*50, angle = k*d_angle, raio = rm/2}))
    end
end
function controle_meteoro:update(dt)
    for i = 1, #self.bullets do
        self.bullets[i]:update(dt)
    end
    for i = 1, #self.bullets do
        if self.bullets[i].death then
            table.remove(self.bullets, i)
            break
        end
    end
    self.temp = self.temp + dt
    if self.temp - self.last_m >= self.freq then
        self:shot()
        self.last_m = self.temp
    end
    
end

function controle_meteoro:shot()
    local x_rand = love.math.random(width)
    local speed_rand = 400 + love.math.random(300)
    local angle_rand = math.atan2(tank.y + 20, tank.x - x_rand)
    angle_rand = angle_rand + love.math.random() - 0.5
    table.insert(self.bullets, 
        meteoro:new({x = x_rand, y = -20, speed = speed_rand, angle = angle_rand}))
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end