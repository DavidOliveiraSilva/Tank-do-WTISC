function love.load()
	width = 800
	height = 600
	plano_de_fundo = {255, 255, 255}

	require "class"
	require "tank"

	love.window.setMode(width, height)
	love.window.setTitle("tank do wtisc")
	love.graphics.setBackgroundColor(plano_de_fundo)
end

function love.update(dt)
	tank:update(dt)


end

function love.draw()
	tank:draw()


end

function love.mousepressed(mx, my, key)
	if key == 1 then
		tank:shot()
	end
end

function love.keypressed(key)
	if key == 'd' then
		tank.vx = tank.vx + 1
	end
	if key == 'a' then
		tank.vx = tank.vx - 1
	end
	if key == 's' then
		tank.vy = tank.vy + 1
	end
	if key == 'w' then
		tank.vy = tank.vy - 1
	end
end

function love.keyreleased(key)
	if key == 'd' then
		tank.vx = tank.vx - 1
	end
	if key == 'a' then
		tank.vx = tank.vx + 1
	end
	if key == 's' then
		tank.vy = tank.vy - 1
	end
	if key == 'w' then
		tank.vy = tank.vy + 1
	end

end