package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;

	public var globaloffset:Array<Float> = [0,0];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('christmas/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('weeb/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				if (!PlayState.curStage.startsWith('school'))
				{
					globaloffset[0] = -200;
					globaloffset[1] = -175;
				}
				
				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/dave_sheet');
				frames = tex;
				animation.addByPrefix('idle', 'idleDance', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 18, 12);
				addOffset("singRIGHT", 5, -2);
				addOffset("singLEFT", 29, 2);
				addOffset("singDOWN", -5, 2);

				playAnim('idle');
			case 'dave-old':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/dave_old');
				frames = tex;
				animation.addByPrefix('idle', 'Dave idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dave Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dave Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dave Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dave Sing Note LEFT', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 0, -3);
				addOffset("singRIGHT", -1, 1);
				addOffset("singLEFT", -3, 0);
				addOffset("singDOWN", -1, -3);
				globaloffset[1] = 100;

				setGraphicSize(Std.int(width * 1.1));
				updateHitbox();

				playAnim('idle');
			case 'dave-annoyed':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/Dave_insanity_lol');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('scared', 'Scared', 24, true);
	
				addOffset('idle');
				addOffset("singUP", 3, 18);
				addOffset("singRIGHT", 16, -18);
				addOffset("singLEFT", 85, -12);
				addOffset("singDOWN", 0, -34);
				addOffset("scared", 0, -2);
	
				playAnim('idle');
			case 'dave-annoyed-3d':
				frames = Paths.getSparrowAtlas('dave/Dave_insanity_3d');
				animation.addByPrefix('idle', 'DaveAngry idle dance', 24, false);
				animation.addByPrefix('singUP', 'DaveAngry Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'DaveAngry Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DaveAngry Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DaveAngry Sing Note LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				globaloffset[0] = 150;
				globaloffset[1] = 450; //this is the y
				furiosityScale = 1.5;
				setGraphicSize(Std.int(width / furiosityScale));
			   updateHitbox();
			   antialiasing = false;
		
				playAnim('idle');
			case 'dave-3d-standing-bruh-what':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/local_disabled_man_regains_control_of_his_legs_after_turning_3d');
				frames = tex;
				animation.addByPrefix('idle', 'DaveAngry idle dance', 24, false);
				animation.addByPrefix('singUP', 'DaveAngry Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'DaveAngry Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DaveAngry Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DaveAngry Sing Note LEFT', 24, false);
		
				addOffset('idle', 7, 0);
				addOffset("singUP", -14, 16);
				addOffset("singRIGHT", 13, 23);
				addOffset("singLEFT", 49, -9);
				addOffset("singDOWN", 0, -10);
				antialiasing = false;
		
				playAnim('idle');
			case 'dave-angey':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/Dave_Furiosity');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');

			case 'bambi-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/bambi_angryboy');
				frames = tex;
				animation.addByPrefix('idle', 'DaveAngry idle dance', 24, false);
				animation.addByPrefix('singUP', 'DaveAngry Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'DaveAngry Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DaveAngry Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DaveAngry Sing Note LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP", 20, -10);
				addOffset("singRIGHT", 80, -20);
				addOffset("singLEFT", 0, -10);
				addOffset("singDOWN", 0, 10);
				globaloffset[0] = 150;
				globaloffset[1] = 450; //this is the y
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			case 'bambi-unfair':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('bambi/unfair_bambi');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP", 140, 70);
				addOffset("singRIGHT", -180, -60);
				addOffset("singLEFT", 250, 0);
				addOffset("singDOWN", 150, 50);
				globaloffset[0] = 150 * 1.3;
				globaloffset[1] = 450 * 1.3; //this is the y
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
			case 'tristan':
				var tex = Paths.getSparrowAtlas('dave/TRISTAN');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
	
				addOffset('idle');
				addOffset("singUP", -59, 57);
				addOffset("singRIGHT", -58, -6);
				addOffset("singLEFT", -4, -2);
				addOffset("singDOWN", -40, -30);
				addOffset("singUPmiss", -59, 57);
				addOffset("singRIGHTmiss", -58, -6);
				addOffset("singLEFTmiss", -4, -2);
				addOffset("singDOWNmiss", -40, -30);
				addOffset("hey", -2, 1);
				addOffset('firstDeath', 17, 1);
				addOffset('deathLoop', 17, 5);
				addOffset('deathConfirm', 12, 36);
				addOffset('scared', 6, 3);
	
				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;

			case 'tristan-beta':
				var tex = Paths.getSparrowAtlas('beta_tristan');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
	
				addOffset('idle');
				addOffset("singUP", -59, 57);
				addOffset("singRIGHT", -58, -6);
				addOffset("singLEFT", -4, -2);
				addOffset("singDOWN", -40, -30);
				addOffset("singUPmiss", -59, 57);
				addOffset("singRIGHTmiss", -58, -6);
				addOffset("singLEFTmiss", -4, -2);
				addOffset("singDOWNmiss", -40, -30);
				addOffset("hey", -2, 1);
				addOffset('firstDeath', 17, 1);
				addOffset('deathLoop', 17, 5);
				addOffset('deathConfirm', 12, 36);
				addOffset('scared', 6, 3);
	
				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('christmas/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
			case 'marcello-dave':
				var tex = Paths.getSparrowAtlas('dave/secret/Marcello_Dave_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'totally dave idle dance', 24, false);
				animation.addByPrefix('singUP', 'totally dave NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'totally dave NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'totally dave NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'totally dave NOTE DOWN0', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

				antialiasing = false;
				
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				if (!PlayState.curStage.startsWith('school'))
				{
					globaloffset[0] = -200;
					globaloffset[1] = -175;
				}
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				nativelyPlayable = true;

				flipX = true;
				
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				nativelyPlayable = true;
				flipX = true;

			case 'bambi':
				var tex = Paths.getSparrowAtlas('dave/bambi');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				playAnim('idle');

				nativelyPlayable = true;
				flipX = true;


			case 'bambi-old':
				var tex = Paths.getSparrowAtlas('dave/bambi-old');
				frames = tex;
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUP', 'MARCELLO NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'MARCELLO NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'MARCELLO NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'MARCELLO NOTE DOWN0', 24, false);
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUPmiss', 'MARCELLO MISS UP0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MARCELLO MISS LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MARCELLO MISS RIGHT0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MARCELLO MISS DOWN0', 24, false);

				animation.addByPrefix('firstDeath', "MARCELLO dead0", 24, false);
				animation.addByPrefix('deathLoop', "MARCELLO dead0", 24, true);
				animation.addByPrefix('deathConfirm', "MARCELLO dead0", 24, false);
	
				addOffset('idle');
				addOffset("singUP", -16, 3);
				addOffset("singRIGHT", 0, -4);
				addOffset("singLEFT", -10, -2);
				addOffset("singDOWN", -10, -17);
				addOffset("singUPmiss", -6, 4);
				addOffset("singRIGHTmiss", 0, -4);
				addOffset("singLEFTmiss", -10, -2);
				addOffset("singDOWNmiss", -10, -17);

				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;
				
			case 'bambi-new':
				frames = Paths.getSparrowAtlas('bambi/bambiRemake');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 36, -5);
				addOffset("singRIGHT", -45, -11);
				addOffset("singLEFT", -10, -9);
				addOffset("singDOWN", -12, -48);

				playAnim('idle');

			case 'bambi-farmer-beta':
				frames = Paths.getSparrowAtlas('bambi/bamber_farm_beta_man');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", -2, 49);
				addOffset("singRIGHT", -66, 13);
				addOffset("singLEFT", 2, -4);
				addOffset("singDOWN", -14, -23);

				playAnim('idle');

			case 'dave-splitathon':
				frames = Paths.getSparrowAtlas('splitathon/Splitathon_Dave');
				animation.addByPrefix('idle', 'SplitIdle', 24, false);
				animation.addByPrefix('singDOWN', 'SplitDown', 24, false);
				animation.addByPrefix('singUP', 'SplitUp', 24, false);
				animation.addByPrefix('singLEFT', 'SplitLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SplitRight', 24, false);
				animation.addByPrefix('scared', 'Nervous', 24, true);
				animation.addByPrefix('what', 'Mad', 24, true);
				animation.addByPrefix('happy', 'Happy', 24, true);

				addOffset('idle');
				addOffset("singUP", -12, 20);
				addOffset("singRIGHT", -40, -13);
				addOffset("singLEFT", 32, 8);
				addOffset("singDOWN", 3, -21);
				addOffset("scared", -15, 11);
				addOffset("what", -3, 1);
				addOffset("happy", -3, 1);

				playAnim('idle');
				
			case 'bambi-splitathon':
				frames = Paths.getSparrowAtlas('splitathon/Splitathon_Bambi');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
							
				addOffset('idle');
				addOffset("singUP", -24, 15);
				addOffset("singRIGHT", -34, -6);
				addOffset("singLEFT", -3, 6);
				addOffset("singDOWN", -20, -10);
		
				playAnim('idle');
				
			case 'tristan-golden':
				var tex = Paths.getSparrowAtlas('dave/tristan_golden');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
	
				addOffset('idle');
				addOffset("singUP", -59, 57);
				addOffset("singRIGHT", -58, -6);
				addOffset("singLEFT", -4, -2);
				addOffset("singDOWN", -40, -30);
				addOffset("singUPmiss", -59, 57);
				addOffset("singRIGHTmiss", -58, -6);
				addOffset("singLEFTmiss", -4, -2);
				addOffset("singDOWNmiss", -40, -30);
				addOffset("hey", -2, 1);
				addOffset('firstDeath', 17, 1);
				addOffset('deathLoop', 17, 5);
				addOffset('deathConfirm', 12, 36);
				addOffset('scared', 6, 3);
				addOffset('hit', 13, 25);
	
				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;
			case 'bambi-angey':
				frames = Paths.getSparrowAtlas('bambi/bambimaddddd');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP', 0, 20);
				addOffset('singRIGHT');

				playAnim('idle');
			case 'bambi-bevel':
				var tex = Paths.getSparrowAtlas('bambi/bevel_bambi');
				frames = tex;
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUP', 'MARCELLO NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'MARCELLO NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'MARCELLO NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'MARCELLO NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'MARCELLO NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MARCELLO NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MARCELLO NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MARCELLO NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'MARCELLO HEY', 24, false);

				animation.addByPrefix('firstDeath', "MARCELLO dies", 24, false);
				animation.addByPrefix('deathLoop', "MARCELLO Dead Loop", 24, true);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'MARCELLO idle shaking', 24);
				animation.addByPrefix('hit', 'MARCELLO hit', 24, false);

				addOffset('idle');
				addOffset("singUP", -59, 37);
				addOffset("singRIGHT", -38, -3);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -59, 37);
				addOffset("singRIGHTmiss", -38, -3);
				addOffset("singLEFTmiss", 12, -6);
				addOffset("singDOWNmiss", -10, -50);
				addOffset("hey", 3, 21);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('scared', -24, -10);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
			case 'what-lmao':
				var tex = Paths.getSparrowAtlas('bambi/what');
				frames = tex;
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUP', 'MARCELLO NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'MARCELLO NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'MARCELLO NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'MARCELLO NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'MARCELLO NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MARCELLO NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MARCELLO NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MARCELLO NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'MARCELLO HEY', 24, false);

				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'MARCELLO idle shaking', 24);
				animation.addByPrefix('hit', 'MARCELLO hit', 24, false);

				addOffset('idle');
				addOffset("singUP", -59, 37);
				addOffset("singRIGHT", -38, -3);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -59, 37);
				addOffset("singRIGHTmiss", -38, -3);
				addOffset("singLEFTmiss", 12, -6);
				addOffset("singDOWNmiss", -10, -50);
				addOffset("hey", 3, 21);
				addOffset('scared', -24, -10);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
		}
		dance();

		if(isPlayer)
		{
			flipX = !flipX;
		}
	}

	override function update(elapsed:Float)
	{
		if (animation == null)
		{
			super.update(elapsed);
			return;
		}
		else if (animation.curAnim == null)
		{
			super.update(elapsed);
			return;
		}
		if (!nativelyPlayable && !isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && canDance)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				default:
					playAnim('idle', true);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return; //why wasn't this a thing in the first place
		}
		if(AnimName.toLowerCase() == 'idle' && !canDance)
		{
			return;
		}
		animation.play(AnimName, Force, Reversed, Frame);
	
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				if(!nativelyPlayable)
				{
					offset.set((daOffset[0] * -1) + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
				else
				{
					offset.set(daOffset[0] + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
			}
			else
			{
				if(nativelyPlayable)
				{
					offset.set((daOffset[0] * -1), daOffset[1]);
				}
				else
				{
					offset.set(daOffset[0], daOffset[1]);
				}
			}
		}
		else
			offset.set(0, 0);
	
		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}
	
			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
