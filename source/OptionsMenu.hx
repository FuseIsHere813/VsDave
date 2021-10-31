package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
		#end
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
		controlsStrings = CoolUtil.coolStringFile((FlxG.save.data.dfjk ? 'DFJK' : 'WASD') + "\n" + (FlxG.save.data.newInput ? "Ghost Tapping" : "No Ghost Tapping") + "\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\nAccuracy " + (FlxG.save.data.accuracyDisplay ? "off" : "on") + "\n" + (FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled') + "\n" + (FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off") + "\n" + (FlxG.save.data.freeplayCuts ? "Freeplay Cutscenes On" : "Freeplay Cutscenes Off"));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		menuBG.loadGraphic(MainMenuState.randomizeBG());
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.screenCenter(X);
				controlLabel.itemType = 'Vertical';
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (controls.RIGHT_R)
			{
				FlxG.save.data.offset++;
				versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
			}

			if (controls.LEFT_R)
				{
					FlxG.save.data.offset--;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}
	

			if (controls.ACCEPT)
			{
				grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.dfjk ? 'DFJK' : 'WASD'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
						if (FlxG.save.data.dfjk)
							controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						else
							controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.newInput ? "Ghost Tapping" : "No Ghost Tapping"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Accuracy " + (FlxG.save.data.accuracyDisplay ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
					case 4:
						FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
					case 5:
						FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
					case 6:
						FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.freeplayCuts ? "Freeplay Cutscenes On" : "Freeplay Cutscenes Off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 6;
						ctrl.screenCenter(X);
						ctrl.itemType = 'Vertical';
						grpControls.add(ctrl);
						
				}
			}
	}

	var isSettingControl:Bool = false;

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
