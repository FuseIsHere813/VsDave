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
      
      var developers:Array<Person>;
      var betaTesters:Array<Person>;
      var contributors:Array<Person>;

      for (i in 0...peopleInCredits.length) 
      {
         switch (peopleInCredits[i].creditsType)
         {
            case Dev: developers.push(peopleInCredits[i]);
            case BetaTester: betaTesters.push(peopleInCredits[i]);
            case Contributor: contributors.push(peopleInCredits[i]);
         }
      }

      //Add Dev Text

      //Add Developer Names

		super.create();
	}
   
	override function update(elapsed:Float)
   {
      var upPressed = controls.UP_P;
      var downPressed = controls.DOWN_P;

      super.update(elapsed);
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