package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var noAaChars:Array<String> = [
		'dave-angey',
		'dave-annoyed-3d',
		'bambi-3d',
		'senpai',
		'senpai-angry',
		'spirit',
		'bf-pixel',
		'gf-pixel',
		'bambi-unfair'
	];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [2, 2], 0, false, isPlayer);
		animation.add('bf-old', [3, 4], 0, false, isPlayer);
		animation.add('face', [5, 6], 0, false, isPlayer);
		animation.add('gf', [7], 0, false, isPlayer);
		animation.add('dave', [8, 9], 0, false, isPlayer);
		animation.add('dave-annoyed', [8, 9], 0, false, isPlayer);
		animation.add('dave-angey', [10, 11], 0, false, isPlayer);
		animation.add('dave-splitathon', [8, 9], 0, false, isPlayer);
		animation.add('dave-3d-standing-bruh-what', [28, 29], 0, false, isPlayer);
		animation.add('dave-annoyed-3d', [38, 39], 0, false, isPlayer);
		animation.add('dave-old', [36, 37], 0, false, isPlayer);
		animation.add('marcello-dave', [8, 9], 0, false, isPlayer);

		animation.add('bambi', [12, 13], 0, false, isPlayer);
		animation.add('bambi-splitathon', [12, 13], 0, false, isPlayer);
		animation.add('bambi-new', [12, 13], 0, false, isPlayer);
		animation.add('bambi-farmer-beta', [12, 13], 0, false, isPlayer);

		animation.add('bambi-loser', [13, 13], 0, false, isPlayer);

		animation.add('bambi-stupid', [18, 19], 0, false, isPlayer);
		animation.add('bambi-3d', [20, 21], 0, false, isPlayer);
		animation.add('bambi-unfair', [40, 41], 0, false, isPlayer);
		animation.add('bambi-old', [18, 19], 0, false, isPlayer);
		animation.add('bambi-angey', [24, 25], 0, false, isPlayer);
		animation.add('bambi-bevel', [30, 31], 0, false, isPlayer);

		animation.add('tristan', [14, 15], 0, false, isPlayer);
		animation.add('tristan-golden', [22, 23], 0, false, isPlayer);
		animation.add('tristan-beta', [34, 35], 0, false, isPlayer);

		animation.add('the-duo', [16, 17], 0, false, isPlayer);
		animation.add('what-lmao', [18, 19], 0, false, isPlayer);
		animation.play(char);
		if (noAaChars.contains(char))
		{
			antialiasing = false;
		}
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		offset.set(Std.int(FlxMath.bound(width - 150,0)),Std.int(FlxMath.bound(height - 150,0)));


		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
