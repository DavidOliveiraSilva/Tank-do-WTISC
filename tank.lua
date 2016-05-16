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

function tank:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x, self.y, self.raio)

	local x_cano = self.x + self.size*math.cos(self.angle)
	local y_cano = self.y + self.size*math.sin(self.angle)	

	love.graphics.setLineWidth(5)
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(self.x, self.y, x_cano, y_cano)
	for i = 1, #self.bullets do
		self.bullets[i]:draw()
	end

end

function tank:update(dt)
	self.x = self.x + self.speed*self.vx*dt
	self.y = self.y + self.speed*self.vy*dt
	self.angle = math.atan2(love.mouse.getY() - self.y,
		                    love.mouse.getX() - self.x)

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

end

function tank:shot()
	table.insert(self.bullets, bullet:new({x = self.x, 
		y = self.y, angle = self.angle}))
end

function fora_da_tela(x, y)
	if x < 0 or x > width or y < 0 or y > height then
		return true
	end
end