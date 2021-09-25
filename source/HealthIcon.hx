package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('dave', [24, 25], 0, false, isPlayer);
		animation.add('dave-annoyed', [24, 25], 0, false, isPlayer);
		animation.add('dave-splitathon', [24, 25], 0, false, isPlayer);
		animation.add('dave-angey', [26, 27], 0, false, isPlayer);
		animation.add('dave-3d-standing-bruh-what', [26, 27], 0, false, isPlayer);
		animation.add('dave-annoyed-3d', [26, 27], 0, false, isPlayer);
		animation.add('bambi', [28, 29], 0, false, isPlayer);
		animation.add('bambi-splitathon', [28, 29], 0, false, isPlayer);
		animation.add('bambi-new', [28, 29], 0, false, isPlayer);
		animation.add('bambi-farmer-beta', [28, 29], 0, false, isPlayer);
		animation.add('the-duo', [32, 33], 0, false, isPlayer);
		animation.add('bambi-stupid', [34, 35], 0, false, isPlayer);
		animation.add('bambi-3d', [36, 37], 0, false, isPlayer);
		animation.add('bambi-old', [34, 35], 0, false, isPlayer);
		animation.add('parents-christmas', [17], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('tristan', [30, 31], 0, false, isPlayer);
		animation.add('tristan-golden', [38, 39], 0, false, isPlayer);
		animation.add('bambi-angey', [40, 41], 0, false, isPlayer);
		animation.add('dave-old', [42, 43], 0, false, isPlayer);
		animation.add('bambi-bevel', [46, 47], 0, false, isPlayer);
		animation.play(char);
		if (char == 'dave-angey' || char == 'bambi-3d' || char == 'senpai' || char == 'bf-pixel' || char == 'spirit' || char == 'senpai-angry')
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
