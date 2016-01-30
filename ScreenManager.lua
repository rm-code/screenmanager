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
    _VERSION     = '1.8.0',
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
-- Initialise the ScreenManager.
-- Sets up the ScreenManager and pushes the first screen.
-- @param nscreens (table)  A table containing pointers to the different screen
--                           classes. The keys will are used to call a specific
--                           screen.
-- @param screen   (string) The key of the first screen to push to the stack.
--                           Use the key under which the screen in question is
--                           stored in the nscreens table.
-- @param ...      (vararg) One or multiple arguments passed to the new screen.
--
function ScreenManager.init( nscreens, screen, ... )
    stack = {};
    screens = nscreens;
    ScreenManager.push( screen, ... );
end

---
-- Switches to a screen.
-- Removes all screens from the stack, creates a new screen and switches to it.
-- Use this if you don't want to stack onto other screens.
-- @param screen (string) The key of the screen to switch to.
-- @param ...    (vararg) One or multiple arguments passed to the new screen.
--
function ScreenManager.switch( screen, ... )
    clear();
    ScreenManager.push( screen, ... );
end

---
-- Pushes a new screen to the stack.
-- Creates a new screen and pushes it on the screen stack, where it will overlay
-- the other screens below it. Screens below the this new screen will be set
-- inactive.
-- @param screen (string) The key of the screen to push to the stack.
-- @param ...    (vararg) One or multiple arguments passed to the new screen.
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
-- @return (table) The screen on top of the stack.
--
function ScreenManager.peek()
    return stack[#stack];
end

---
-- Removes and returns the topmost screen of the stack.
-- @return (table) The screen on top of the stack.
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
-- Reroutes the directorydropped callback to the currently active screen.
-- @param path (string) The full platform-dependent path to the directory.
--                       It can be used as an argument to love.filesystem.mount,
--                       in order to gain read access to the directory with
--                       love.filesystem.
--
function ScreenManager.directorydropped( path )
    ScreenManager.peek():directorydropped( path );
end

---
-- Reroutes the draw callback to all screens on the stack.
-- Screens that are higher on the stack will overlay screens that are below
-- them.
--
function ScreenManager.draw()
    for i = 1, #stack do
        stack[i]:draw();
    end
end

---
-- Reroutes the filedropped callback to the currently active screen.
-- @param file (File) The unopened File object representing the file that was
--                     dropped.
--
function ScreenManager.filedropped( file )
    ScreenManager.peek():filedropped( file );
end

---
-- Reroutes the focus callback to all screens on the stack.
-- @param focus (boolean) True if the window gains focus, false if it loses focus.
--
function ScreenManager.focus( focus )
    for i = 1, #stack do
        stack[i]:focus( focus );
    end
end

---
-- Reroutes the keypressed callback to the currently active screen.
-- @param key      (KeyConstant) Character of the pressed key.
-- @param scancode (Scancode)    The scancode representing the pressed key.
-- @param isrepeat (boolean)     Whether this keypress event is a repeat. The
--                                delay between key repeats depends on the
--                                user's system settings.
--
function ScreenManager.keypressed(  key, scancode, isrepeat )
    ScreenManager.peek():keypressed( key, scancode, isrepeat );
end

---
-- Reroutes the keyreleased callback to the currently active screen.
-- @param key      (KeyConstant) Character of the released key.
-- @param scancode (Scancode)    The scancode representing the released key.
--
function ScreenManager.keyreleased( key, scancode )
    ScreenManager.peek():keyreleased( key, scancode );
end

---
-- Reroutes the lowmemory callback to the currently active screen.
-- mobile devices.
--
function ScreenManager.lowmemory()
    ScreenManager.peek():lowmemory();
end

---
-- Reroutes the mousefocus callback to the currently active screen.
-- @param focus (boolean) Wether the window has mouse focus or not.
--
function ScreenManager.mousefocus( focus )
    ScreenManager.peek():mousefocus( focus );
end

---
-- Reroutes the mousemoved callback to the currently active screen.
-- @param x  (number) Mouse x position.
-- @param y  (number) Mouse y position.
-- @param dx (number) The amount moved along the x-axis since the last time
--                     love.mousemoved was called.
-- @param dy (number) The amount moved along the y-axis since the last time
--                     love.mousemoved was called.
--
function ScreenManager.mousemoved( x, y, dx, dy )
    ScreenManager.peek():mousemoved( x, y, dx, dy );
end

---
-- Reroutes the mousepressed callback to the currently active screen.
-- @param x       (number)  Mouse x position, in pixels.
-- @param y       (number)  Mouse y position, in pixels.
-- @param button  (number)  The button index that was pressed. 1 is the primary
--                           mouse button, 2 is the secondary mouse button and 3
--                           is the middle button. Further buttons are mouse
--                           dependent.
-- @param istouch (boolean) True if the mouse button press originated from a
--                           touchscreen touch-press.
--
function ScreenManager.mousepressed( x, y, button, istouch )
    ScreenManager.peek():mousepressed( x, y, button, istouch );
end

---
-- Reroutes the mousereleased callback to the currently active screen.
-- @param x       (number)  Mouse x position, in pixels.
-- @param y       (number)  Mouse y position, in pixels.
-- @param button  (number)  The button index that was released. 1 is the primary
--                           mouse button, 2 is the secondary mouse button and 3
--                           is the middle button. Further buttons are mouse
--                           dependent.
-- @param istouch (boolean) True if the mouse button release originated from a
--                           touchscreen touch-release.
--
function ScreenManager.mousereleased( x, y, button, istouch )
    ScreenManager.peek():mousereleased( x, y, button, istouch );
end

---
-- Reroutes the quit callback to the currently active screen.
-- @return quit (boolean) Abort quitting. If true, do not close the game.
--
function ScreenManager.quit()
    ScreenManager.peek():quit();
end

---
-- Reroutes the resize callback to all screens on the stack.
-- @param w (number) The new width, in pixels.
-- @param h (number) The new height, in pixels.
--
function ScreenManager.resize( w, h )
    for i = 1, #stack do
        stack[i]:resize( w, h );
    end
end

---
-- Reroutes the textedited callback to the currently active screen.
-- @param text   (string) The UTF-8 encoded unicode candidate text.
-- @param start  (number) The start cursor of the selected candidate text.
-- @param length (number) The length of the selected candidate text. May be 0.
--
function ScreenManager.textedited( text, start, length )
    ScreenManager.peek():textedited( text, start, length );
end

---
-- Reroutes the textinput callback to the currently active screen.
-- @param input (string) The UTF-8 encoded unicode text.
--
function ScreenManager.textinput( input )
    ScreenManager.peek():textinput( input );
end

---
-- Reroutes the threaderror callback to all screens.
-- @param thread   (Thread) The thread which produced the error.
-- @param errorstr (string) The error message.
--
function ScreenManager.threaderror( thread, errorstr )
    for i = 1, #stack do
        stack[i]:threaderror( thread, errorstr );
    end
end


---
-- Reroutes the touchmoved callback to the currently active screen.
-- @param id       (light userdata) The identifier for the touch press.
-- @param x        (number)         The x-axis position of the touch press inside the
--                                   window, in pixels.
-- @param y        (number)         The y-axis position of the touch press inside the
--                                   window, in pixels.
-- @param dx       (number)         The x-axis movement of the touch inside the
--                                   window, in pixels.
-- @param dy       (number)         The y-axis movement of the touch inside the
--                                   window, in pixels.
-- @param pressure (number)         The amount of pressure being applied. Most
--                                   touch screens aren't pressure sensitive,
--                                   in which case the pressure will be 1.
--
function ScreenManager.touchmoved( id, x, y, dx, dy, pressure )
    ScreenManager.peek():touchmoved( id, x, y, dx, dy, pressure );
end

---
-- Reroutes the touchpressed callback to the currently active screen.
-- @param id       (light userdata) The identifier for the touch press.
-- @param x        (number)         The x-axis position of the touch press inside the
--                                   window, in pixels.
-- @param y        (number)         The y-axis position of the touch press inside the
--                                   window, in pixels.
-- @param dx       (number)         The x-axis movement of the touch inside the
--                                   window, in pixels.
-- @param dy       (number)         The y-axis movement of the touch inside the
--                                   window, in pixels.
-- @param pressure (number)         The amount of pressure being applied. Most
--                                   touch screens aren't pressure sensitive,
--                                   in which case the pressure will be 1.
--
function ScreenManager.touchpressed( id, x, y, dx, dy, pressure )
    ScreenManager.peek():touchpressed( id, x, y, dx, dy, pressure );
end

---
-- Reroutes the touchreleased callback to the currently active screen.
-- @param id       (light userdata) The identifier for the touch press.
-- @param x        (number)         The x-axis position of the touch press inside the
--                                   window, in pixels.
-- @param y        (number)         The y-axis position of the touch press inside the
--                                   window, in pixels.
-- @param dx       (number)         The x-axis movement of the touch inside the
--                                   window, in pixels.
-- @param dy       (number)         The y-axis movement of the touch inside the
--                                   window, in pixels.
-- @param pressure (number)         The amount of pressure being applied. Most
--                                   touch screens aren't pressure sensitive,
--                                   in which case the pressure will be 1.
--
function ScreenManager.touchreleased( id, x, y, dx, dy, pressure )
    ScreenManager.peek():touchreleased( id, x, y, dx, dy, pressure );
end

---
-- Reroutes the update callback to all screens.
-- @param dt (number) Time since the last update in seconds.
--
function ScreenManager.update( dt )
    for i = 1, #stack do
        stack[i]:update( dt );
    end
end

---
-- Reroutes the visible callback to all screens.
-- @param visible (boolean) True if the window is visible, false if it isn't.
--
function ScreenManager.visible( visible )
    for i = 1, #stack do
        stack[i]:visible( visible );
    end
end

---
-- Reroutes the wheelmoved callback to the currently active screen.
-- @param x (number) Amount of horizontal mouse wheel movement. Positive values
--                    indicate movement to the right.
-- @param y (number) Amount of vertical mouse wheel movement. Positive values
--                    indicate upward movement.
--
function ScreenManager.wheelmoved( x, y )
    ScreenManager.peek():wheelmoved( x, y );
end

---
-- Reroutes the gamepadaxis callback to the currently active screen.
-- @param joystick (Joystick)    The joystick object.
-- @param axis     (GamepadAxis) The joystick object.
-- @param value    (number)      The new axis value.
--
function ScreenManager.gamepadaxis( joystick, axis, value )
    ScreenManager.peek():gamepadaxis( joystick, axis, value );
end

---
-- Reroutes the gamepadpressed callback to the currently active screen.
-- @param joystick (Joystick)      The joystick object.
-- @param button   (GamepadButton) The virtual gamepad button.
--
function ScreenManager.gamepadpressed( joystick, button )
    ScreenManager.peek():gamepadpressed( joystick, button );
end

---
-- Reroutes the gamepadreleased callback to the currently active screen.
-- @param joystick (Joystick)      The joystick object.
-- @param button   (GamepadButton) The virtual gamepad button.
--
function ScreenManager.gamepadreleased( joystick, button )
    ScreenManager.peek():gamepadreleased( joystick, button );
end

---
-- Reroutes the joystickadded callback to the currently active screen.
-- @param joystick (Joystick) The newly connected Joystick object.
--
function ScreenManager.joystickadded( joystick )
    ScreenManager.peek():joystickadded( joystick );
end

---
-- Reroutes the joystickhat callback to the currently active screen.
-- @param joystick  (Joystick)    The newly connected Joystick object.
-- @param hat       (number)      The hat number.
-- @param direction (JoystickHat) The new hat direction.
--
function ScreenManager.joystickhat( joystick, hat, direction )
    ScreenManager.peek():joystickhat( joystick, hat, direction );
end

---
-- Reroutes the joystickpressed callback to the currently active screen.
-- @param joystick (Joystick) The newly connected Joystick object.
-- @param button   (number)   The button number.
--
function ScreenManager.joystickpressed( joystick, button )
    ScreenManager.peek():joystickpressed( joystick, button );
end

---
-- Reroutes the joystickreleased callback to the currently active screen.
-- @param joystick (Joystick) The newly connected Joystick object.
-- @param button   (number)   The button number.
--
function ScreenManager.joystickreleased( joystick, button )
    ScreenManager.peek():joystickreleased( joystick, button );
end

---
-- Reroutes the joystickremoved callback to the currently active screen.
-- @param joystick (Joystick) The now-disconnected Joystick object.
--
function ScreenManager.joystickremoved( joystick )
    ScreenManager.peek():joystickremoved( joystick );
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return ScreenManager;

--==================================================================================================
-- Created 02.06.14 - 17:30                                                                        =
--==================================================================================================
