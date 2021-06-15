import flash.system.System;
import flixel.*;
import flixel.FlxState;

class CrasherState extends FlxState
{
    override public function create()
    {
        super.create();
        System.exit(0);
    }
}