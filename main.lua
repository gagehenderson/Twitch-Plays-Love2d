require "Modules.App"

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
function love.mousepressed(x, y, button)
    App:mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
    App:mousereleased(x, y, button)
end
function love.resize(w, h)
    App:resize(w, h)
end
function love.wheelmoved(x,y)
    App:wheelmoved(x,y)
end
function love.quit()
    App:quit()
end
