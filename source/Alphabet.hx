package;

import cpp.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var text:String = "";

	public var itemType:String = "Classic";

	var _finalText:String = "";
	var _curText:String = "";

	var groupX:Float = 90;
	var groupY:Float = 0.48;

	public var SwitchXandY:Bool = false;

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	// custom shit
	// amp, backslash, question mark, apostrophy, comma, angry faic, period
	var lastSprite:AlphaCharacter;
	var xPosResetted:Bool = false;
	var lastWasSpace:Bool = false;

	var splitWords:Array<String> = [];

	var isBold:Bool = false;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false)
	{
		super(x, y);

		_finalText = text;
		this.text = text;
		isBold = bold;

		if (text != "")
		{
			if (typed)
			{
				startTypedText();
			}
			else
			{
				addText();
			}
		}
	}

	public function addText()
	{
		doSplitWords();

		var xPos:Float = 0;
		for (character in splitWords)
		{
			// if (character.fastCodeAt() == " ")
			// {
			// }

			if (character == " " || character == "-")
			{
				lastWasSpace = true;
			}

			if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1)
				// if (AlphaCharacter.alphabet.contains(character.toLowerCase()))
			{
				if (lastSprite != null)
				{
					xPos = lastSprite.x + lastSprite.width;
				}

				if (lastWasSpace)
				{
					xPos += 40;
					lastWasSpace = false;
				}

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 0);

				if (isBold)
					letter.createBold(character);
				else
				{
					letter.createLetter(character);
				}

				add(letter);

				lastSprite = letter;
			}

			// loopNum += 1;
		}
	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	public var personTalking:String = 'gf';

	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		// trace(arrayShit);

		var loopNum:Int = 0;

		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			#if (haxe >= "4.0.0")
			var isNumber:Bool = AlphaCharacter.numbers.contains(splitWords[loopNum]);
			var isSymbol:Bool = AlphaCharacter.symbols.contains(splitWords[loopNum]);
			#else
			var isNumber:Bool = AlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = AlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			#end

			if (AlphaCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1 || isNumber || isSymbol)
				// if (AlphaCharacter.alphabet.contains(splitWords[loopNum].toLowerCase()) || isNumber || isSymbol)

			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
					// if (isBold)
					// xPos -= 80;
				}
				else
				{
					xPosResetted = false;
				}

				if (lastWasSpace)
				{
					xPos += 20;
					lastWasSpace = false;
				}
				// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti);
				letter.row = curRow;
				if (isBold)
				{
					letter.createBold(splitWords[loopNum]);
				}
				else
				{
					if (isNumber)
					{
						letter.createNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}

					letter.x += 90;
				}

				if (FlxG.random.bool(40))
				{
					var daSound:String = "GF_";
					FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
				}

				add(letter);

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			switch (itemType) 
			{
				case "Classic":
					x = FlxMath.lerp(x, (targetY * 20) + groupX, 0.16 / (openfl.Lib.application.window.frameRate / 60));
					y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * groupY), 0.16 / (openfl.Lib.application.window.frameRate / 60));
				case "Vertical":
					y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.5), 0.16 / (openfl.Lib.application.window.frameRate / 60));
				case "C-Shape":
					y = FlxMath.lerp(y, (scaledY * 65) + (FlxG.height * 0.39), 0.16 / (openfl.Lib.application.window.frameRate / 60));

					x = FlxMath.lerp(x, Math.exp(scaledY * 0.8) * 70 + (FlxG.width * 0.1), 0.16 / (openfl.Lib.application.window.frameRate / 60));
					if (scaledY < 0)
						x = FlxMath.lerp(x, Math.exp(scaledY * -0.8) * 70 + (FlxG.width * 0.1), 0.16 / (openfl.Lib.application.window.frameRate / 60));

					if (x > FlxG.width + 30)
						x = FlxG.width + 30;

				case "D-Shape":
					y = FlxMath.lerp(y, (scaledY * 90) + (FlxG.height * 0.45), 0.16 / (openfl.Lib.application.window.frameRate / 60));

					x = FlxMath.lerp(x, Math.exp(Math.abs(scaledY * 0.8)) * -70 + (FlxG.width * 0.35), 0.16 / (openfl.Lib.application.window.frameRate / 60));

					if (x < -900)
						x = -900;
			}
		}

		super.update(elapsed);
	}
}

class AlphaCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";

	public static var numbers:String = "1234567890";

	public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";

	public var row:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var tex = Paths.getSparrowAtlas('alphabet');
		frames = tex;

		antialiasing = true;
	}

	public function createBold(letter:String)
	{
		animation.addByPrefix(letter, letter.toUpperCase() + " bold", 24);
		animation.play(letter);
		updateHitbox();
	}

	public function createLetter(letter:String):Void
	{
		var letterCase:String = "lowercase";
		if (letter.toLowerCase() != letter)
		{
			letterCase = 'capital';
		}

		animation.addByPrefix(letter, letter + " " + letterCase, 24);
		animation.play(letter);
		updateHitbox();

		FlxG.log.add('the row' + row);

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String,invert:Bool = false):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);
		if (invert)
		{
		}

		updateHitbox();
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'period', 24);
				animation.play(letter);
				y += 50;
			case "'":
				animation.addByPrefix(letter, 'apostraphie', 24);
				animation.play(letter);
				y -= 0;
			case "?":
				animation.addByPrefix(letter, 'question mark', 24);
				animation.play(letter);
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
				animation.play(letter);
		}

		updateHitbox();
	}
}
