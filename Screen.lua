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

local Screen = {};

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

function Screen.new()
    local self = {};

    local active = true;

    -- ------------------------------------------------
    -- Public Methods
    -- ------------------------------------------------

    function self:init() end

    function self:close() end

    function self:isActive()
        return active;
    end

    function self:setActive( dactiv )
        active = dactiv;
    end

    -- ------------------------------------------------
    -- Callback-stubs
    -- ------------------------------------------------

    function self:directorydropped() end

    function self:draw() end

    function self:filedropped() end

    function self:focus() end

    function self:keypressed() end

    function self:keyreleased() end

    function self:lowmemory() end

    function self:mousefocus() end

    function self:mousemoved() end

    function self:mousepressed() end

    function self:mousereleased() end

    function self:quit() end

    function self:resize() end

    function self:textedited() end

    function self:textinput() end

    function self:threaderror() end

    function self:touchmoved() end

    function self:touchpressed() end

    function self:touchreleased() end

    function self:update() end

    function self:visible() end

    function self:wheelmoved() end

    function self:gamepadaxis() end

    function self:gamepadpressed() end

    function self:gamepadreleased() end

    function self:joystickadded() end

    function self:joystickaxis() end

    function self:joystickhat() end

    function self:joystickpressed() end

    function self:joystickreleased() end

    function self:joystickremoved() end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Screen;

--==================================================================================================
-- Created 02.06.14 - 20:25                                                                        =
--==================================================================================================
