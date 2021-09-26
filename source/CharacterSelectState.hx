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
 ben don't use any dave mod specific code here this needs to be generic so you can re-use it in your own mods
 shut up
 idiot
 no u
 */
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
	public var current:Int;
	public var curForm:Int;
	public var notemodtext:FlxText;
	public var characterText:FlxText;

	public var isDebug:Bool = false; //CHANGE THIS TO FALSE BEFORE YOU COMMIT RETARDS

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect(['bf'], [1, 1, 1, 1], ["Boyfriend"]),
		new CharacterInSelect(['bf-pixel'], [1, 1, 1, 1], ["Pixel Boyfriend"]),
		new CharacterInSelect(['tristan'], [2, 0.5, 0.5, 0.5], ["Tristan"]),
		new CharacterInSelect(['dave', 'dave-annoyed', 'dave-splitathon', 'dave-old'], [0.25, 0.25, 2, 2], ["Dave", "Dave (Insanity)", 'Dave (Splitathon)' , "Dave (Old)"]),
		new CharacterInSelect(['bambi', 'bambi-new', 'bambi-splitathon', 'bambi-angey', 'bambi-old', 'bambi-bevel', 'bambi-farmer-beta'], [0, 0, 3, 0], ["Mr. Bambi", 'Mr. Bambi (Farmer)', 'Mr. Bambi (Splitathon)', 'Mr. Bambi (Screwed)', 'Mr. Bambi (Old)', 'Mr. Bambi (Bambi Update)', 'Mr. Bambi (Farmer) (Old)']),
		new CharacterInSelect(['dave-angey', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what'], [2, 2, 0.25, 0.25], ["3D Dave", "3D Dave (Insanity)", "3D Dave (Old)"]),
		new CharacterInSelect(['tristan-golden'], [0.25, 0.25, 0.25, 2], ["Golden Tristan"])
	];
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		Conductor.changeBPM(110);
		currentSelectedCharacter = characters[current];
		if (FlxG.save.data.unlockedcharacters == null)
		{
			FlxG.save.data.unlockedcharacters = [true,true,false,false,false,false,false];
		}
		if(isDebug)	
		{
			FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true]; //unlock everyone
		}

		var end:FlxSprite = new FlxSprite(0, 0);
		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);
		add(end);
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
		//create stage
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

		//create character
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "bf");
		char.screenCenter();
		char.y = FlxG.height / 2;
		add(char);
	
		generateStaticArrows();
		
		notemodtext = new FlxText((FlxG.width / 3.5) + 80, 40, 0, "1.00x       1.00x        1.00x       1.00x", 30);
		notemodtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		notemodtext.scrollFactor.set();
		add(notemodtext);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.autoSize = false;
		characterText.size = 90;
		characterText.fieldWidth = 1080;
		characterText.alignment = FlxTextAlign.CENTER;
		add(characterText);
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
			add(babyArrow);
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

		if (FlxG.keys.justPressed.ENTER)
		{
			if (!FlxG.save.data.unlockedcharacters[current])
			{
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
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].names.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].names.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
	}

	public function UpdateBF()
	{
		currentSelectedCharacter = characters[current];
		characterText.text = currentSelectedCharacter.polishedNames[curForm];
		char.destroy();
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		char.y = FlxG.height / 2;
		switch (char.curCharacter)
		{
			case 'dave-angey':
				char.y -= 225;
		}
		add(char);
		if (!FlxG.save.data.unlockedcharacters[current])
		{
			char.color = FlxColor.BLACK;
			characterText.text = '???';
		}
		notemodtext.text = FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[0]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[3]) + "x        " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[2]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.noteMs[1]) + "x";
	}

	override function beatHit()
	{
		if (char != null && !selectedCharacter)
		{
			char.playAnim('idle');
		}
		super.beatHit();
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