package;

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
   var curNameSelected:Int;
   var creditsTextGroup:Array<CreditsText>;
   var state:State;
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
   ];

	override function create()
	{
      state = State.SelectingName;
      defaultFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
      selectedFormat = new FlxText().setFormat("Comic Sans MS", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
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
      creditsTextGroup.push(developersCreditsText);
      
      for (i in 0...developers.length)
      {
         var textItem:FlxText = new FlxText(0, (devTitleText.y + 40) + (i * 50), 0, developers[i].name, 32);
         textItem.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
         textItem.ID = i;
         textItem.screenCenter(X);
         add(textItem);
         var creditsTextItem:CreditsText = new CreditsText(textItem, true);
         creditsTextGroup.push(creditsTextItem);
      }

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
						var speed = 0.3;
						var scaledY = FlxMath.remapToRange(creditsText.selectionId, 0, 1, 0, 1.3);
						creditsText.text.y = FlxMath.lerp(creditsText.text.y, (scaledY * 75) + (FlxG.height * 0.5), speed);
					}
				}
				if (upPressed)
				{
					changeSelection(-1);
				}
				if (downPressed)
				{
					changeSelection(1);
				}
				if (back)
				{
					FlxG.switchState(new MainMenuState());
				}
				if (accept && !creditsTextGroup[curNameSelected].menuItem)
				{
					trace('Pressed this text that says: ' + creditsTextGroup[curNameSelected].text);
					selectPerson(peopleInCredits[curNameSelected]);
					state = State.OnName;
               FlxG.mouse.visible = true;
				}
         case State.OnName:
            if (back)
            {
               state = State.SelectingName;
            }
      }
      
      super.update(elapsed);
   }

   function changeSelection(amount:Int)
   {
      FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
      curNameSelected += amount;
      
      if (curNameSelected > peopleInCredits.length)
      {
         curNameSelected = 0;
      }
      if (curNameSelected < 0)
      {
         curNameSelected = peopleInCredits.length;
      }
      var selection:Int = 0;
      for (creditsText in creditsTextGroup)
      {
         creditsText.selectionId = selection - curNameSelected;
         selection++;
      }
      var currentText:FlxText = creditsTextGroup[curNameSelected].text;
      currentText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
      for (i in 0...creditsTextGroup.length)
      {
         if (creditsTextGroup[i] == creditsTextGroup[curNameSelected])
         {
            continue;
         }
         var currentText:FlxText = creditsTextGroup[i].text;
         currentText.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      }
   }

	override function beatHit()
	{

	}

   function selectPerson(selectedPerson:Person)
   {
      FlxTween.color(blackBg, 0.2, FlxColor.BLACK, FlxColor.fromRGBFloat(0, 0, 0, 200));
      var personName:FlxText = new FlxText(0, 100, 0, selectedPerson.name, 50);
      personName.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      personName.screenCenter(X);
      personName.alpha = 0;
      FlxTween.tween(personName, { alpha: 100}, 0.4);

      for (i in 0...selectedPerson.socialMedia.length)
      {
         var social:Social = selectedPerson.socialMedia[i];
         var socialButton:FlxButton = new FlxButton(0, i * 50, '', function() { FlxG.openURL(social.socialLink); });
         socialButton.label.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
         socialButton.screenCenter(X);
         switch (social.socialMediaName)
         {
            case 'youtube':
               socialButton.text = 'Youtube';
            case 'soundcloud':
               socialButton.text = 'Soundcloud';
               
         }
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