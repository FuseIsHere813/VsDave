package;
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
class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int;
	public var notemodtext:FlxText;
	public var characterText:FlxText;

	public var isDebug:Bool = false;

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	public static var CharactersList:Array<String> = ["bf","bf-pixel","tristan","dave","bambi","dave-angey", "tristan-golden"];
	public static var CharacterNoteMs:Array<Array<Float>> = [[1,1,1,1],[1,1,1,1],[2,0.5,0.5,0.5],[0.25,0.25,2,2],[0,0,3,0],[2,2,0.25,0.25], [0.25,0.25,0.25,2]];
	public var polishedCharacterList:Array<String> = ["Boyfriend","Pixel Boyfriend","Tristan","Dave","Mr. Bambi","3D Dave","Golden Tristan"];
	//it goes left,right,up,down

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
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

					switch (Math.abs(i))
					{
						case 0:
						babyArrow.x += Note.swagWidth * 0;
						babyArrow.animation.addByPrefix('static', 'arrowLEFT');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						babyArrow.x += Note.swagWidth * 1;
						babyArrow.animation.addByPrefix('static', 'arrowDOWN');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						babyArrow.x += Note.swagWidth * 2;
						babyArrow.animation.addByPrefix('static', 'arrowUP');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						babyArrow.x += Note.swagWidth * 3;
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

		if(FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new FreeplayState());
		}

		if (FlxG.keys.justPressed.ENTER){
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


		notemodtext.text = FlxStringUtil.formatMoney(CharacterNoteMs[current][0]) + "x       " + FlxStringUtil.formatMoney(CharacterNoteMs[current][3]) + "x        " + FlxStringUtil.formatMoney(CharacterNoteMs[current][2]) + "x       " + FlxStringUtil.formatMoney(CharacterNoteMs[current][1]) + "x";

		if (FlxG.keys.justPressed.LEFT && !selectedCharacter){
			current--;
			if (current < 0)
			{
				current = 0;
			}
			else if (current > CharactersList.length - 1)
			{
				current = CharactersList.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter){
			current++;
			if (current < 0)
			{
				current = 0;
			}
			else if (current > CharactersList.length - 1)
			{
				current = CharactersList.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		
	}

	public function UpdateBF()
	{
		characterText.text = polishedCharacterList[current];
		char.destroy();
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, CharactersList[current]);
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
	}

	override function beatHit()
	{
		super.beatHit();
		//STOP POSTING ABOUT FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD}); I'M TIRED OF SEEING IT
		
		if (char != null)
		{
			char.dance();
		}
	}
	
	
	public function endIt(e:FlxTimer=null)
	{
		trace("ENDING");
		PlayState.characteroverride = CharactersList[current];
		PlayState.curmult = CharacterNoteMs[current];
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}