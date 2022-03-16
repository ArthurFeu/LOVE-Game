gamestate = "title"
-- sound assets
music = love.audio.newSource("assets/music.wav", "stream")
button = love.audio.newSource("assets/pause-start.wav", "static")
lose = love.audio.newSource("assets/lose.wav", "static")
coin1 = love.audio.newSource("assets/coin1.wav", "static")
coin2 = love.audio.newSource("assets/coin2.wav", "static")
hit = love.audio.newSource("assets/hit.wav", "static")

-- my computer screen dimensions
heigh = 768
width = 1360

function love.load()
    -- basic load for each object
    love.window.setFullscreen(true, "desktop")
    player = {}
    player.x = love.math.random(50, 100)
    player.y = 300
    player.life = 1000
    player.points = 0

    coin = {}
    coin.x = love.math.random(width/2, width - 100)
    coin.y = love.math.random(heigh/2, heigh - 50)
    coin.state = false

    enemy = {}
    enemy.x = love.math.random(width*3/4, width)
    enemy.y = love.math.random(heigh*3/4, heigh)

    chest = {}
    chest.x = 150
    chest.y = 150
end

function love.draw()
    music:play()
    if gamestate == "title" then
        music:setVolume(1)
        -- start menu
        love.graphics.printf(" Arcade LOVE Game ", 640, 220, 100, "center")
        love.graphics.setColor(1, 1, 0.9)
        love.graphics.printf(" Press 's' to Start ", 640, 360, 100, "center")
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.printf(" Press 'e' to Exit ", 640, 420, 100, "center")
        love.graphics.setColor(1, 1, 0.7)
        love.graphics.printf(" Move around with the arrow keys, avoid the enemy and carry the coins into the chest! You can press 'p' to pause the game", 540, 270, 300, "center")
        love.graphics.setColor(1, 1, 0.3)
    elseif gamestate == "play" then
        -- play screen
        music:setVolume(1)
        love.graphics.setBackgroundColor(0.5,0.5,1)

        love.graphics.printf(player.points, 155, 155, 100, "center")

        love.graphics.setColor(1, 0, 0)
        love.graphics.printf(player.life, width-250, 155, 100, "center")

        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Your Health: ", width-310, 155, 100, "center")

	    love.graphics.setColor(1, 1, 0.5)
	    love.graphics.rectangle("fill", player.x, player.y, 40, 40)

        love.graphics.setColor(0.3, 1, 0.3)
	    love.graphics.rectangle("fill", enemy.x, enemy.y, 70, 70)

        love.graphics.setColor(0.4, 0.1, 0)
        love.graphics.rectangle("fill", coin.x, coin.y, 20, 20)

        love.graphics.setColor(0.4, 0.4, 0.8) --player and chest color
        love.graphics.rectangle("fill", chest.x, chest.y, 33, 65)

    elseif gamestate == "paused" then
        -- pause screen
        music:setVolume(0)
        love.graphics.setBackgroundColor(0.5,0.5,1)
        love.graphics.printf(" The Game's Paused! Press 's' to comeback ", 640, 360, 100, "center")
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.printf(" Press 'e' to Exit ", 640, 420, 100, "center")
        love.graphics.setColor(1, 1, 0.7)

    elseif gamestate == "loser" then
        music:setVolume(0)
        love.graphics.printf(" You Lost! Your final score is: ", 640, 360, 100, "center")
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.printf(player.points, 640, 400, 100, "center")
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.printf(" Press 's' to play again ", 640, 440, 100, "center")
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.printf(" Press 'e' to Exit ", 640, 500, 100, "center")
        love.graphics.setColor(1, 1, 0.7)
    end
end

function love.update(dt)
    if gamestate == "title" then
        if love.keyboard.isDown('s') then
            button:play()
            gamestate = "play"
        end
        if love.keyboard.isDown('e') then
            button:play()
            music:setVolume(0)
            love.window.close()
        end
    elseif gamestate == "play" then
        -- the game itself
        -- player movement
        if love.keyboard.isDown('p') then
            button:play()
            gamestate = "paused"
        end
        if love.keyboard.isDown('up') then
            player.y = player.y - 0.6
        end
        if love.keyboard.isDown('left') then
            player.x = player.x - 0.7
        end
        if love.keyboard.isDown('down') then
            player.y = player.y + 0.6
        end
        if love.keyboard.isDown('right') then
            player.x = player.x + 0.7
        end

        -- enemy movement
        if enemy.x > player.x then
            enemy.x = enemy.x - 0.4
        elseif enemy.x < player.x then
            enemy.x = enemy.x + 0.4
        elseif enemy.x == player.x then
            enemy.x = enemy.x
        end
        if enemy.y > player.y then
            enemy.y = enemy.y - 0.4
        elseif enemy.y < player.y then
            enemy.y = enemy.y + 0.4
        elseif enemy.y == player.y then
            enemy.y = enemy.y
        end

        -- coin collision with the player
        if coin.state == false then
            if (((coin.x >= player.x) and (coin.x <= player.x + 20)) and ((coin.y >= player.y) and (coin.y <= player.y + 20))) then
                coin1:play()
                coin.state = true
            end
        end
        if coin.state == true then
            coin.x = player.x + 10
            coin.y = player.y + 10
        end
        -- coin collect and respawn
        if (coin.state == true) and (((player.x >= chest.x) and (player.x <= chest.x + 35)) and ((player.y >= chest.y) and (player.y <= chest.y + 70))) then
            player.points = player.points + 10
            coin.state = false
            coin2:play()
            coin.x = love.math.random(300, width - 200)
            coin.y = love.math.random(50, heigh - 100)
        end

        -- wall collision
        if player.x <= 0 then
            player.x = player.x + 1
        end
        if (player.x >= width - 40) then
            player.x = player.x - 1
        end
        if player.y <= 0 then
            player.y = player.y + 1
        end
        if (player.y >= heigh - 40) then
            player.y = player.y - 1
        end

        -- player and enemy collision
        if (((player.x >= enemy.x) and (player.x <= enemy.x + 70)) and ((player.y >= enemy.y) and (player.y <= enemy.y + 70))) then
            player.life = player.life - 1
            hit:play()
        end

        -- other screens:
        if player.life <= 0 then
            lose:play()
            gamestate = "loser"
        end
    elseif gamestate == "paused" then
        enemy.x = enemy.x
        enemy.y = enemy.y
        if love.keyboard.isDown('s') then
            button:play()
            gamestate = "play"
            player.life = player.life
            player.points = player.points
        end
        if love.keyboard.isDown('e') then
            button:play()
            love.window.close()
        end
    elseif gamestate == "loser" then
        player.life = 1000
        if love.keyboard.isDown('e') then
            button:play()
            love.window.close()
        end
        if love.keyboard.isDown('s') then
            button:play()
            gamestate = "play"
            player.points = 0
            enemy.x = love.math.random(width*3/4, width)
            enemy.y = love.math.random(heigh*3/4, heigh)
            coin.x = love.math.random(width/2, width - 100)
            coin.y = love.math.random(heigh/2, heigh - 50)
            player.x = love.math.random(50, 100)
            player.y = 300
        end
    end
end
