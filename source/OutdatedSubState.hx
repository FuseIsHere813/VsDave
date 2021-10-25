package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = null;
		if (FlxG.save.data.begin_thing)
		{
			txt = new FlxText(0, 0, FlxG.width,
				"Hello! \nThis mod utilizes shaders that may be of disturbance to some. \nIf you wish to disable these, \nturn off the Eyesores option in the options menu. \n Also, Supernovae and Glitch are not meant to be taken seriously and are not composed by me. \n Supernovae is by ArchWk, and Glitch is by The Boneyard. \nPress Enter to continue.",
				32);
		}
		else
		{
			txt = new FlxText(0, 0, FlxG.width,
				"Hello! \nThis mod utilizes shaders that may be of disturbance to some. \nIf you wish to disable these, \npress N, otherwise press Y. You can change this in options. \n Also, Supernovae and Glitch are not meant to be taken seriously and are not composed by me. \n Supernovae is by ArchWk, and Glitch is by The Boneyard.",
				32);
		}
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.PAUSE && FlxG.save.data.begin_thing == true)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.Y && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = true;
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.N && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = false;
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
