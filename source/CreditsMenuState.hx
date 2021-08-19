package;

import flixel.addons.plugin.taskManager.FlxTask;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUIGroup;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;

using StringTools;

class CreditsMenuState extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
   var blackBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
   var selectedFormat:FlxText;
   var defaultFormat:FlxText;
   var currentY:Float;
   var curNameSelected:Int = 1;
   var creditsTextGroup:Array<CreditsText>;
   var state:State;
   var selectedPersonGroup:FlxSpriteGroup = new FlxSpriteGroup();
   var transitioningBack:Bool = false;
   var peopleInCredits:Array<Person> = 
   [
     new Person("MoldyGH", CreditsType.Dev, "Creator/Main Dev of Vs Dave & Bambi",
        [
           new Social('youtube', 'https://www.youtube.com/channel/UCHIvkOUDfbMCv-BEIPGgpmA'), 
           new Social('soundcloud', 'https://soundcloud.com/moldygh'),
         ]
      ),
      new Person("MissingTextureMan101", CreditsType.Dev, "Secondary Dev of Vs Dave & Bambi",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ),
      new Person("rapparep lol", CreditsType.Dev, "Main Artist of Vs Dave & Bambi",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ),
      new Person("TheBuilderXD", CreditsType.Dev, "Gamebanana Page Manager & made Tristan sprites & more!",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ),
      new Person("Erizur", CreditsType.Dev, "Programmer",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ),
      new Person("T5mpler", CreditsType.Dev, "Programmer & Supporter",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ),
      new Person("CyndaquilDAC", CreditsType.Dev, "Programmer & Supporter",
         [
            new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ')
         ]
      ), 
   ];

	override function create()
	{
      state = State.SelectingName;
      defaultFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
      selectedFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      creditsTextGroup = new Array<CreditsText>();
      
      bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);
      
      var developers:Array<Person> = new Array<Person>();
      var betaTesters:Array<Person> = new Array<Person>();
      var contributors:Array<Person> = new Array<Person>();

      for (person in peopleInCredits) 
      {
         switch (person.creditsType)
         {
            case Dev: developers.push(person);
            case BetaTester: betaTesters.push(person);
            case Contributor: contributors.push(person);
         }
      }
      
      var devTitleText = new FlxText(0, 0, 0, 'Developers');
      devTitleText.setFormat("Comic Sans MS Bold", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      devTitleText.screenCenter(X);
      add(devTitleText);
      
      var developersCreditsText:CreditsText = new CreditsText(devTitleText, false);
      developersCreditsText.selectionId = 0;
      creditsTextGroup.push(developersCreditsText);
      
      for (i in 0...developers.length)
      {
         var textItem:FlxText = new FlxText(0, (devTitleText.y + 40) + (i * 50), 0, developers[i].name, 32);
         textItem.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
         textItem.screenCenter(X);

         var creditsTextItem:CreditsText = new CreditsText(textItem, true);
         creditsTextItem.selectionId = 1 + i;

         add(textItem);
         creditsTextGroup.push(creditsTextItem);
      }
      changeSelection();
		super.create();
	}
   
	override function update(elapsed:Float)
   {
      var upPressed = controls.UP_P;
		var downPressed = controls.DOWN_P;
		var back = controls.BACK;
		var accept = controls.ACCEPT;
      switch (state)
      {
         case State.SelectingName:
				if (creditsTextGroup.length != 0)
				{
					for (creditsText in creditsTextGroup)
					{
						var speed = 0.25;
						var scaledY = FlxMath.remapToRange(creditsText.selectionId, 0, 1, 0, 1.3);
						creditsText.text.y = FlxMath.lerp(creditsText.text.y, (scaledY * 75) + (FlxG.height * 0.5), speed);
					}
				}
				if (upPressed)
				{
               var creditsText = creditsTextGroup[curNameSelected - 1];
               if (creditsText != null && !creditsText.menuItem)
               {
                  changeSelection(-2);
               }
               else
               {
                  changeSelection(-1);
               }
				}
				if (downPressed)
				{
               var creditsText = creditsTextGroup[curNameSelected + 1];
               if (creditsText != null && !creditsText.menuItem)
               {
                  changeSelection(2);
               }
               else
               {
                  changeSelection(1);
               }
				}
				if (back)
				{
					FlxG.switchState(new MainMenuState());
				}
				if (accept && creditsTextGroup[curNameSelected].menuItem)
				{
					selectPerson(peopleInCredits[curNameSelected - 1]);
					state = State.OnName;
               FlxG.mouse.visible = true;
				}
         case State.OnName:
            if (back)
            {
               for (item in selectedPersonGroup)
               {
                  FlxTween.tween(item, {alpha: 0}, 0.3,
                  {
                     onComplete: function (tween:FlxTween) {
                        selectedPersonGroup.remove(item, true);
                        remove(item);
                     }
                  });
               }
               selectedPersonGroup = new FlxSpriteGroup();
               FlxG.mouse.visible = false;
               state = State.SelectingName;
            }
      }
      
      super.update(elapsed);
   }

   function changeSelection(amount:Int = 0)
   {
      FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
      var selection:Int = 0;
      curNameSelected += amount;
      
      if (curNameSelected > peopleInCredits.length)
      {
         curNameSelected = 0;
         if (!creditsTextGroup[curNameSelected].menuItem)
         {
            curNameSelected = 1;
         }
      }
      if (curNameSelected < 0)
      {
         curNameSelected = peopleInCredits.length;
         if (!creditsTextGroup[curNameSelected].menuItem)
         {
            curNameSelected = peopleInCredits.length - 1;
         }
      }
      
      for (creditsText in creditsTextGroup)
      {
         creditsText.selectionId = selection - curNameSelected;
         selection++;
      }

		var currentText:FlxText = creditsTextGroup[curNameSelected].text;
      if (creditsTextGroup[curNameSelected].menuItem)
      {
		   currentText.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, 
            selectedFormat.borderColor);
      }
		for (i in 0...creditsTextGroup.length)
		{
			if (creditsTextGroup[i] == creditsTextGroup[curNameSelected] || !creditsTextGroup[i].menuItem)
			{
				continue;
			}

			var currentText:FlxText = creditsTextGroup[i].text;
			currentText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle,
				defaultFormat.borderColor);
			currentText.screenCenter(X);
		}
   }

   function selectPerson(selectedPerson:Person)
   {
      var personName:FlxText = new FlxText(0, 100, 0, selectedPerson.name, 50);
      personName.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      personName.screenCenter(X);
      
      var credits:FlxText = new FlxText(0, personName.y + 50, 0, selectedPerson.credits, 25);
      credits.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      credits.screenCenter(X);

      personName.alpha = 0;
      blackBg.alpha = 0;
      credits.alpha = 0;
      
      selectedPersonGroup.add(blackBg);
      selectedPersonGroup.add(personName);
      selectedPersonGroup.add(credits);

      add(blackBg);
      add(personName);
      add(credits);

      FlxTween.tween(blackBg, { alpha: 0.7 }, 0.8);
      FlxTween.tween(personName, { alpha: 1 }, 0.8);
      FlxTween.tween(credits, { alpha: 1 }, 0.8);

      for (i in 0...selectedPerson.socialMedia.length)
      {
         var social:Social = selectedPerson.socialMedia[i];
         var socialButton:FlxButton = new FlxButton(0, credits.y + 100 + (i * 100), '', function() { FlxG.openURL(social.socialLink); });
         socialButton.loadGraphic(Paths.image('credits/' + social.socialMediaName));
         socialButton.updateHitbox();
         socialButton.screenCenter(X);

         socialButton.label.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
         socialButton.label.fieldWidth = 0;
         
         switch (social.socialMediaName)
         {
            case 'youtube':
               socialButton.text = 'Youtube';

            case 'soundcloud':
               socialButton.text = 'Soundcloud';
         }
         socialButton.alpha = 0;
         add(socialButton);

         FlxTween.tween(socialButton, { alpha: 1 }, 0.8);
         selectedPersonGroup.add(socialButton);
      }
   }
}

class Person
{
   public var name:String;
   public var creditsType:CreditsType;
   public var credits:String;
	public var socialMedia:Array<Social>;

	public function new(name:String, creditsType:CreditsType, credits:String, socialMedia:Array<Social>)
	{
      this.name = name;
      this.creditsType = creditsType;
		this.credits = credits;
      this.socialMedia = socialMedia;
	}
}
class Social
{
   public var socialMediaName:String;
   public var socialLink:String;

   public function new(socialMedia:String, socialLink:String)
   {
      this.socialMediaName = socialMedia;
      this.socialLink = socialLink;
   }
}
class CreditsText
{
   public var text:FlxText;
   public var menuItem:Bool;
   public var selectionId:Int;

   public function new(text:FlxText, menuItem:Bool)
   {
      this.text = text;
      this.menuItem = menuItem;
   }
}
enum CreditsType
{
   Dev; BetaTester; Contributor;
}
enum State
{
   SelectingName; OnName;
}