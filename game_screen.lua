local sprite_sheet = require("sprite_sheet")
local alien = require "alien"
local Player = require "player"
scale_factor = 1

local GameScreen = Class("GameScreen")

function GameScreen:draw()
  love.graphics.clear()
  love.graphics.setCanvas(self.alien_grid)
  love.graphics.clear()

  for y, alien_row in pairs(self.aliens) do
    for x, alien in pairs(alien_row) do
      alien:draw()
    end
  end
  love.graphics.setCanvas()
  love.graphics.draw(self.alien_grid,0, 0, 0, self.scale)
  self:draw_ui()
  love.graphics.draw(Player.sprite, self.player.x, self.player.y, 0, self.scale)
  local laser = self.player.laser
  if laser.x > 0 and laser.y > 0 then
    love.graphics.rectangle("fill", laser.x, laser.y, laser.width, laser.height)
    laser.y = laser.y - laser.speed
    if laser.y <= 0 then
      laser.x = -1
      laser.y = -1
    end
  end
  self.player.laser = laser
end

function GameScreen:draw_ui ()
  local width = love.window.getWidth()
  local height = love.window.getHeight()

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
      a_alien:update()
      last = a_alien
    end
  end
  if last.x >= (self.alien_grid:getWidth() - (alien.alien_sprites.cell_width + 10))
      or self.aliens[1][1].x <= 5 then
    alien.static.direction = alien.direction * -1
    print('Different direction: ' .. alien.direction)
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

function GameScreen:keypressed( key, isrepeat )
  if not self.player:move(key) then
    if key == " " then
      self.player:shoot()
    end
  end
end

function GameScreen:initialize ()
  self.score = 42
  local alien_width = alien.alien_sprites.cell_width
  local alien_height = alien.alien_sprites.cell_height
  self.alien_grid = love.graphics.newCanvas(
    (alien_width + 10) * 13, (alien_height + 20) * 8
  )
  self.font = love.graphics.newFont("resources/LCD_Solid.ttf", 36)

  self.player = Player:new()

  --local aliens_per_row=(self.alien_grid:getWidth() / (alien_width + 10))
  local aliens = {}

  for y = 1, 5 do
    local alien_kind = math.floor((y / 2)) + 1
    for x = 1, 11 do -- Alien rows
      aliens[x] = aliens[x] or {}
      aliens[x][y] = alien:new(alien_kind,
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
