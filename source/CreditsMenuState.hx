package;

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
import flixel.util.FlxStringUtil;
import lime.utils.Assets;

using StringTools;

class CreditsMenuState extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));

   var currentY:Float;
   var curNameSelected:Int;
   var textGroup:FlxTypedGroup<FlxText>;

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
    ];

	override function create()
	{
      bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);
      
      var developers:Array<Person> = new Array<Person>();
      var betaTesters:Array<Person> = new Array<Person>();
      var contributors:Array<Person> = new Array<Person>();

      for (i in 0...peopleInCredits.length) 
      {
         switch (peopleInCredits[i].creditsType)
         {
            case Dev: developers.push(peopleInCredits[i]);
            case BetaTester: betaTesters.push(peopleInCredits[i]);
            case Contributor: contributors.push(peopleInCredits[i]);
         }
      }

      var developersTitleText:FlxText = new FlxText(0, 0, 0, 'Developers', 16);
      for (i in 0...developers.length)
      {
         var textItem:FlxText = new FlxText(0, 1 + (i * 50), 0, developers[i].name, 8);
         textGroup.add(textItem);
      }
      textGroup.add(developersTitleText);
		super.create();
	}
   
	override function update(elapsed:Float)
   {
   
      var upPressed = controls.UP_P;
      var downPressed = controls.DOWN_P;

      for (text in textGroup)
      {
         

         var scaledY = FlxMath.remapToRange(text.ID, 0, 1, 0, 1.3);

		   text.y = FlxMath.lerp(text.y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
		   text.x = FlxMath.lerp(text.x, (text.ID * 20) + 90, 0.16);
      }
      
      
      super.update(elapsed);
   }

   function changeSelection(amount:Int)
   {
      FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
      curNameSelected += amount;
      
      if (curNameSelected >= peopleInCredits.length)
      {
         curNameSelected = 0;
      }
      if (curNameSelected < 0)
      {
         curNameSelected = peopleInCredits.length - 1;
      }

      var randomThing:Int = 0;
      for (text in textGroup)
      {
         randomThing++;
         text.ID = randomThing - curNameSelected;
      }
   }

	override function beatHit()
	{

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
enum CreditsType
{
   Dev; BetaTester; Contributor;
}