--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2015 Robert Machmer                                      --
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

    function self:update(dt) end

    function self:draw() end

    function self:focus(dfocus) end

    function self:directorydropped(path) end

    function self:filedropped(file) end

    function self:resize(w, h) end

    function self:visible(dvisible) end

    function self:keypressed(key) end

    function self:keyreleased(key) end

    function self:lowmemory() end

    function self:textinput(input) end

    function self:mousereleased(x, y, button) end

    function self:mousepressed(x, y, button) end

    function self:mousefocus(focus) end

    function self:mousemoved(x, y, dx, dy) end

    function self:quit(dquit) end

    function self:touchmoved(id, x, y, pressure) end

    function self:touchpressed(id, x, y, pressure) end

    function self:touchreleased(id, x, y, pressure) end

    function self:wheelmoved(x, y) end

    function self:isActive()
        return active;
    end

    function self:setActive(dactiv)
        active = dactiv;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Screen;

--==================================================================================================
-- Created 02.06.14 - 20:25                                                                        =
--==================================================================================================
