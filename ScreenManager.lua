--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local ScreenManager = {
    _VERSION     = '1.7.0',
    _DESCRIPTION = 'Screen/State Management for the LÖVE framework',
    _URL         = 'https://github.com/rm-code/screenmanager/',
};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local stack;
local screens;

-- ------------------------------------------------
-- Private Functions
-- ------------------------------------------------

---
-- Close and remove all screens from the stack.
--
local function clear()
    for i = 1, #stack do
        stack[i]:close();
        stack[i] = nil;
    end
end

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Initialise the ScreenManager. This pushes the first
-- screen to the stack.
-- @param nscreens - The list of possible screens.
-- @param screen - The first screen to push to the stack.
--
function ScreenManager.init( nscreens, screen )
    stack = {};
    screens = nscreens;
    ScreenManager.push( screen );
end

---
-- Clears the ScreenManager, creates a new screen and switches
-- to it. Use this if you don't want to stack onto other screens.
--
-- @param nscreen
--
function ScreenManager.switch( screen, ... )
    clear();
    ScreenManager.push( screen, ... );
end

---
-- Creates a new screen and pushes it on the screen stack, where
-- it will overlay all the other screens.
-- Screens below the this new screen will be set inactive.
--
-- @param screen - The name of the screen to push on the stack.
--
function ScreenManager.push( screen, ... )
    -- Deactivate the previous screen if there is one.
    if ScreenManager.peek() then
        ScreenManager.peek():setActive( false );
    end

    -- Push the new screen onto the stack.
    if screens[screen] then
        stack[#stack + 1] = screens[screen].new();
    else
        local str = "{";
        for i, _ in pairs( screens ) do
            str = str .. i .. ', ';
        end
        str = str .. "}";
        error('"' .. screen .. '" is not a valid screen. You will have to add a new one to your screen list or use one of the existing screens: ' .. str);
    end

    -- Create the new screen and initialise it.
    stack[#stack]:init( ... );
end

---
-- Returns the screen on top of the screen stack without removing it.
--
function ScreenManager.peek()
    return stack[#stack];
end

---
-- Removes the topmost screen of the stack.
--
function ScreenManager.pop()
    if #stack > 1 then
        -- Close the currently active screen.
        local tmp = ScreenManager.peek();

        -- Remove the now inactive screen from the stack.
        stack[#stack] = nil;

        -- Close the previous screen.
        tmp:close();

        -- Activate next screen on the stack.
        ScreenManager.peek():setActive( true );
    else
        error("Can't close the last screen. Use switch() to clear the screen manager and add a new screen.");
    end
end

-- ------------------------------------------------
-- LOVE Callbacks
-- ------------------------------------------------

---
-- Callback function triggered when a directory is dragged and dropped onto the window.
-- @param file - The full platform-dependent path to the directory.
--
function ScreenManager.directorydropped( path )
    ScreenManager.peek():directorydropped( path );
end

---
-- Draw all screens on the stack. Screens that are higher on the stack
-- will overlay screens that are on the bottom.
--
function ScreenManager.draw()
    for i = 1, #stack do
        stack[i]:draw();
    end
end

---
-- Callback function triggered when a file is dragged and dropped onto the window.
-- @param file - The unopened File object representing the file that was dropped.
--
function ScreenManager.filedropped( file )
    ScreenManager.peek():filedropped( file );
end

---
-- Update all screens on the stack whenever the game window gains or
-- loses focus.
-- @param nfocus
--
function ScreenManager.focus( nfocus )
    for i = 1, #stack do
        stack[i]:focus( nfocus );
    end
end

---
-- Callback function triggered when a key is pressed.
-- @param key - Character of the pressed key.
-- @param scancode - The scancode representing the pressed key.
-- @param isrepeat - Whether this keypress event is a repeat. The delay between key repeats depends on the user's system settings.
--
function ScreenManager.keypressed(  key, scancode, isrepeat )
    ScreenManager.peek():keypressed( key, scancode, isrepeat);
end

---
-- Callback function triggered when a keyboard key is released.
-- @param key - Character of the released key.
-- @param scancode - The scancode representing the released key.
--
function ScreenManager.keyreleased( key, scancode )
    ScreenManager.peek():keyreleased( key, scancode );
end

---
-- Callback function triggered when the system is running out of memory on mobile devices.
--
function ScreenManager.lowmemory()
    ScreenManager.peek():lowmemory();
end

---
-- Reroute the mousefocus callback to the currently active screen.
-- @param focus - Wether the window has mouse focus or not.
--
function ScreenManager.mousefocus( focus )
    ScreenManager.peek():mousefocus( focus );
end

---
-- Callback function triggered when the mouse is moved.
-- @param x - Mouse x position.
-- @param y - Mouse y position.
-- @param dx - The amount moved along the x-axis since the last time love.mousemoved was called.
-- @param dy - The amount moved along the y-axis since the last time love.mousemoved was called.
--
function ScreenManager.mousemoved( x, y, dx, dy )
    ScreenManager.peek():mousemoved( x, y, dx, dy );
end

---
-- Callback function triggered when a mouse button is pressed.
-- @param x - Mouse x position, in pixels.
-- @param y - Mouse y position, in pixels.
-- @param button - The button index that was pressed. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependant.
-- @param istouch - True if the mouse button press originated from a touchscreen touch-press.
--
function ScreenManager.mousepressed( x, y, button, istouch )
    ScreenManager.peek():mousepressed( x, y, button, istouch );
end

---
-- Callback function triggered when a mouse button is released.
-- @param x - Mouse x position, in pixels.
-- @param y - Mouse y position, in pixels.
-- @param button - The button index that was released. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependant.
-- @param istouch - True if the mouse button release originated from a touchscreen touch-release.
--
function ScreenManager.mousereleased( x, y, button, istouch )
    ScreenManager.peek():mousereleased( x, y, button, istouch );
end

---
-- Reroute the quit callback to the currently active screen.
-- @param dquit - Abort quitting. If true, do not close the game.
--
function ScreenManager.quit( dquit )
    ScreenManager.peek():quit( dquit );
end

---
-- Called when the window is resized, for example if the user resizes the window, or if love.window.setMode is called with an unsupported width or height in fullscreen and the window chooses the closest appropriate size.
--
-- @param w - The new width, in pixels.
-- @param h - The new height, in pixels.
--
function ScreenManager.resize( w, h )
    for i = 1, #stack do
        stack[i]:resize( w, h );
    end
end

---
-- Called when the candidate text for an IME (Input Method Editor) has changed.
-- The candidate text is not the final text that the user will eventually choose. Use love.textinput for that.
-- @param text - The UTF-8 encoded unicode candidate text.
-- @param start - The start cursor of the selected candidate text.
-- @param length - The length of the selected candidate text. May be 0.
--
function ScreenManager.textedited( text, start, length )
    ScreenManager.peek():textedited( text, start, length );
end

---
-- Reroute the textinput callback to the currently active screen.
-- @param input
--
function ScreenManager.textinput( input )
    ScreenManager.peek():textinput( input );
end

---
-- Callback function triggered when a touch press moves inside the touch screen.
-- @param id - The identifier for the touch press.
-- @param x - The x-axis position of the touch press inside the window, in pixels.
-- @param y - The y-axis position of the touch press inside the window, in pixels.
-- @param pressure - The amount of pressure being applied. Most touch screens aren't pressure sensitive, in which case the pressure will be 1.
--
function ScreenManager.touchmoved( id, x, y, pressure )
    ScreenManager.peek():touchmoved( id, x, y, pressure );
end

---
-- Callback function triggered when the touch screen is touched.
-- @param id - The identifier for the touch press.
-- @param x - The x-axis position of the touch press inside the window, in pixels.
-- @param y - The y-axis position of the touch press inside the window, in pixels.
-- @param pressure - The amount of pressure being applied. Most touch screens aren't pressure sensitive, in which case the pressure will be 1.
--
function ScreenManager.touchpressed( id, x, y, pressure )
    ScreenManager.peek():touchpressed( id, x, y, pressure );
end

---
-- Callback function triggered when the touch screen stops being touched.
-- @param id - The identifier for the touch press.
-- @param x - The x-axis position of the touch press inside the window, in pixels.
-- @param y - The y-axis position of the touch press inside the window, in pixels.
-- @param pressure - The amount of pressure being applied. Most touch screens aren't pressure sensitive, in which case the pressure will be 1.
--
function ScreenManager.touchreleased( id, x, y, pressure )
    ScreenManager.peek():touchreleased( id, x, y, pressure );
end

---
-- Update all screens on the stack.
--
function ScreenManager.update( dt )
    for i = 1, #stack do
        stack[i]:update( dt );
    end
end

---
-- Update all screens on the stack whenever the game window is minimized.
-- @param nvisible
--
function ScreenManager.visible( nvisible )
    for i = 1, #stack do
        stack[i]:visible( nvisible );
    end
end

---
-- Callback function triggered when the mouse wheel is moved.
-- @param x - Amount of horizontal mouse wheel movement. Positive values indicate movement to the right.
-- @param y - Amount of vertical mouse wheel movement. Positive values indicate upward movement.
function ScreenManager.wheelmoved( x, y )
    ScreenManager.peek():wheelmoved( x, y );
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return ScreenManager;

--==================================================================================================
-- Created 02.06.14 - 17:30                                                                        =
--==================================================================================================
