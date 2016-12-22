local alien = Class("Alien")

alien.static.alien_sprites = sprite_sheet:new(3, 2, "resources/spc_spritesheet.png")
alien.static.direction = 5

function alien:initialize (type, x, y)
  self._frame = 1
  self.x = x
  self.y = y
  self.type = type
  print("New alien, type: " .. type .. " x: " .. x .. " y: " .. y)
  self.sprite = alien.alien_sprites.sheets[type][self._frame]
end

function alien:draw (canvas)
  if canvas then love.graphics.setCanvas(canvas) end
  love.graphics.draw(alien.alien_sprites.sheet, self.sprite, self.x, self.y)
  love.graphics.setCanvas()
end

function alien:update ()
  if self._frame >= 2 then self._frame = 1 else self._frame = 2 end
  --print(" is the sheet row and the index is: ".. self.type )
  self.sprite = alien.alien_sprites.sheets[self.type][self._frame]
  self.x = self.x + alien.direction
end

return alien
