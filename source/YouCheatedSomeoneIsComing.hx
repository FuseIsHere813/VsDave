package;
#if sys
import sys.io.File;
import sys.io.Process;
#end
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * scary!!!
 */
class YouCheatedSomeoneIsComing extends MusicBeatState
{
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('badEnding'),1,true);
		var spooky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('dave/cheater_lol'));
        spooky.screenCenter();
        add(spooky);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER)
		{
			endIt();
		}
		
	}
	
	public function endIt()
	{
        FlxG.switchState(new SusState());
	}
	
}