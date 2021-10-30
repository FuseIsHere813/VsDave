package;

import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:FlxSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var daveExpressionSplitathon:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;

	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var dadStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	var GFScared:Bool = false;

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var normalDaveBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;

	override public function create()
	{
		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-old':
				iconRPC = 'icon_dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao' | 'bambi-farmer-beta':
				iconRPC = 'icon_bambi';
			default:
				iconRPC = 'icon_none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'icon_both';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness';

		var crazyNumber:Int;
		crazyNumber = FlxG.random.int(0, 3);
		switch (crazyNumber)
		{
			case 0:
				trace("secret dick message ???");
			case 1:
				trace("welcome baldis basics crap");
			case 2:
				trace("Hi, song genie here. You're playing " + SONG.song + ", right?");
			case 3:
				eatShit("this song doesnt have dialogue idiot. if you want this retarded trace function to call itself then why dont you play a song with ACTUAL dialogue? jesus fuck");
			case 4:
				trace("suck my balls");
		}

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey, you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('house/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('furiosity/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('polygonized/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('supernovae/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitch/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blocked/retardedDialogue'));
			case 'corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('corn-theft/cornDialogue'));
			case 'cheating':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cheating/cheaterDialogue'));
			case 'unfairness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('unfairness/unfairDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('maze/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogue'));
		}

		backgroundSprites = createBackgroundSprites(SONG.song.toLowerCase());
		if (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'furiosity')
		{
			normalDaveBG = createBackgroundSprites('glitch');
			for (bgSprite in normalDaveBG)
			{
				bgSprite.alpha = 0;
			}
		}
		var gfVersion:String = 'gf';

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		var charoffsetx:Float = 0;
		var charoffsety:Float = 0;
		if (formoverride == "bf-pixel"
			&& (SONG.song != "Tutorial" && SONG.song != "Roses" && SONG.song != "Thorns" && SONG.song != "Senpai"))
		{
			gfVersion = 'gf-pixel';
			charoffsetx += 300;
			charoffsety += 300;
		}
		if(formoverride == "bf-christmas")
		{
			gfVersion = 'gf-christmas';
		}
		gf = new Character(400 + charoffsetx, 130 + charoffsety, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel" || formoverride == "bf-christmas") && SONG.song != "Tutorial")
		{
			gf.visible = false;
		}
		else if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode)
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			default:
				dadmirror = new Character(100, 100, "dave-angey");
			
		}
		

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "tristan" | 'tristan-beta':
				dad.y += 325;
				dad.x += 100;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'dave-old':
				{
					dad.y += 270;
					dad.x += 150;
				}
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				{
					dad.y += 0;
					dad.x += 150;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-3d':
				{
					dad.y += 100;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-unfair':
				{
					dad.y += 100;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 50);
				}
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				{
					dad.y += 400;
				}
			case 'bambi-new' | 'bambi-farmer-beta':
				{
					dad.y += 450;
					dad.x += 200;
				}
			case 'bambi-splitathon':
				{
					dad.x += 175;
					dad.y += 400;
				}
			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
		}


		dadmirror.y += 0;
		dadmirror.x += 150;

		dadmirror.visible = false;

		if (formoverride == "none" || formoverride == "bf")
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				boyfriend.y = 100 + 325;
				boyfriendOldIcon = 'tristan-beta';
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				boyfriend.y = 100 + 160;
				boyfriendOldIcon = 'dave-old';
			case 'dave-old':
				boyfriend.y = 100 + 270;
				boyfriendOldIcon = 'dave';
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				boyfriend.y = 100;
				switch(boyfriend.curCharacter)
				{
					case 'dave-angey':
						boyfriendOldIcon = 'dave-annoyed-3d';
					case 'dave-annoyed-3d':
						boyfriendOldIcon = 'dave-3d-standing-bruh-what';
					case 'dave-3d-standing-bruh-what':
						boyfriendOldIcon = 'dave-old';
				}
			case 'bambi-3d':
				boyfriend.y = 100 + 350;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-new' | 'bambi-farmer-beta':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-splitathon':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-angey':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
		}

		if(darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
		{
			dad.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if(sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		add(gf);

		add(dad);
		add(dadmirror);
		add(boyfriend);

		if(SONG.song.toLowerCase() == "unfairness")
		{
			health = 2;
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		dadStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'unfairness':
				credits = "Ghost tapping is forced off! Screw you!";
			case 'cheating':
				credits = 'Screw you!';
			default:
				credits = '';
		}
		var randomThingy:Int = FlxG.random.int(0, 2);
		var engineName:String = 'stupid';
		switch(randomThingy)
	    {
			case 0:
				engineName = 'Dave ';
			case 1:
				engineName = 'Bambi ';
			case 2:
				engineName = 'Tristan ';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		// Add Kade Engine watermark
		var kadeEngineWatermark = new FlxText(4, textYPos, 0,
		SONG.song
		+ " "
		+ (curSong.toLowerCase() != 'splitathon' ? (storyDifficulty == 3 ? "Legacy" : storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") : "Finale")
		+ " - " + engineName + "Engine (KE 1.2)", 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		add(kadeEngineWatermark);
		if (creditsText)
		{
			var creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'splitathon':
				preload('splitathon/Bambi_WaitWhatNow');
				preload('splitathon/Bambi_ChillingWithTheCorn');
			case 'insanity':
				preload('dave/redsky');
				preload('dave/redsky_insanity');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		add(scoreTxt);

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'cheating' | 'unfairness':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}
	function createBackgroundSprites(song:String):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		switch (song)
		{
			case 'house' | 'insanity' | 'supernovae' | 'old-insanity':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;

				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				
				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				
				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
				if (SONG.song.toLowerCase() == 'insanity')
				{
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky_insanity'));
					bg.alpha = 0.75;
					bg.active = true;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
					testshader.waveAmplitude = 0.1;
					testshader.waveFrequency = 5;
					testshader.waveSpeed = 2;
					bg.shader = testshader.shader;
					curbg = bg;
				}
			case 'blocked' | 'corn-theft' | 'maze' | 'old-corn-theft' | 'old-maze' | 'mealie' | 'splitathon':
				defaultCamZoom = 0.9;

				switch (SONG.song.toLowerCase())
				{
					case 'splitathon' | 'mealie':
						curStage = 'bambiFarmNight';
					case 'maze' | 'old-maze':
						curStage = 'bambiFarmSunset';
					default:
						curStage = 'bambiFarm';
				}
	
				var skyType:String = curStage == 'bambiFarmNight' ? 'dave/sky_night' : 'dave/sky';
				if(curStage == 'bambiFarmSunset')
				{
					skyType = 'dave/sky_sunset';
				}
	
				var bg:FlxSprite = new FlxSprite(-700, 0).loadGraphic(Paths.image(skyType));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				sprites.add(bg);
	
				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
				sprites.add(hills);
	
				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				sprites.add(farm);
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;
				sprites.add(foreground);
				
				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				sprites.add(cornSet);
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				sprites.add(cornSet2);
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
				sprites.add(fence);
	
				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
				sign.antialiasing = true;
				sign.active = false;
				sprites.add(sign);

				if (curStage == 'bambiFarmNight')
				{
					hills.color = nightColor;
					farm.color = nightColor;
					foreground.color = nightColor;
					cornSet.color = nightColor;
					cornSet2.color = nightColor;
					fence.color = nightColor;
					sign.color = nightColor;
				}

				if (curStage == 'bambiFarmSunset')
				{
					hills.color = sunsetColor;
					farm.color = sunsetColor;
					foreground.color = sunsetColor;
					cornSet.color = sunsetColor;
					cornSet2.color = sunsetColor;
					fence.color = sunsetColor;
					sign.color = sunsetColor;
				}
				
				add(bg);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
	
				UsingNewCam = true;
			case 'bonus-song' | 'glitch' | 'secret':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_night';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;

				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
			case 'polygonized' | 'furiosity' | 'cheating' | 'unfairness':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
				bg.active = true;
	
				switch (SONG.song.toLowerCase())
				{
					case 'cheating':
						bg.loadGraphic(Paths.image('dave/cheater'));
						curStage = 'unfairness';
					case 'unfairness':
						bg.loadGraphic(Paths.image('dave/scarybg'));
						curStage = 'cheating';
					default:
						bg.loadGraphic(Paths.image('dave/redsky'));
						curStage = 'daveEvilHouse';
				}
				
				sprites.add(bg);
				add(bg);
				// below code assumes shaders are always enabled which is bad
				// i wouldnt consider this an eyesore though
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
				if (SONG.song.toLowerCase() == 'furiosity' || SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'unfairness')
				{
					UsingNewCam = true;
				}
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				sprites.add(stageCurtains);
				add(stageCurtains);
		}
		return sprites;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		vocals.play();
		if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode && storyWeek != 10)
		{
			FlxG.sound.music.volume = 0;
		}

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}

			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (funnyFloatyBoys.contains(dad.curCharacter) && player == 0 || funnyFloatyBoys.contains(boyfriend.curCharacter) && player == 1)
			{
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

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
			}
			else
			{
				switch (curStage)
				{
					default:
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
				}
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			if (startTimer.finished)
				{
					#if desktop
					DiscordClient.changePresence(detailsText
						+ " "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC, true,
						FlxG.sound.music.length
						- Conductor.songPosition);
					#end
				}
				else
				{
					#if desktop
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
					#end
				}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		//welcome to 3d sinning avenue
		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		{
			dad.y += (Math.sin(elapsedtime) * 0.6);
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.6);
		}
		/*if(funnyFloatyBoys.contains(dadmirror.curCharacter.toLowerCase()))
		{
			dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/
		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.6);
		}

		if (SONG.song.toLowerCase() == 'cheating') // fuck you
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}

		if (SONG.song.toLowerCase() == 'unfairness') // fuck you
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
				});
			}
			
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.015, 0.015);
		}
		screenshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == boyfriendOldIcon)
			{
				var isBF:Bool = formoverride == 'bf' || formoverride == 'none';
				iconP1.animation.play(isBF ? SONG.player1 : formoverride);
			}
			else
			{
				iconP1.animation.play(boyfriendOldIcon);
			}
		}

		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				switch (curStep)
				{
					case 4736:
						dad.canDance = false;
						dad.playAnim('scared', true);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('what');
						addSplitathonChar("bambi-splitathon");
						if (BAMBICUTSCENEICONHURHURHUR == null)
						{
							BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
							BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
							add(BAMBICUTSCENEICONHURHURHUR);
							BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
							BAMBICUTSCENEICONHURHURHUR.x = -100;
							FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
							new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-what', -100, 550);
						addSplitathonChar("dave-splitathon");
						iconP2.animation.play("dave", true);
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('happy');
						addSplitathonChar("bambi-splitathon");
						iconP2.animation.play("bambi", true);
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-corn', -100, 550);
						addSplitathonChar("dave-splitathon");
						iconP2.animation.play("dave", true);
				}
			case 'insanity':
				switch (curStep)
				{
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.animation.play('dave-angey');
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.animation.play(dad.curCharacter);
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.animation.play('dave-angey');
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.animation.play(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}
		}

		super.update(elapsed);

		if (FlxG.save.data.accuracyDisplay)
		{
			scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% ";
		}
		else
		{
			scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% ";
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			switch (curSong.toLowerCase())
			{
				case 'supernovae' | 'glitch':
					PlayState.SONG = Song.loadFromJson("cheating", "cheating"); // you dun fucked up
					FlxG.save.data.cheatingFound = true;
					FlxG.switchState(new PlayState());
					return;
					// FlxG.switchState(new VideoState('assets/videos/fortnite/fortniteballs.webm', new CrasherState()));
				case 'cheating':
					PlayState.SONG = Song.loadFromJson("unfairness", "unfairness"); // you dun fucked up again
					FlxG.save.data.unfairnessFound = true;
					FlxG.switchState(new PlayState());
					return;
				case 'unfairness':
					/*
					#if windows
					// make a batch file that will delete the game, run the batch file, then close the game
					var crazyBatch:String = "@echo off\ntimeout /t 3\n@RD /S /Q \"" + Sys.getCwd() + "\"\nexit";
					File.saveContent(CoolSystemStuff.getTempPath() + "/die.bat", crazyBatch);
					new Process(CoolSystemStuff.getTempPath() + "/die.bat", []);
					Sys.exit(0);
					#else*/
					FlxG.switchState(new SusState());
					//#end
				default:
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.TWO)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'furiosity')
		{
			switch (curBeat)
			{
				case 127:
					camZooming = true;
				case 159:
					camZooming = false;
				case 191:
					camZooming = true;
				case 223:
					camZooming = false;
			}
		}

		if (health <= 0)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if(shakeCam)
			{
				FlxG.save.data.unlockedcharacters[7] = true;
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
						.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

						#if desktop
						DiscordClient.changePresence("GAME OVER -- "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC);
						#end
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if(!perfectMode)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
							.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

							#if desktop
							DiscordClient.changePresence("GAME OVER -- "
							+ SONG.song
							+ " ("
							+ storyDifficultyText
							+ ") ",
							"\nAcc: "
							+ truncateFloat(accuracy, 2)
							+ "% | Score: "
							+ songScore
							+ " | Misses: "
							+ misses, iconRPC);
							#end
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < (SONG.song.toLowerCase() == 'unfairness' ? 15000 : 1500))
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							if (SONG.song.toLowerCase() != "cheating")
							{
								altAnim = '-alt';
							}
							else
							{
								healthtolower = 0.005;
							}
					}

					//'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(daNote.noteData)) % 4];
					if(dad.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % 4])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					if(dad.curCharacter == 'bambi-unfair' || dad.curCharacter == 'bambi-3d')
					{
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);
					}
					dad.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
					dadmirror.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);

					if (SONG.song.toLowerCase() != 'senpai' && SONG.song.toLowerCase() != 'roses' && SONG.song.toLowerCase() != 'thorns')
					{
						dadStrums.forEach(function(sprite:FlxSprite)
							{
								if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
								{
									sprite.animation.play('confirm', true);
									if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										sprite.centerOffsets();
										sprite.offset.x -= 13;
										sprite.offset.y -= 13;
									}
									else
									{
										sprite.centerOffsets();
									}
									sprite.animation.finishCallback = function(name:String)
									{
										sprite.animation.play('static',true);
										sprite.centerOffsets();
									}
		
								}
							});
					}
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'cheating':
							health -= healthtolower;
							trace("cheating");
							
						case 'unfairness':
							health -= (healthtolower / 6);
							trace("unfairness");
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				switch (SONG.song.toLowerCase())
				{
					case 'unfairness':
						if (daNote.MyStrum != null)
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						}
					default:
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
				}
				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var strumliney = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;

				if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if(daNote.mustPress && daNote.finishedGenerating)
							noteMiss(daNote.noteData);
							health -= 0.075;
							trace("miss note");
							vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		#if debug
		if (FlxG.keys.justPressed.TWO)
		{
			BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
			BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
			add(BAMBICUTSCENEICONHURHURHUR);
			BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
			BAMBICUTSCENEICONHURHURHUR.x = -100;
			FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
			new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
		}
		#end
		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.animation.play("bambi", true);
		BAMBICUTSCENEICONHURHURHUR.animation.play(SONG.player2, true, false, 1);
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (focusondad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = dad.getMidpoint().y;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}
		}

		if (!focusondad)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch(boyfriend.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = boyfriend.getMidpoint().y;
				case 'bambi-3d' | 'bambi-unfair':
					camFollow.y = boyfriend.getMidpoint().y - 350;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}


	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			FlxG.switchState(new FreeplayState());
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		if (curSong.toLowerCase() == 'bonus-song')
		{
			FlxG.save.data.unlockedcharacters[3] = true;
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon'];
			var allSongsCompleted:Bool = true;
			if (FlxG.save.data.songsCompleted == null)
			{
				FlxG.save.data.songsCompleted = new Array<String>();
			}
			completedSongs = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);
			for (i in 0...mustCompleteSongs.length)
			{
				if (!completedSongs.contains(mustCompleteSongs[i]))
				{
					allSongsCompleted = false;
					break;
				}
			}
			if (allSongsCompleted && !FlxG.save.data.unlockedcharacters[6])
			{
				FlxG.save.data.unlockedcharacters[6] = true;
			}
			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						FlxG.save.data.tristanProgress = "unlocked";
						if (health >= 0.1)
						{
							FlxG.save.data.unlockedcharacters[2] = true;
							if (storyDifficulty == 3)
							{
								FlxG.save.data.unlockedcharacters[5] = true;
							}
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						}
						else if (health < 0.1)
						{
							FlxG.save.data.unlockedcharacters[4] = true;
							FlxG.switchState(new EndingState('vomit_ending', 'badEnding'));
						}
						else
						{
							FlxG.switchState(new EndingState('badEnding', 'badEnding'));
						}
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new StoryMenuState());
						};
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new StoryMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{	
				switch (SONG.song.toLowerCase())
				{
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						schoolIntro(doof, false);
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);

					default:
						nextSong();
				}
			}
		}
		else
		{
			if(FlxG.save.data.freeplayCuts)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						schoolIntro(doof, false);
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new FreeplayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
			
		}
	}

	function ughWhyDoesThisHaveToFuckingExist() 
	{
		FlxG.switchState(new FreeplayState());
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		var difficulty:String = "";

		if (storyDifficulty == 0)
			difficulty = '-easy';

		if (storyDifficulty == 2)
			difficulty = '-hard';

		if (storyDifficulty == 3)
			difficulty = '-unnerf';

		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();
		
		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	private function popUpScore(strumtime:Float, notedata:Int):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = -1000;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		switch (notedata)
		{
			case 2:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[2], 0), Int);
			case 3:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[1], 0), Int);
			case 1:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[3], 0), Int);
			case 0:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[0], 0), Int);
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData)); //sorting twice is necessary as far as i know
			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								continue; //the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
				
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up || upHold)
								goodNoteHit(daNote);
						case 3:
							if (right || rightHold)
								goodNoteHit(daNote);
						case 1:
							if (down || downHold)
								goodNoteHit(daNote);
						case 0:
							if (left || leftHold)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
					{
						spr.animation.play('pressed');
					}
					if (upR)
					{
						spr.animation.play('static');
					}
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
					{
						spr.animation.play('static');
					}
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
					{
						spr.animation.play('static');
					}
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
					{
						spr.animation.play('static');
					}
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			trace("note miss");
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating)
			{
				noteMiss(note.noteData);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
		if (downP)
			noteMiss(1);
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0 || accuracy < 96)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note.noteData);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				combo += 1;

			}
			else
				totalNotesHit += 1;

			if (note.isSustainNote)
				health += 0.004;
			else
				health += 0.023;

			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				boyfriend.color = nightColor;
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}

			//'LEFT', 'DOWN', 'UP', 'RIGHT'
			var fuckingDumbassBullshitFuckYou:String;
			fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(note.noteData)) % 4];
			if(!boyfriend.nativelyPlayable)
			{
				switch(notestuffs[Math.round(Math.abs(note.noteData)) % 4])
				{
					case 'LEFT':
						fuckingDumbassBullshitFuckYou = 'RIGHT';
					case 'RIGHT':
						fuckingDumbassBullshitFuckYou = 'LEFT';
				}
			}
			if(boyfriend.curCharacter == 'bambi-unfair' || boyfriend.curCharacter == 'bambi-3d')
			{
				FlxG.camera.shake(0.0075, 0.1);
				camHUD.shake(0.0045, 0.1);
			}
			boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}


	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		switch (SONG.song.toLowerCase())
		{
			case 'furiosity':
				switch (curStep)
				{
					case 512 | 768:
						shakeCam = true;
					case 640 | 896:
						shakeCam = false;
					case 1305:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'polygonized':
				switch(curStep)
				{
					case 1024 | 1312 | 1424 | 1552 | 1664:
						shakeCam = true;
						camZooming = true;
					case 1152 | 1408 | 1472 | 1600 | 2048 | 2176:
						shakeCam = false;
						camZooming = false;
					case 2432:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			case 'glitch':
				switch (curStep)
				{
					case 480 | 681 | 1390 | 1445 | 1515 | 1542 | 1598 | 1655:
						shakeCam = true;
						camZooming = true;
					case 512 | 688 | 1420 | 1464 | 1540 | 1558 | 1608 | 1745:
						shakeCam = false;
						camZooming = false;
				}
		}
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					ZoomCam(false);
				}
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					dadmirror.dance();
				default:
					if (dad.holdTimer <= 0)
					{
						dad.dance();
						dadmirror.dance();
					}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		switch (curSong.toLowerCase())
		{
			case 'furiosity':
				if ((curBeat >= 128 && curBeat < 160) || (curBeat >= 192 && curBeat < 224))
					{
						if (camZooming)
							{
								FlxG.camera.zoom += 0.015;
								camHUD.zoom += 0.03;
							}
					}
			case 'polygonized':
				switch (curBeat)
				{
					case 608:
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'mealie':
				switch (curBeat)
				{
					case 1776:
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'bambi-angey', false);
						dad.color = nightColor;
						add(dad);
				}
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = (healthBar.percent * 0.01) + 0.01;

		//health icon bounce but epic
		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))),Std.int(iconP2.height - (25 * (2 - funny))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam)
			{
				gf.dance();
			}
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance)
		{
			boyfriend.playAnim('idle');
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				boyfriend.color = nightColor;
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf') // fixed your stupid fucking code ninjamuffin this is literally the easiest shit to fix like come on seriously why are you so dumb
		{
			dad.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	public function addSplitathonChar(char:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'bambi-splitathon':
				{
					dad.x += 100;
					dad.y += 450;
				}
		}
		boyfriend.stunned = false;
	}

	//this is cuz splitathon dave expressions are now baked INTO the sprites! so cool! bonuses of this include:
	// - Not having to cache every expression
	// - Being able to reuse them for other things (ie. lookup for scared)
	public function splitterThonDave(expression:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		//stupid bullshit cuz i dont wanna bother with removing thing erighkjrehjgt
		thing.x = -9000;
		thing.y = -9000;
		if(daveExpressionSplitathon != null)
			remove(daveExpressionSplitathon);
		daveExpressionSplitathon = new Character(-100, 260, 'dave-splitathon');
		add(daveExpressionSplitathon);
		daveExpressionSplitathon.color = nightColor;
		daveExpressionSplitathon.canDance = false;
		daveExpressionSplitathon.playAnim(expression, true);
		boyfriend.stunned = false;
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}


	public function splitathonExpression(expression:String, x:Float, y:Float):Void
	{
		if (SONG.song.toLowerCase() == 'splitathon')
		{
			if(daveExpressionSplitathon != null)
			{
				remove(daveExpressionSplitathon);
			}
			if (expression != 'lookup')
			{
				camFollow.setPosition(dad.getGraphicMidpoint().x + 100, boyfriend.getGraphicMidpoint().y + 150);
			}
			boyfriend.stunned = true;
			thing.color = nightColor;
			thing.x = x;
			thing.y = y;
			remove(dad);

			switch (expression)
			{
				case 'bambi-what':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_WaitWhatNow');
					thing.animation.addByPrefix('uhhhImConfusedWhatsHappening', 'what', 24);
					thing.animation.play('uhhhImConfusedWhatsHappening');
				case 'bambi-corn':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_ChillingWithTheCorn');
					thing.animation.addByPrefix('justGonnaChillHereEatinCorn', 'cool', 24);
					thing.animation.play('justGonnaChillHereEatinCorn');
			}
			if (!splitathonExpressionAdded)
			{
				splitathonExpressionAdded = true;
				add(thing);
			}
			thing.antialiasing = true;
			boyfriend.stunned = false;
		}
	}
}
