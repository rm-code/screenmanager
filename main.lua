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

    -- Register the ScreenManager functions to the LÖVE callbacks so that
    -- they will be called automagically.
    ScreenManager.registerCallbacks()
end
