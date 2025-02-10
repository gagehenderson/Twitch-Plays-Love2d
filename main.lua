require "App"

function love.load()
    App:load()
end
function love.update(dt)
    App:update(dt)
end
function love.draw()
    App:draw()
end
function love.keypressed(key)
    App:keypressed(key)
end
function love.textinput(text)
    App:textinput(text)
end
function love.resize(w, h)
    App:resize(w, h)
end
