--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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

local ScreenManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local stack = {};
local screens = {};

-- ------------------------------------------------
-- Module Functions
-- ------------------------------------------------

---
-- Initialise the ScreenManager. This pushes the first
-- screen to the stack.
-- @param nscreens - The list of possible screens.
-- @param screen - The first screen to push to the stack.
--
function ScreenManager.init(nscreens, screen)
    stack = {};
    ScreenManager.setScreens(nscreens);
    ScreenManager.push(screen);
end

---
-- Clears the ScreenManager, creates a new screen and switches
-- to it. Use this if you don't want to stack onto other screens.
--
-- @param nscreen
--
function ScreenManager.switch(screen)
    ScreenManager.clear();
    ScreenManager.push(screen);
end

---
-- Creates a new screen and pushes it on the screen stack, where
-- it will overlay all the other screens.
-- Screens below the this new screen will be set inactive.
--
-- @param screen - The name of the screen to push on the stack.
--
function ScreenManager.push(screen)
    -- Deactivate the previous screen if there is one.
    if ScreenManager.peek() then
        ScreenManager.peek():setActive(false);
    end

    -- Push the new screen onto the stack.
    if screens[screen] then
        stack[#stack + 1] = screens[screen].new();
    else
        local str = "{";
        for i, v in pairs(screens) do
            str = str .. i .. ', ';
        end
        str = str .. "}";
        error('"' .. screen .. '" is not a valid screen. You will have to add a new one to your screen list or use one of the existing screens: ' .. str);
    end

    -- Create the new screen and initialise it.
    stack[#stack]:init();
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
        ScreenManager.peek():setActive(true);
    else
        error("Can't close the last screen. Use switch() to clear the screen manager and add a new screen.");
    end
end

---
-- Close and remove all screens from the stack.
--
function ScreenManager.clear()
    for i = 1, #stack do
        stack[i]:close();
        stack[i] = nil;
    end
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
-- Update all screens on the stack.
--
function ScreenManager.update(dt)
    for i = 1, #stack do
        stack[i]:update(dt);
    end
end

---
-- Resize all screens on the stack.
-- @param w
-- @param h
--
function ScreenManager.resize(w, h)
    for i = 1, #stack do
        stack[i]:resize(w, h);
    end
end

---
-- Update all screens on the stack whenever the game window gains or
-- loses focus.
-- @param nfocus
--
function ScreenManager.focus(nfocus)
    for i = 1, #stack do
        stack[i]:focus(nfocus);
    end
end

---
-- Update all screens on the stack whenever the game window is minimized.
-- @param nvisible
--
function ScreenManager.visible(nvisible)
    for i = 1, #stack do
        stack[i]:visible(nvisible);
    end
end

---
-- Reroutes the keypressed callback to the currently active screen.
-- @param key
--
function ScreenManager.keypressed(key)
    ScreenManager.peek():keypressed(key);
end

---
-- Reroutes the keyreleased callback to the currently active screen.
-- @param key
--
function ScreenManager.keyreleased(key)
    ScreenManager.peek():keyreleased(key);
end

---
-- Reroute the textinput callback to the currently active screen.
-- @param input
--
function ScreenManager.textinput(input)
    ScreenManager.peek():textinput(input);
end

---
-- Reroute the mousepressed callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager.mousepressed(x, y, button)
    ScreenManager.peek():mousepressed(x, y, button);
end

---
-- Reroute the mousereleased callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager.mousereleased(x, y, button)
    ScreenManager.peek():mousereleased(x, y, button);
end

---
-- Reroute the mousefocus callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager.mousefocus(focus)
    ScreenManager.peek():mousefocus(focus);
end

-- ------------------------------------------------
-- Setters
-- ------------------------------------------------

---
-- Set a new table of screens from which to pick a new screen when
-- pushing / switching.
-- @param nscreens
--
function ScreenManager.setScreens(nscreens)
    screens = nscreens;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return ScreenManager;

--==================================================================================================
-- Created 02.06.14 - 17:30                                                                        =
--==================================================================================================