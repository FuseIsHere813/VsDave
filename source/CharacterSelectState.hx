package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
 /**
 hey you fun commiting people, 
 i don't know about the rest of the mod but since this is basically 99% my code 
 i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
 the secondary dev, ben
*/

class CharacterInSelect
{
	public var names:Array<String>;
	public var noteMs:Array<Float>;
	public var polishedNames:Array<String>;

	public function new(names:Array<String>, noteMs:Array<Float>, polishedNames:Array<String>)
	{
		this.names = names;
		this.noteMs = noteMs;
		this.polishedNames = polishedNames;
	}
}
class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var currentReal:Int = 0;
	public var curForm:Int = 0;
	public var notemodtext:FlxText;
	public var characterText:FlxText;

	public var funnyIconMan:HealthIcon;

	var strummies:FlxTypedGroup<FlxSprite>;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false; //CHANGE THIS TO FALSE BEFORE YOU COMMIT RETARDS

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect(['bf', 'bf-pixel', 'bf-christmas'], [1, 1, 1, 1], ["Boyfriend", "Pixel Boyfriend", "Christmas Boyfriend"]),
		new CharacterInSelect(['what-lmao', 'marcello-dave'], [0, 0, 0, 0], ["IF YOU SEE THIS CHRACTER, REPORT IT TO THE DEVS!", "IF YOU SEE THIS CHRACTER, REPORT IT TO THE DEVS!"]),
		new CharacterInSelect(['tristan', 'tristan-beta'], [2, 0.5, 0.5, 0.5], ["Tristan", 'Tristan (Beta)']),
		new CharacterInSelect(['dave', 'dave-annoyed', 'dave-splitathon'], [0.25, 0.25, 2, 2], ["Dave", "Dave (Insanity)", 'Dave (Splitathon)']),
		//these are the canon bambis' names according to marcello, dont change them back
		new CharacterInSelect(['bambi', 'bambi-new', 'bambi-splitathon', 'bambi-angey', 'bambi-old', 'bambi-bevel'], [0, 0, 3, 0], ["Mr. Bambi", 'Bambi (Farmer)', 'Bambi (Splitathon)', 'Bambie', 'Bambi (Joke)', 'Bambi (Bevel)']),
		new CharacterInSelect(['dave-angey'], [2, 2, 0.25, 0.25], ["3D Dave"]),
		new CharacterInSelect(['tristan-golden'], [0.25, 0.25, 0.25, 2], ["Golden Tristan"]),
		new CharacterInSelect(['bambi-3d', 'bambi-unfair'], [0, 3, 0, 0], ["3D Bambi", 'Unfair Bambi']),
		//currentReal order should be 0, 1 (skipped anyways), 3, 4, 2, 5, 7, 6
	];
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();

		Conductor.changeBPM(110);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];

		currentSelectedCharacter = characters[currentReal];

		if (FlxG.save.data.unlockedcharacters == null)
		{
			FlxG.save.data.unlockedcharacters = [true,true,false,false,false,false,false,false];
		}

		if(isDebug)	
		{
			FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true,true]; //unlock everyone
		}

		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);

		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);
	
		var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
		stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
		stageHills.updateHitbox();
		stageHills.antialiasing = true;
		stageHills.scrollFactor.set(1, 1);
		stageHills.active = false;
		add(stageHills);
	
		var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
		gate.setGraphicSize(Std.int(gate.width * 1.2));
		gate.updateHitbox();
		gate.antialiasing = true;
		gate.scrollFactor.set(0.925, 0.925);
		gate.active = false;
		add(gate);
		
		var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		FlxG.camera.zoom = 0.75;
		camHUD.zoom = 0.75;

		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "bf");
		char.screenCenter();
		char.y = 450;
		add(char);

		strummies = new FlxTypedGroup<FlxSprite>();
		strummies.cameras = [camHUD];
		add(strummies);
	
		generateStaticArrows();
		
		notemodtext = new FlxText((FlxG.width / 3.5) + 80, 40, 0, "1.00x       1.00x        1.00x       1.00x", 30);
		notemodtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		notemodtext.scrollFactor.set();
		notemodtext.alpha = 0;
		notemodtext.y -= 10;
		FlxTween.tween(notemodtext, {y: notemodtext.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * 0)});
		notemodtext.cameras = [camHUD];
		add(notemodtext);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		characterText.cameras = [camHUD];
		add(characterText);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.sprTracker = characterText;
		funnyIconMan.cameras = [camHUD];
		funnyIconMan.visible = false;
		add(funnyIconMan);

		var tutorialThing:FlxSprite = new FlxSprite(-130, -90).loadGraphic(Paths.image('charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		tutorialThing.cameras = [camHUD];
		add(tutorialThing);

		
	}

	private function generateStaticArrows():Void
	{
		
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, 0);

			babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			babyArrow.x += Note.swagWidth * i;
			switch (Math.abs(i))
			{
				case 0:
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.ID = i;
	
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 3.5));
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			babyArrow.cameras = [camHUD];
			strummies.add(babyArrow);
		}
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//FlxG.camera.focusOn(FlxG.ce);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new FreeplayState());
		}

		if(controls.LEFT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singRIGHT', true);
			}
			else
			{
				char.playAnim('singLEFT', true);
			}

		}
		if(controls.RIGHT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singLEFT', true);
			}
			else
			{
				char.playAnim('singRIGHT', true);
			}
		}
		if(controls.UP_P && !PressedTheFunny)
		{
			char.playAnim('singUP', true);
		}
		if(controls.DOWN_P && !PressedTheFunny)
		{
			char.playAnim('singDOWN', true);
		}
		if (controls.ACCEPT)
		{
			if (!FlxG.save.data.unlockedcharacters[currentReal])
			{
				FlxG.camera.shake(0.05, 0.1);
				FlxG.sound.play(Paths.sound('badnoise1'), 0.9);
				return;
			}
			if (PressedTheFunny)
			{
				return;
			}
			else
			{
				PressedTheFunny = true;
			}
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(1.9, endIt);
		}
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			//currentReal order should be 0, 1 (skipped anyways), 3, 4, 2, 5, 7, 6
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			if(current == 1)
			{
				current = 0;
			}
			switch(current)
			{
				case 2:
					currentReal = 3;
				case 3:
					currentReal = 4;
				case 4:
					currentReal = 2;
				case 6:
					currentReal = 7;
				case 7:
					currentReal = 6;
				default:
					currentReal = current;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			//currentReal order should be 0, 1 (skipped anyways), 3, 4, 2, 5, 7, 6
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			if(current == 1)
			{
				current = 2;
			}
			switch(current)
			{
				case 2:
					currentReal = 3;
				case 3:
					currentReal = 4;
				case 4:
					currentReal = 2;
				case 6:
					currentReal = 7;
				case 7:
					currentReal = 6;
				default:
					currentReal = current;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[currentReal].names.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[currentReal].names.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
	}

	public function UpdateBF()
	{
		funnyIconMan.color = FlxColor.WHITE;
		currentSelectedCharacter = characters[currentReal];
		characterText.text = currentSelectedCharacter.polishedNames[curForm];
		char.destroy();
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		char.y = 450;

		switch (char.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				char.y = 100 + 325;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				char.y = 100 + 160;
			case 'dave-old':
				char.y = 100 + 270;
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				char.y = 100;
			case 'bambi-3d':
				char.y = 100 + 350;
				char.x += 100;
			case 'bambi-unfair':
				char.y = 100 + 575;
				char.x += 100;
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				char.y = 100 + 400;
				char.y -= 75;
			case 'bambi-new' | 'bambi-farmer-beta':
				char.y = 100 + 450;
				char.y -= 75;
			case 'bambi-splitathon':
				char.y = 100 + 400;
			case 'bambi-angey':
				char.y = 100 + 450;
				char.y -= 75;
		}
		add(char);
		funnyIconMan.animation.play(char.curCharacter);
		if (!FlxG.save.data.unlockedcharacters[currentReal])
		{
			char.color = FlxColor.BLACK;
			funnyIconMan.color = FlxColor.BLACK;
			funnyIconMan.animation.curAnim.curFrame = 1;
			characterText.text = '???';
			if(char.curCharacter == 'bambi-3d' || char.curCharacter == 'bambi-unfair')
			{
				//funny canon name
				characterText.text = '[EXPUNGED]';
			}
		}
		characterText.screenCenter(X);
		notemodtext.text = FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[0]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[3]) + "x        " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[2]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[1]) + "x";
	}

	override function beatHit()
	{
		super.beatHit();
		if (char != null && !selectedCharacter && curBeat % 2 == 0)
		{
			char.playAnim('idle', true);
		}
	}
	
	
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverride = currentSelectedCharacter.names[curForm];
		PlayState.curmult = currentSelectedCharacter.noteMs;
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}