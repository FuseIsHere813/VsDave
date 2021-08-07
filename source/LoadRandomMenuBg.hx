package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
/**
 * class which contains functions for randomizing menu bgs, so we can add more without editing a buncha different code in a buncha different places
 */
class LoadRandomMenuBg
{ 
    /**
     * randomize menu background
    */
    public static var cachedRandomNum:Int;
    public static function randomize(menuBG:FlxSprite)
    {
        var randomNum:Int = FlxG.random.int(0, 6);
        cachedRandomNum = randomNum;
		switch(randomNum)
		{
			case 0:
				menuBG.loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
			case 1:
				menuBG.loadGraphic(Paths.image('backgrounds/SwagnotrllyTheMod'));
			case 2:
				menuBG.loadGraphic(Paths.image('backgrounds/Olyantwo'));
			case 3:
				menuBG.loadGraphic(Paths.image('backgrounds/morie'));
			case 4:
				menuBG.loadGraphic(Paths.image('backgrounds/mantis'));
			case 5:
				menuBG.loadGraphic(Paths.image('backgrounds/mamakotomi'));
			case 6:
				menuBG.loadGraphic(Paths.image('backgrounds/T5mpler'));
		}
    }
    public static function randomizeNoNewRandomNum(menuBG:FlxSprite)
    {
		switch(cachedRandomNum)
		{
			case 0:
				menuBG.loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
			case 1:
				menuBG.loadGraphic(Paths.image('backgrounds/SwagnotrllyTheMod'));
			case 2:
				menuBG.loadGraphic(Paths.image('backgrounds/Olyantwo'));
			case 3:
				menuBG.loadGraphic(Paths.image('backgrounds/morie'));
			case 4:
				menuBG.loadGraphic(Paths.image('backgrounds/mantis'));
			case 5:
				menuBG.loadGraphic(Paths.image('backgrounds/mamakotomi'));
			case 6:
				menuBG.loadGraphic(Paths.image('backgrounds/T5mpler'));
		}
    }
}

// baldis