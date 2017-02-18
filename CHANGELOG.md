## Version 2.0.0 ( 2017-02-18 )
- LÖVE callbacks can now be registered to the ScreenManager functions
- Screen pushing, popping and switching is delayed until the end of the current frame's draw function
    - Changes can still be applied directly if needed by calling `ScreenManager.performChanges`
- Use a single "null" function for the callback-stubs

## Version 1.8.0 ( 2016-01-30 )
- Add gamepad and joystick callbacks
- Add love.threaderror
- Add varargs to ScreenManager.init

## Version 1.7.0 ( 2016-01-12 )
- Add textedited callback
- Fix parameters for keypressed, keyreleased, mousepressed and mousereleased

## Version 1.6.0 ( 2015-10-29 )
- Add filedropped and directorydropped callbacks

## Version 1.5.0 ( 2015-10-25 )
- Add more callbacks

## Version 1.4.1 ( 2015-04-14 )
- Allow passing of varargs to new Screens

## Version 1.3.1 ( 2015-03-24 )
- Update library information

## Version 1.3.0 ( 2015-02-20 )
- Add mousemoved callback

## Version 1.2.1 ( 2015-02-03 )
- Add library information
- Remove redundant code

## Version 1.2.0 ( 2015-01-18 )
 - Initial Release
