package;

import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.tweens.FlxTween;
import haxe.Log;
import flixel.input.gamepad.lists.FlxBaseGamepadList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var blackScreen:FlxSprite;

	var curCharacter:String = '';
	var curMod:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	public var noAa:Array<String> = ["dialogue/dave_furiosity", "dialogue/3d_bamb", "dialogue/unfairnessPortrait"];

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bfPortraitSizeMultiplier:Float = 1.5;
	var textBoxSizeFix:Float = 7;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var debug:Bool = false;

	var curshader:Dynamic;

	public static var randomNumber:Int;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'house' | 'insanity' | 'splitathon':
				FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'furiosity' | 'polygonized' | 'cheating' | 'unfairness':
				FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'supernovae' | 'glitch':
				randomNumber = FlxG.random.int(0, 50);
				if(randomNumber == 50)
				{
					FlxG.sound.playMusic(Paths.music('secret'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('dooDooFeces'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'blocked' | 'corn-theft' | 'maze':
				randomNumber = FlxG.random.int(0, 50);
				if(randomNumber == 50)
				{
					FlxG.sound.playMusic(Paths.music('secret'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		if(PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
		{
			new FlxTimer().start(0.83, function(tmr:FlxTimer)
				{
					bgFade.alpha += (1 / 5) * 0.7;
					if (bgFade.alpha > 0.7)
						bgFade.alpha = 0.7;
				}, 5);
		}
		else
		{
			FlxTween.tween(bgFade, {alpha: 0.7}, 4.15);
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				box = new FlxSprite(-20, 45);
			default:
				box = new FlxSprite(-20, 400);
		}

		blackScreen = new FlxSprite(0, 0).makeGraphic(5000, 5000, FlxColor.BLACK);
		blackScreen.screenCenter();
		blackScreen.alpha = 0;
		add(blackScreen);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = false;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = false;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = false;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				
				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward', 'week6'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'cheating' | 'unfairness' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		var portraitLeftCharacter:String = '';
		var portraitRightCharacter:String = 'bf';

		portraitLeft = new FlxSprite();
		portraitRight = new FlxSprite();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitLeftCharacter = 'senpai';
				portraitRightCharacter = 'bfPixel';
				
			case 'house' | 'insanity' | 'furiosity' | 'polygonized':
				portraitLeftCharacter = 'dave';
				
			case 'blocked' | 'corn-theft' | 'maze' | 'supernovae' | 'glitch' | 'splitathon' | 'cheating' | 'unfairness':
				portraitLeftCharacter = 'bambi';
		}

		var leftPortrait:Portrait = getPortrait(portraitLeftCharacter);

		portraitLeft.frames = Paths.getSparrowAtlas(leftPortrait.portraitPath);
		portraitLeft.animation.addByPrefix('enter', leftPortrait.portraitPrefix, 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();

		var rightPortrait:Portrait = getPortrait(portraitRightCharacter);
		
		portraitRight.frames = Paths.getSparrowAtlas(rightPortrait.portraitPath);
		portraitRight.animation.addByPrefix('enter', rightPortrait.portraitPrefix, 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		
		portraitRight.visible = false;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft.setPosition(-20, 70);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.antialiasing = false;
				portraitLeft.visible = false;

				portraitRight.setPosition(320, 200);
				portraitRight.visible = true;
				portraitLeft.antialiasing = false;

			default:
				portraitLeft.setPosition(276.95, 170);
				portraitLeft.visible = true;
		}
		add(portraitLeft);
		add(portraitRight);

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				handSelect.setGraphicSize(Std.int(handSelect.width * 6));
				handSelect.updateHitbox();
				add(handSelect);
			case 'furiosity' | 'polygonized' | 'cheating' | 'unfairness':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFFFFFFFF;
				add(dropText);
			
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			default:
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFF00137F;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (curshader != null)
		{
			curshader.shader.uTime.value[0] += elapsed;
		}
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted)
		{
			remove(dialogue);
			
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'senpai' | 'thorns' | 'roses':
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				default:
					FlxG.sound.play(Paths.sound('textclickmodern'), 0.8);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
						
					FlxG.sound.music.fadeOut(2.2, 0);

					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'senpai' | 'thorns' | 'roses':
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
								{
									box.alpha -= 1 / 5;
									bgFade.alpha -= 1 / 5 * 0.7;
									portraitLeft.visible = false;
									portraitRight.visible = false;
									swagDialogue.alpha -= 1 / 5;
									dropText.alpha = swagDialogue.alpha;
								},5);
							default:
								FlxTween.tween(box, {alpha: 0}, 1.2);
								FlxTween.tween(bgFade, {alpha: 0}, 1.2);
								FlxTween.tween(portraitLeft, {alpha: 0}, 1.2);
								FlxTween.tween(portraitRight, {alpha: 0}, 1.2);
								FlxTween.tween(swagDialogue, {alpha: 0}, 1.2);
								FlxTween.tween(dropText, {alpha: 0}, 1.2);
					}

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curshader = null;
		if (curCharacter != 'generic')
		{
			var portrait:Portrait = getPortrait(curCharacter);
			if (portrait.left)
			{
				portraitLeft.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitLeft.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			}
			else
			{
				portraitRight.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitRight.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			}
			switch (curCharacter)
			{
				case 'dave' | 'bambi' | 'tristan' | 'insanityEndDave': //guys its the funny bambi character
						portraitLeft.setPosition(220, 220);
				case 'bf' | 'gf': //create boyfriend & genderbent boyfriend
					portraitRight.setPosition(570, 220);
			}
			box.flipX = portraitLeft.visible;
			portraitLeft.x -= 150;
			//portraitRight.x += 100;
			portraitLeft.antialiasing = !noAa.contains(portrait.portraitPath);
			portraitRight.antialiasing = true;
			portraitLeft.animation.play('enter',true);
			portraitRight.animation.play('enter',true);
		}
		else
		{
			portraitLeft.visible = false;
			portraitRight.visible = false;
		}
		switch (curMod)
		{
			case 'distort':
				/*var shad:Shaders.PulseEffect = new Shaders.PulseEffect();
				curshader = shad;
				shad.waveAmplitude = 1;
				shad.waveFrequency = 2;
				shad.waveSpeed = 1;
				shad.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000,100000);
				shad.shader.uampmul.value[0] = 1;*/
				PlayState.screenshader.Enabled = true;
			case 'undistort':
				PlayState.screenshader.Enabled = false;
			case 'distortbg':
				var shad:Shaders.DistortBGEffect = new Shaders.DistortBGEffect();
				curshader = shad;
				shad.waveAmplitude = 0.1;
				shad.waveFrequency = 5;
				shad.waveSpeed = 2;
				if (curCharacter != 'generic')
				{
					portraitLeft.shader = shad.shader;
					portraitRight.shader = shad.shader;
				}
			case 'setfont_normal':
				dropText.font = 'Comic Sans MS Bold';
				swagDialogue.font = 'Comic Sans MS Bold';
			case 'setfont_code':
				dropText.font = Paths.font("barcode.ttf");
				swagDialogue.font = Paths.font("barcode.ttf");
			case 'to_black':
				FlxTween.tween(blackScreen, {alpha:1}, 0.25);
		}
	}
	function getPortrait(character:String):Portrait
	{
		var portrait:Portrait = new Portrait('', '', '', true);
		switch (character)
		{
			case 'dave':
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'house':
						portrait.portraitPath = 'dialogue/dave_house';
						portrait.portraitPrefix = 'dave house portrait';

					case 'insanity':
						portrait.portraitPath = 'dialogue/dave_insanity';
						portrait.portraitPrefix = 'dave insanity portrait';

					case 'pre-furiosity':
						portrait.portraitPath = 'dialouge/dave_pre-furiosity';
						portrait.portraitPrefix = 'dave pre-furiosity portrait';

					case 'furiosity' | 'polygonized':
						portrait.portraitPath = 'dialogue/dave_furiosity';
						portrait.portraitPrefix = 'dave furiosity portrait';

					case 'blocked' | 'corn-theft' | 'maze':
						portrait.portraitPath = 'dialogue/dave_bambiweek';
						portrait.portraitPrefix = 'dave bambi week portrait';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/dave_splitathon';
						portrait.portraitPrefix = 'dave splitathon portrait';
				}
			case 'insanityEndDave':
				portrait.portraitPath = 'dialouge/dave_pre-furiosity';
				portrait.portraitPrefix = 'dave pre-furiosity portrait';
			case 'bambi':
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'blocked':
						portrait.portraitPath = 'dialogue/bambi_blocked';
						portrait.portraitPrefix = 'bambi blocked portrait';
					case 'old-corn-theft' | 'old-maze':
						portrait.portraitPath = 'dialogue/oldFarmBambiPortrait';
						portrait.portraitPrefix = 'bambienter';
					case 'corn-theft':
						portrait.portraitPath = 'dialogue/bambi_corntheft';
						portrait.portraitPrefix = 'bambi corntheft portrait';
					case 'maze':
						portrait.portraitPath = 'dialogue/bambi_maze';
						portrait.portraitPrefix = 'bambi maze portrait';
					case 'supernovae' | 'glitch':
						portrait.portraitPath = 'dialogue/bambi_bevel';
						portrait.portraitPrefix = 'bambienter';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/bambi_splitathon';
						portrait.portraitPrefix = 'bambi splitathon portrait';
					case 'cheating':
						portrait.portraitPath = 'dialogue/3d_bamb';
						portrait.portraitPrefix = 'bambi 3d portrait';
					case 'unfairness':
						portrait.portraitPath = 'dialogue/unfairnessPortrait';
						portrait.portraitPrefix = 'bambi unfairness portrait';
				}
			case 'senpai':
				portrait.portraitPath = 'weeb/senpaiPortrait';
				portrait.portraitPrefix = 'Senpai Portrait Enter';
				portrait.portraitLibraryPath = 'week6';
			case 'bfPixel':
				portrait.portraitPath = 'weeb/bfPortrait';
				portrait.portraitPrefix = 'Boyfriend portrait enter';
				portrait.portraitLibraryPath = 'week6';
				portrait.left = false;
			case 'bf':
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'blocked' | 'maze':
						portrait.portraitPath = 'dialogue/bf_blocked_maze';
						portrait.portraitPrefix = 'bf blocked & maze portrait';
					case 'furiosity' | 'polygonized' | 'corn-theft' | 'cheating' | 'unfairness' | 'supernovae' | 'glitch':
						portrait.portraitPath = 'dialogue/bf_furiosity_corntheft';
						portrait.portraitPrefix = 'bf furiosity & corntheft portrait';
					case 'house':
						portrait.portraitPath = 'dialogue/bf_house';
						portrait.portraitPrefix = 'bf house portrait';
					case 'insanity' | 'splitathon':
						portrait.portraitPath = 'dialogue/bf_insanity_splitathon';
						portrait.portraitPrefix = 'bf insanity & splitathon portrait';
				}
				portrait.left = false;
			case 'gf':
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'blocked':
						portrait.portraitPath = 'dialogue/gf_blocked';
						portrait.portraitPrefix = 'gf blocked portrait';
					case 'corn-theft' | 'cheating' | 'unfairness':
						portrait.portraitPath = 'dialogue/gf_corntheft';
						portrait.portraitPrefix = 'gf corntheft portrait';
					case 'maze':
						portrait.portraitPath = 'dialogue/gf_maze';
						portrait.portraitPrefix = 'gf maze portrait';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/gf_splitathon';
						portrait.portraitPrefix = 'gf splitathon portrait';
				}
				portrait.left = false;
			case 'tristan':
				portrait.portraitPath = 'dialogue/tristanPortrait';
				portrait.portraitPrefix = 'tristan portrait';
		}
		return portrait;
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curMod = splitName[0];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}
class Portrait
{
	public var portraitPath:String;
	public var portraitLibraryPath:String = '';
	public var portraitPrefix:String;
	public var left:Bool;
	public function new (portraitPath:String, portraitLibraryPath:String = '', portraitPrefix:String, left:Bool)
	{
		this.portraitPath = portraitPath;
		this.portraitLibraryPath = portraitLibraryPath;
		this.portraitPrefix = portraitPrefix;
		this.left = left;
	}
}