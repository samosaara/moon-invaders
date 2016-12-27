local Player = Class("Player")

Player.static.sprite = love.graphics.newImage("resources/player.png")
Player.static.move_speed = 5

function Player:initialize ()
  self.x = (love.window.getWidth() / 2) - (Player.sprite:getWidth() / 2)
  self.y = love.window.getHeight() * 0.9
  self.laser = {x = -1, y = -1, width = 5, height = 20, speed = 4}
end

function Player:shoot ()
  print("trying to lasor: x: " .. self.laser.x .. " y: " .. self.laser.y)
  if self.laser.x < 0 and self.laser.y < 0 then
    print("IMMA SHOOT MAH LASOOOOOOOOOR")
    self.laser.x = (self.x + 
      (Player.sprite:getWidth() * scale_factor) / 2 - (self.laser.width / 2)
    )
    self.laser.y = self.y - (Player.sprite:getHeight() * scale_factor) / 2
  end
end

function Player:move (direction)
  if direction == "right" then
    local left_edge = self.x + Player.sprite:getWidth()
    if (left_edge + Player.move_speed) < love.window.getWidth() then
      self.x = self.x + Player.move_speed
      return true
    end
  elseif direction == "left" then
    if (self.x - Player.move_speed) > 5 then
      self.x = self.x - Player.move_speed
      return true
    end
  end
  return false
end

return Player
