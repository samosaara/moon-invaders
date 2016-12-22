local sprite_sheet = require("sprite_sheet")
local alien = require "alien"

local GameScreen = Class("GameScreen")

function GameScreen:draw()
  self.alien_grid:renderTo(love.graphics.clear)
  for y, alien_row in pairs(self.aliens) do
    for x, alien in pairs(alien_row) do
      alien:draw(self.alien_grid)
    end
  end
  love.graphics.draw(self.alien_grid)
end

--Called every *speed* seconds
function GameScreen:update(dt)
  for x, alien_row in pairs(self.aliens) do
    for y, a_alien in pairs(alien_row) do
      a_alien:update()
      if a_alien.x >= love.window.getWidth() - (alien.alien_sprites.cell_width + 10)
          or a_alien.x <= 5 then
        alien.static.direction = alien.direction * -1
        a_alien.x = a_alien.x + (alien.direction * 2)
        print('Different direction: ' .. alien.direction)
        self:_shift_down(5)
      end
    end
  end
end

function GameScreen:_shift_down (how_much)
  for x, alien_row in pairs(self.aliens) do
    for y, a_alien in pairs(alien_row) do
      a_alien.y = a_alien.y + how_much
    end
  end
end

function GameScreen:initialize ()
  local alien_width = alien.alien_sprites.cell_width
  local alien_height = alien.alien_sprites.cell_height
  self.alien_grid = love.graphics.newCanvas(
    love.window.getWidth(), (alien_height + 20) * 6
  )
  local aliens_per_row=(love.window.getWidth() / (alien_width + 10)) - 1
  local aliens = {}

  for y = 1, 6 do
    local alien_kind = math.ceil(3.5 - (y / 2))
    for x = 1, aliens_per_row do -- Alien rows
      aliens[x] = aliens[x] or {}
      aliens[x][y] = alien:new(alien_kind,
        x * (alien_width + 10), y * (alien_height + 10)
      )
    end
  end
  self.aliens = aliens
end

return GameScreen
