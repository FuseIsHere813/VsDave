package;

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

	var curCharacter:String = '';
	var curMod:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var retardedPath:String = "dave/davePortrait";

	public var finishThing:Void->Void;

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
			case 'house':
				FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'insanity':
				FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'furiosity':
				FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'supernovae':
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
			case 'glitch':
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
			case 'blocked':
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
			case 'corn-theft':
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
			case 'maze':
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

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		if(PlayState.SONG.song.toLowerCase()=='house' || PlayState.SONG.song.toLowerCase()=='insanity' || PlayState.SONG.song.toLowerCase()=='furiosity' || PlayState.SONG.song.toLowerCase()=='supernovae' || PlayState.SONG.song.toLowerCase()=='glitch' || PlayState.SONG.song.toLowerCase()=='blocked' || PlayState.SONG.song.toLowerCase()=='corn-theft' || PlayState.SONG.song.toLowerCase()=='maze')
		{
			box = new FlxSprite(-20, 400);
		}
		else
		{
			box = new FlxSprite(-20, 45);
		}

		
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'house':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();		
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'insanity':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();		
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'furiosity':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'supernovae':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'glitch':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'blocked':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'corn-theft':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
			case 'maze':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
	
			var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
			face.setGraphicSize(Std.int(face.width * 6));
			add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
	
		if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
			{
			portraitLeft = new FlxSprite(-20, 70);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitRight = new FlxSprite(320, 200);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = true;
			}
	    else if (PlayState.SONG.song.toLowerCase()=='house' || PlayState.SONG.song.toLowerCase()=='insanity')
			{
			portraitLeft = new FlxSprite(276.95, 170);
			portraitLeft.frames = Paths.getSparrowAtlas(retardedPath);
			portraitLeft.animation.addByPrefix('enter', 'dave Portrait', 24, false);
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
			}
		else if(PlayState.SONG.song.toLowerCase()=='furiosity')
		{
			portraitLeft = new FlxSprite(276.95, 170);
			portraitLeft.frames = Paths.getSparrowAtlas('dave/daveCoolPortrait');
			portraitLeft.animation.addByPrefix('enter', '3D Portrait', 24, false);
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		else if(PlayState.SONG.song.toLowerCase()=='supernovae' || PlayState.SONG.song.toLowerCase()=='glitch' || PlayState.SONG.song.toLowerCase()=='blocked' || PlayState.SONG.song.toLowerCase()=='corn-theft' || PlayState.SONG.song.toLowerCase()=='maze')
		{
			portraitLeft = new FlxSprite(276.95, 170);
			portraitLeft.frames = Paths.getSparrowAtlas('dave/bambiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'bambienter', 24, false);
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		
			portraitRight = new FlxSprite(230, 170);
			portraitRight.frames = Paths.getSparrowAtlas('dave/boyfriendPortrait');
			portraitRight.animation.addByPrefix('enter', 'BF Enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width / bfPortraitSizeMultiplier));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

	if(PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
	{
		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);
	}




if(PlayState.SONG.song.toLowerCase()=='house' || PlayState.SONG.song.toLowerCase()=='insanity' || PlayState.SONG.song.toLowerCase()=='supernovae' || PlayState.SONG.song.toLowerCase()=='glitch' || PlayState.SONG.song.toLowerCase()=='blocked' || PlayState.SONG.song.toLowerCase()=='maze' || PlayState.SONG.song.toLowerCase()=='corn-theft')
{
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
else if(PlayState.SONG.song.toLowerCase()=='furiosity')
{
	dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = Paths.font("barcode.ttf");
		dropText.color = 0xFFFFFFFF;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = Paths.font("barcode.ttf");
		swagDialogue.color = 0xFF000000;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
}
else
{
	dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
	dropText.font = 'Pixel Arial 11 Bold';
	dropText.color = 0xFFD89494;
	add(dropText);

	swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
	swagDialogue.font = 'Pixel Arial 11 Bold';
	swagDialogue.color = 0xFF3F2021;
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

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
			
			if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			}
			else
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' ||PlayState.SONG.song.toLowerCase() == 'house' || PlayState.SONG.song.toLowerCase() == 'insanity' || PlayState.SONG.song.toLowerCase() == 'furiosity' || PlayState.SONG.song.toLowerCase() == 'supernovae' || PlayState.SONG.song.toLowerCase() == 'glitch' || PlayState.SONG.song.toLowerCase() == 'blocked')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

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
		switch (curCharacter) //the following code is shit
		{
			case 'dad': //keep this here for legacy purposes
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'dave': //dave time
				if (portraitLeft != null)
				{
					portraitLeft.destroy();
				}
				portraitLeft = new FlxSprite(276.95, 170);
				portraitLeft.frames = Paths.getSparrowAtlas(retardedPath);
				portraitLeft.animation.addByPrefix('enter', 'dave Portrait', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'dave-3d': //dave time
				if (portraitLeft != null)
				{
					portraitLeft.destroy();
				}
				portraitLeft = new FlxSprite(276.95, 170);
				portraitLeft.frames = Paths.getSparrowAtlas('dave/daveCoolPortrait');
				portraitLeft.animation.addByPrefix('enter', '3D Portrait', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'bambi': //guys its the funny bambi character
				if (portraitLeft != null)
				{
					portraitLeft.destroy();
				}
				portraitLeft = new FlxSprite(276.95, 170);
				portraitLeft.frames = Paths.getSparrowAtlas('dave/bambiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'bambienter', 24, false);
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'senpai':
				if (portraitLeft != null)
				{
					portraitLeft.destroy();
				}
				portraitLeft = new FlxSprite(-20, 70);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}

			case 'bf': //create boyfriend
				if (portraitRight != null)
				{
					portraitRight.destroy();
				}
				portraitRight = new FlxSprite(230, 170);
				portraitRight.frames = Paths.getSparrowAtlas('dave/boyfriendPortrait');
				portraitRight.animation.addByPrefix('enter', 'BF Enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width / bfPortraitSizeMultiplier));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			case 'gf': //create genderbent boyfriend
				if (portraitRight != null)
				{
					portraitRight.destroy();
				}
				portraitRight = new FlxSprite(230, 170);
				portraitRight.frames = Paths.getSparrowAtlas('dave/gfPortrait');
				portraitRight.animation.addByPrefix('enter', 'GF Enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width / bfPortraitSizeMultiplier));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			
			case 'generic': //generic, boring
			{
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if(portraitRight.visible || portraitLeft.visible)
				{
					
				}
			}
		}

		if (portraitLeft.visible) //fixed
		{
			box.flipX = true;
		}
		else
		{
			box.flipX = false;
		}
		portraitLeft.x -= 150;
		//portraitRight.x += 100;
		portraitLeft.animation.play('enter',true);
		portraitRight.animation.play('enter',true);
		if (curMod == "distort")
		{
			var shad:Shaders.PulseEffect = new Shaders.PulseEffect();
			curshader = shad;
			shad.waveAmplitude = 1;
			shad.waveFrequency = 2;
			shad.waveSpeed = 1;
			shad.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000,100000);
			shad.shader.uampmul.value[0] = 1;
			portraitLeft.shader = shad.shader;
			portraitRight.shader = shad.shader;
		}
		if (curMod == "distortbg")
		{
			var shad:Shaders.DistortBGEffect = new Shaders.DistortBGEffect();
			curshader = shad;
			shad.waveAmplitude = 0.1;
			shad.waveFrequency = 5;
			shad.waveSpeed = 2;
			portraitLeft.shader = shad.shader;
			portraitRight.shader = shad.shader;
		}

		if (curMod == "setfont_normal")
		{
			dropText.font = 'Comic Sans MS Bold';
			swagDialogue.font = 'Comic Sans MS Bold';
		}

		if (curMod == "setfont_code")
		{
			dropText.font = Paths.font("barcode.ttf");
			swagDialogue.font = Paths.font("barcode.ttf");
		}
		
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curMod = splitName[0];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}
