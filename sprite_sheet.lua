local ss = Class('SpriteSheet')

function ss:initialize (rows, columns, filename)
  if type(filename) == "string" then
    self.sheet = love.graphics.newImage(filename)
  end

  self.rows = rows
  self.columns = columns

  self.cell_width = self.sheet:getWidth() / columns
  self.cell_height = self.sheet:getHeight() / rows
  self.sheets = {}

  for x = 1, columns do
    for y = 1, rows do
      self.sheets[y] = self.sheets[y] or {}
      self.sheets[y][x] = love.graphics.newQuad(
        (x - 1) * self.cell_width, (y - 1) * self.cell_height,
        self.cell_width, self.cell_height,
        self.sheet:getDimensions()
      )
    end
  end
end

return ss
