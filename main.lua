Class = require "lib/middleclass"
sprite_sheet = require "sprite_sheet"

screen = require("game_screen"):new()
speed = 0.6 --minus is faster.

local timer = 0

function love.load()
  love.window.setMode(800,600)
  love.window.setTitle("Moon Invaders")
end

function love.update(dt)
  timer = timer + dt
  if timer < speed then return else timer = 0 end
  screen:update(dt)
end

function love.draw()
  screen:draw()
end

function love.keypressed( key, scancode, isrepeat )
  if screen.keypressed then
    screen:keypressed( key, scancode, isrepeat )
  end
end
