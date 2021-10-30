package;

import flixel.math.FlxRandom;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var LocalScrollSpeed:Float = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;


	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	private var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair'];

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal") //had to add a new variable to this because FNF dumb
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime + FlxG.save.data.offset;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;
		if (((CharactersWith3D.contains(PlayState.SONG.player2) && !musthit) || ((CharactersWith3D.contains(PlayState.SONG.player1) || PlayState.characteroverride == "dave-angey") && musthit)) || ((CharactersWith3D.contains(PlayState.SONG.player2) || CharactersWith3D.contains(PlayState.SONG.player1)) && ((this.strumTime / 50) % 20 > 10)))
		{
				frames = Paths.getSparrowAtlas('NOTE_assets_3D');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}
		else
		{
			switch (daStage)
			{
				default:
				var dumbasspath:String = 'NOTE_assets';

				    switch(noteStyle)
				    {
						case 'phone':
							dumbasspath = 'NOTE_phone';
						default:
							dumbasspath = 'NOTE_assets';
					}
					frames = Paths.getSparrowAtlas(dumbasspath);

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
			}
		}
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating':
				switch (noteData)
				{
					case 0:
						x += swagWidth * 3;
						notetolookfor = 3;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('redScroll');
				}
				flipY = (Math.round(Math.random()) == 0); //fuck you
				flipX = (Math.round(Math.random()) == 1);

			default:
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('purpleScroll');
					case 1:
						notetolookfor = 1;
						x += swagWidth * 1;
						animation.play('blueScroll');
					case 2:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 3;
						x += swagWidth * 3;
						animation.play('redScroll');
				}
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating' | 'unfairness':
				if (Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState"))
				{
					var state:PlayState = cast(FlxG.state,PlayState);
					InPlayState = true;
					if (musthit)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.dadStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
									x = spr.x;
									MyStrum = spr;
								}
							});
					}
				}
		}
		if (PlayState.SONG.song.toLowerCase() == 'unfairness')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0,120) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1,3);
			}
		}
		

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (MyStrum != null)
		{
			x = MyStrum.x + (isSustainNote ? width : 0);
		}
		else
		{
			if (InPlayState)
			{
				var state:PlayState = cast(FlxG.state,PlayState);
				if (mustPress)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.dadStrums.forEach(function(spr:FlxSprite)
							{
								if (spr.ID == notetolookfor)
								{
									x = spr.x;
									MyStrum = spr;
								}
							});
					}
			}
		}
		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
			
		}
	}
}
