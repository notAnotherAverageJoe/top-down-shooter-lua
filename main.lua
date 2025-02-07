function love.load()
    -- make a sprite table to hold all the graphics we will use
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    -- same for the player. this allows all things relating to the player to be controlled from  one table
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 200

    zombies ={}
    bullets = {}

end

function love.update(dt)
    -- each of these monitor for key presses
   if love.keyboard.isDown("d") then
    player.x = player.x + player.speed*dt
   end
   if love.keyboard.isDown("a") then
    player.x = player.x - player.speed*dt
   end
   if love.keyboard.isDown("w") then
    player.y = player.y - player.speed*dt
   end
   if love.keyboard.isDown("s") then
    player.y = player.y + player.speed*dt
   end

   for i,z in ipairs(zombies) do
    -- z.x = z.x + 3 this line would have all zombies moving right, could
    -- use a similar structure for falling items
    -- this allows the zombie move toward the player
    z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed *dt
    z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed *dt

        if distanceBetween(z.x, z.y, player.x,player.y) < 30 then
            for i,z in ipairs(zombies)do
                zombies[i] = nil
            end

        end
    end
    for i,b in ipairs(bullets)do
        b.x = b.x + math.cos(b.direction) * b.speed *dt
        b.y = b.y + math.sin(b.direction) * b.speed *dt
        
    end
    -- This loop is focusing on deleting bullets once they would go off screen
    -- it starts from the end of the table and works towards the first,
    -- hence why its bullets, 1, -1 - it starts at the end and works towards 1 
    for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
-- nested loop to check each zombie looking for each bullet

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x,z.y,b.x,b.y) < 20 then
                z.dead = true
                b.dead = true

            end
        end
    end
    -- both of these loops are checking each zombie or bullet and looking for a bool on dead
    -- if bullet or zombie have been marked as dead they that index in this loops is removed
    -- from the table
    for i=#zombies,1,-1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end
    for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end
end


function love.draw()
    love.graphics.draw(sprites.background,0,0)
    --atan2(y1-y2,x1-x2) to find the radian value
    -- this allows the sprites image height and width and / 2 to center it
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil,nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
-- lua does not start at 0, it starts at 1
    for i,z in ipairs(zombies) do
        -- z holds the values for each zombie in the table
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil,nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)


    end
    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil,0.5, nil, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end
-- only activates once when pressed, isdown keeps running a
-- as long as the key is held
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end
function love.mousepressed(x,y,button)
    if button == 1 then
        spawnBullet()
    end
end
function playerMouseAngle()
    return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x )
end
-- pass in a zombie object
function zombiePlayerAngle(enemy)
    return math.atan2( player.y - enemy.y, player.x - enemy.x )
end


function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 140
    zombie.dead = false



    local side = math.random(1,4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth()+30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = 


    end

    table.insert(zombies, zombie)

end

function distanceBetween(x1,y1,x2,y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function spawnBullet()
    local bullet ={}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    -- this will have the bullet come from player and fly to the mouse
    bullet.direction = playerMouseAngle()
    table.insert(bullets,bullet)
end