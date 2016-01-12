#ScreenManager

The ScreenManager library is a state manager at heart which allows some nifty things, like stacking multiple screens on top of each other.

It also offers hooks for most of LÖVE's callback functions. Based on the type of callback the calls are rerouted to either only the active screen (love.keypressed, love.quit, ...) or to all screens (love.resize, love.visible, ...).

## Example

This is a simple example of how the ScreenManager should be used (note: You will have to change the paths in the example to fit your setup).

```lua
-- main.lua

local ScreenManager = require('lib/ScreenManager');

function love.load()
    local screens = {
        main = require('src/screens/MainScreen');
    };

    ScreenManager.init(screens, 'main');
end

function love.draw()
    ScreenManager.draw();
end

function love.update(dt)
    ScreenManager.update(dt);
end
```
Note how MainScreen inherits from Screen.lua. This isn't mandatory, but recommended since Screen.lua already has templates for most of the callback functions.

```lua
-- MainScreen.lua

local Screen = require('lib/Screen');

local MainScreen = {};

function MainScreen.new()
    local self = Screen.new();

    local x, y, w, h = 20, 20, 40, 20;

    function self:draw()
        love.graphics.rectangle('fill', x, y, w, h);
    end

    function self:update(dt)
        w = w + 2;
        h = h + 1;
    end

    return self;
end

return MainScreen;
```
