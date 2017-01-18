local ScreenManager = require( 'ScreenManager' )

function love.load()
    -- This list specifies all screens our ScreenManager can create and use.
    -- We can use it later by creating a screen via `ScreenManager:push( str )`.
    local screens = {
        ['main']    = require( 'MainScreen' ),
        ['overlay'] = require( 'Overlay' )
    };

    -- Apply the list to the ScreenManager and create the first screen.
    ScreenManager.init( screens, 'main' )
end

-- As you can see all love callbacks are simply redirected to the screens in
-- the ScreenManager library.
function love.draw()
    ScreenManager.draw()
end

function love.update( dt )
    ScreenManager.update( dt )
end

function love.keypressed( key )
    ScreenManager.keypressed( key )
end
