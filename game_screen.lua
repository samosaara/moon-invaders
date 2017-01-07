local sprite_sheet = require("sprite_sheet")
local Alien = require "alien"
local Player = require "player"
scale_factor = 1

local GameScreen = Class("GameScreen")

function GameScreen:draw()
  love.graphics.clear()
  self:draw_ui()
  love.graphics.draw(Player.sprite, self.player.x, self.player.y, 0, self.scale)
  love.graphics.setCanvas(self.collision_canvas)
  love.graphics.clear()
  local laser = self.player.laser
  if laser.x > 0 and laser.y > 0 then
    love.graphics.rectangle("fill", laser.x, laser.y, laser.width, laser.height)
    laser.y = laser.y - laser.speed
    if laser.y <= 0 then
      laser:reset()
    end
  end
  self.player.laser = laser
  love.graphics.setCanvas(self.alien_grid)
  love.graphics.clear()
  local true_width = Alien.alien_sprites.cell_width * scale_factor
  local true_height = Alien.alien_sprites.cell_height * scale_factor
  for x, alien_row in pairs(self.aliens) do
    for y, alien in pairs(alien_row) do
      local true_x = alien.x * scale_factor
      local true_y = alien.y * scale_factor
      if laser.x > true_x and laser.x < true_x + true_width  then
        if laser.y > true_y  and laser.y < true_y + true_height then
          print("DEAD")
          alien.disable = true
          alien.x = -true_width * 2
          alien.y = -true_height * 2
          -- TODO: SCORE
          if y >= 4 then self.score = self.score + 10 end
          if y >= 2 then self.score = self.score + 20 end
          if y == 1 then self.score = self.score + 30 end
          speed = speed - 0.02
          laser:reset()
        end
      end
      alien:draw()
    end
  end
  love.graphics.setCanvas(collision_canvas)
  love.graphics.draw(self.alien_grid,0, 0, 0, self.scale)
  love.graphics.setCanvas()
  love.graphics.draw(self.collision_canvas, 0, 0)
end

function GameScreen:draw_ui ()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  love.graphics.push()
  love.graphics.setFont(self.font)
  love.graphics.setColor(190, 190, 190)

  local top_text = "Score: < " .. self.score .. " >"
  love.graphics.print(top_text , width / 4, 0)

  love.graphics.setColor(250, 250, 250)
  love.graphics.pop()
end

--Called every *speed* seconds
function GameScreen:update(dt)
  local last
  for x, alien_row in pairs(self.aliens) do
    for y, a_alien in pairs(alien_row) do
      if not a_alien.disable then a_alien:update() end
      last = a_alien
    end
  end
  if last.x >= (self.alien_grid:getWidth() - (Alien.alien_sprites.cell_width + 10))
      or self.aliens[1][1].x <= 5 then
    Alien.static.direction = Alien.direction * -1
    print('Different direction: ' .. Alien.direction)
    self:_shift_down(5)
  end
end

function GameScreen:_shift_down (how_much)
  for x, alien_row in pairs(self.aliens) do
    for y, a_alien in pairs(alien_row) do
      a_alien.y = a_alien.y + how_much
    end
  end
end

function GameScreen:keypressed( key, scancode, isrepeat )
  if not self.player:move(key) then
    if key == " " or key == "space" then -- Cuz windows yes.
      self.player:shoot()
    end
  end
end

function GameScreen:initialize ()
  self.score = 0
  local alien_width = Alien.alien_sprites.cell_width
  local alien_height = Alien.alien_sprites.cell_height
  self.alien_grid = love.graphics.newCanvas(
    (alien_width + 10) * 13, (alien_height + 20) * 8
  )
  self.collision_canvas = love.graphics.newCanvas()
  self.font = love.graphics.newFont("resources/LCD_Solid.ttf", 36)

  self.player = Player:new()

  --local aliens_per_row=(self.alien_grid:getWidth() / (alien_width + 10))
  local aliens = {}

  for y = 1, 5 do
    local alien_kind = math.floor((y / 2)) + 1
    for x = 1, 11 do -- Alien rows
      aliens[x] = aliens[x] or {}
      aliens[x][y] = Alien:new(alien_kind,
        (x - 1) * (alien_width + 10) + 5, y * (alien_height + 10) + 40
      )
    end
  end
  self.aliens = aliens
  local max = math.max(self.alien_grid:getWidth(), love.graphics.getWidth())
  local min = math.min(self.alien_grid:getWidth(), love.graphics.getWidth())
  self.scale = (min * 100) / max
  self.scale = self.scale / 100
  scale_factor = self.scale
  print(self.scale)
end

return GameScreen
