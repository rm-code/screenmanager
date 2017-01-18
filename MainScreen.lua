local ScreenManager = require( 'ScreenManager' )
local Screen = require( 'Screen' )

local MainScreen = {}

function MainScreen.new()
    local self = Screen.new()

    local objects = {}
    local w, h = love.graphics.getDimensions()
    local font = love.graphics.newFont( 20 )
    love.graphics.setFont( font )

    local function rndSign()
        return love.math.random() < 0.5 and -1 or 1
    end

    -- The init function is always called right before a new screen is created
    -- and should be used for initialisation.
    function self:init()
        for _ = 1, 20  do
            local new = {}
            new.x  = love.math.random( 10, w - 10 )
            new.y  = love.math.random( 10, h - 10 )
            new.dx = love.math.random( 1, 5 ) * rndSign()
            new.dy = love.math.random( 1, 5 ) * rndSign()
            new.col = { love.math.random( 255 ), love.math.random( 255 ), love.math.random( 255 ) }
            objects[#objects + 1] = new
        end
    end

    function self:draw()
        for _, obj in ipairs( objects ) do
            love.graphics.setColor( obj.col )
            if not self:isActive() then
                love.graphics.setColor( 255, 255, 255, 100 )
            end
            love.graphics.setPointSize( 5 )
            love.graphics.points( obj.x, obj.y )
        end
        love.graphics.setColor( 255, 255, 255, 255 )
        love.graphics.print( 'Press p to activate the overlay!', 5, 5 );
    end

    function self:update()
        for i = 1, #objects do
            local obj = objects[i]

            -- The isActive function can be used to apply certain effects to
            -- the current screen if it isn't the active screen. You could use
            -- this to pause the actual game while certain animations while
            -- the player is in the pause menu.
            if self:isActive() then
                obj.x, obj.y = obj.x + obj.dx, obj.y + obj.dy
            else
                obj.x, obj.y = obj.x + obj.dx * 0.5, obj.y + obj.dy * 0.5
            end

            if ( obj.x > w and obj.dx > 0 ) or ( obj.x < 0 and obj.dx < 0 ) then
                obj.dx = -obj.dx
            elseif ( obj.y > h and obj.dy > 0 ) or ( obj.y < 0 and obj.dy < 0 ) then
                obj.dy = -obj.dy
            end
        end
    end

    function self:keypressed( key )
        if key == 'p' then
            -- The push function creates a new screen and puts it on top of the
            -- screen stack. As you can see this allows us to create overlays.
            -- For example imagine a transparent map overlay which can be displayed
            -- without having to pause the actual game.
            -- The 'Game paused' string will be passed to the init function of
            -- the overlay screen.
            ScreenManager.push( 'overlay', 'Game paused' )
        end
    end

    return self
end

return MainScreen
