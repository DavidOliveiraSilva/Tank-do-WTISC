function love.load()
    width = 800
    height = 600
    plano_de_fundo = {255, 255, 255}

    require "class"
    require "tank"

    myfont = love.graphics.newFont("papercuts.ttf", 160)
    love.graphics.setFont(myfont)
    love.window.setMode(width, height)
    love.window.setTitle("tank do wtisc")
    love.graphics.setBackgroundColor(plano_de_fundo)

    game_over = false
    go_msg = "YOU DIED"
end

function love.update(dt)
    if not game_over then
        tank:update(dt)
        controle_meteoro:update(dt)
    end
end

function love.draw()
    tank:draw()
    controle_meteoro:draw()
    if game_over then
        love.graphics.setColor(255, 0, 0)
        love.graphics.print(go_msg, width/2, height/2, 0, 1, 1, 
            myfont:getWidth(go_msg)/2, myfont:getHeight()/2)
    end
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
    if key == 'space' then
        game_over = false
        tank.health = 100
        tank.pontuacao = 0
        tank.x = width/2
        tank.y = height/2
        controle_meteoro.bullets = {}
        tank.bullets = {}
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