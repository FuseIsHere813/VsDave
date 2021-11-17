package;

import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import openfl.ui.Keyboard;
import flixel.util.FlxCollision;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['House', 'Insanity', 'Polygonized'],
		['Blocked', 'Corn-Theft', 'Maze'],
		['Splitathon'],
		['huh', 'huh', 'huh']
	];

	var actualWeeks:Array<Dynamic> = [0, 1, 4, 2, 3];

	var curDifficulty:Int = 1;

	var indexoften:Int = 1;
	
	var tristanunlocked:Bool = false;

	public static var dofunnytristan:Bool = false;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['empty', 'bf', 'gf'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty']
	];

	var weekNames:Array<String> = [
		"Tutorial",
		"Dave's Fun Rapping Battle!",
		"Mr. Bambi's Fun Corn Maze!",
		"The Finale",
		'?????????'
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var curIndex:Int = 0;

	var imageBG:FlxSprite;
	var yellowBG:FlxSprite;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var songColors:Array<FlxColor> = [
        0xFFca1f6f, // GF
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD
		0xFF00FFFF //SPLIT THE THONNNNN
    ];

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Story Menu", null);
		#end
		
		FlxG.save.data.tristanProgress = null; //undo tristan stuff since its being moved
		//DONT REMOVE THIS CODE because we might use it for reference in the future
		tristanunlocked = false;
		dofunnytristan = false;
		if (FlxG.save.data.tristanProgress == "unlocked")
		{
			dofunnytristan = true;
			FlxG.save.data.tristanProgress = "pending play";
		}
		else if (FlxG.save.data.tristanProgress != "unlocked" && FlxG.save.data.tristanProgress != null)
		{
			tristanunlocked = true;
		}

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width * 2, 400, FlxColor.WHITE);
		yellowBG.color = songColors[0];

		imageBG = new FlxSprite(600, 1000).loadGraphic(Paths.image("blank", "shared"));
		imageBG.antialiasing = true;
		imageBG.screenCenter(X);
		imageBG.active = false;
		add(imageBG);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weekData.length)
		{
			if (actualWeeks[i] == 4 && !tristanunlocked) continue;
				var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, actualWeeks[i]);
				weekThing.y += ((weekThing.height + 20) * actualWeeks[i]);
				weekThing.targetY = actualWeeks[i];
				grpWeekText.add(weekThing);
	
				weekThing.screenCenter(X);
				weekThing.antialiasing = true;
				// weekThing.updateHitbox();
	
				// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = actualWeeks[i];
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		for (char in 0...3)
		{
				var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
				weekCharacterThing.y += 70;
				weekCharacterThing.antialiasing = true;
	
				switch (weekCharacterThing.character)
				{
					case 'bf':
						weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
						weekCharacterThing.updateHitbox();
						weekCharacterThing.x -= 80;
					case 'gf':
						weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
						weekCharacterThing.updateHitbox();
				}

				grpWeekCharacters.add(weekCharacterThing);
		}
		//daveimage = new FlxSprite(0,56).loadGraphic(Paths.image("dave/storyModeBGDave"));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('unnerfed', 'UNNERFED');
		sprDifficulty.animation.addByPrefix('finale', 'FINALE');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		super.create();

		if (dofunnytristan)
		{
			FlxG.sound.music.fadeOut(1,0);
			FlxG.camera.shake(0.02,5.1);
			FlxG.camera.fade(FlxColor.WHITE,5.05,false,FadeOut);
			FlxG.sound.play(Paths.sound('doom'));
			changeWeek(1);
			imageBG.destroy();
			imageBG = new FlxSprite(600, 200).loadGraphic(Paths.image("blank", "shared"));
			imageBG.antialiasing = true;
			imageBG.screenCenter(X);
			imageBG.active = false;
			add(imageBG);
		}
	}

	function FadeOut()
	{
		FlxG.switchState(new StoryMenuState());
		dofunnytristan = false;
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.save.data.tristanProgress = null;
			FlxG.switchState(new StoryMenuState());
		}
		#end


		if (!dofunnytristan)
		{
			scoreText.text = "WEEK SCORE:" + lerpScore;
			txtWeekTitle.text = weekNames[curWeek].toUpperCase();
			txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
		}
		else
		{
			scoreText.text = "WEEK SCORE: ????????";
			txtWeekTitle.text = "???";
			txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
			txtTracklist.text = "Tracks\n??????\n??????\n??????";

			grpWeekText.members[6].week.loadGraphic(Paths.image('storymenu/week' + 7));
			grpWeekText.members[7].visible = false;
			grpWeekText.members[8].week.loadGraphic(Paths.image('storymenu/week' + 8));
		}


		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if ((!selectedWeek) && !dofunnytristan)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT && !dofunnytristan)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek && !dofunnytristan)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (FlxG.save.data.tristanProgress == "pending play" && curWeek == 0 && curWeek != 4)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				return;
			}
			if (!stopspamming)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
				case 3:
					diffic = '-unnerf';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.characteroverride = "none";
				PlayState.curmult = [1, 1, 1, 1];
				switch (PlayState.storyWeek)
				{
					default:
						LoadingState.loadAndSwitchState(new PlayState(), true);
					case 1:
						FlxG.sound.music.stop();
						LoadingState.loadAndSwitchState(new VideoState('assets/videos/daveCutscene.webm', new PlayState()), true);
				}
				
			});
			//new FlxTimer().start(1, function(tmr:FlxTimer)
			//{
			//	LoadingState.loadAndSwitchState(new CharacterSelectState(), true);
			//});
			//uncomment out the above code and comment out the other loadandswitchstate to allow for character selection in story mode!
		}
	}
	function updateDifficultySprite()
	{
		sprDifficulty.offset.x = 0;
		switch (curWeek)
		{
			case 3:
				sprDifficulty.animation.play('finale');
				sprDifficulty.offset.x = 45;
			default:
				switch (curDifficulty)
				{
					case 0:
						sprDifficulty.animation.play('easy');
						sprDifficulty.offset.x = 20;
						sprDifficulty.offset.y = 0;
					case 1:
						sprDifficulty.animation.play('normal');
						sprDifficulty.offset.x = 70;
						sprDifficulty.offset.y = 0;
					case 2:
						sprDifficulty.animation.play('hard');
						sprDifficulty.offset.x = 20;
						sprDifficulty.offset.y = 0;
					case 3:
						sprDifficulty.animation.play('unnerfed');
						sprDifficulty.offset.x = 70;
						sprDifficulty.offset.y = 20;
				}
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;
		
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		if (curWeek == 3)
		{
			curDifficulty = 1;
		}

		updateDifficultySprite();

		if(curWeek != 3)
			sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		if(curWeek != 3)
			FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curIndex += change;
		if (curIndex >= weekData.length)
			curIndex = 0;
		if (curIndex < 0)
			curIndex = weekData.length - 1;
		if (actualWeeks[curIndex] == 4 && !tristanunlocked) curIndex += (change > 0 ? 1 : -1); //repeat it again
		curWeek = actualWeeks[curIndex];
		if (curWeek != 1) //no trying to use unnerfed on non-week 7 songs
		{
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}
		if (curWeek == 3)
		{
			curDifficulty = 1;
			leftArrow.visible = false;
			rightArrow.visible = false;
		}
		else
		{
			leftArrow.visible = true;
			rightArrow.visible = true;
		}

		updateDifficultySprite();
		
		var bullShit:Int = 0;
		
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - ((curIndex > indexoften && !tristanunlocked) ? curIndex - 1 : curIndex);
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxTween.color(yellowBG, 0.25, yellowBG.color, songColors[curWeek]);

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
		imageBgCheck();
	}
	

	function imageBgCheck()
	{
		var path:String;
		var position:FlxPoint;
		switch (curWeek)
		{
			case 1:
				path = Paths.image("dave/DaveHouse", "shared");
				position = new FlxPoint(600, 55);
			case 2:
				path = Paths.image("dave/bamboi", "shared");
				position = new FlxPoint(600, 55);
			case 3:
				path = Paths.image("dave/splitathon", "shared");
				position = new FlxPoint(600, 55);
			default:
				path = Paths.image("blank", "shared");
				position = new FlxPoint(600, 200);
		}
		imageBG.destroy();
		imageBG = new FlxSprite(position.x, position.y).loadGraphic(path);
		imageBG.antialiasing = true;
		imageBG.screenCenter(X);
		imageBG.active = false;
		add(imageBG);
	}

	function updateText()
	{
		for (i in 0...grpWeekCharacters.members.length)
		{
			grpWeekCharacters.members[i].animation.play(weekCharacters[curWeek][i]);
			if (FlxG.save.data.tristanProgress == "pending play" && !dofunnytristan && i == 2)
			{
					grpWeekCharacters.members[i].visible = false;
			}
		}
		txtTracklist.text = "Tracks\n";

		switch (grpWeekCharacters.members[0].animation.curAnim.name)
		{
			case 'parents-christmas':
				grpWeekCharacters.members[0].offset.set(200, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.99));

			case 'senpai':
				grpWeekCharacters.members[0].offset.set(130, 0);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.4));

			case 'mom':
				grpWeekCharacters.members[0].offset.set(100, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'dad':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				// grpWeekCharacters.members[0].updateHitbox();
		}

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text += "\n";

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
