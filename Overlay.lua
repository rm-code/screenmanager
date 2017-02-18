local ScreenManager = require( 'ScreenManager' )
local Screen = require( 'Screen' )

local Overlay = {}

function Overlay.new()
    local self = Screen.new() -- Note how we inherit from the Screen class.

    local x, y, w, h, str, font

    function self:init( nstr )
        x, y, w, h = 0, 0, love.graphics.getDimensions()
        str, font = nstr, love.graphics.newFont( 20 )
        love.graphics.setFont( font )
    end

    function self:draw()
        love.graphics.setColor( 0, 0, 0, 100 )
        love.graphics.rectangle( 'fill', x, y, w, h )
        love.graphics.setColor( 255, 255, 255, 255 )
        love.graphics.print( str, w * 0.5 - font:getWidth( str ) * 0.5, h * 0.5 )
    end

    function self:keypressed( key )
        if key == 'escape' then
            -- Removes the topmost screen, so in this case the overlay itself.
            ScreenManager.pop()
        elseif key == 'n' then
           -- Closes all screens (close() function will be called) and creates a new screen.
            ScreenManager.switch( 'main' )
        end
    end

    return self
end

return Overlay
