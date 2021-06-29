import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Song.SwagSong;

class WarningState extends MusicBeatState
{

    override function create()
    {
        super.create();
        PlayState.warningNeverDone = false;
        var text:FlxText = new FlxText(0, 0, FlxG.width,
            "WARNING!!! \nThe charts for the following songs are jokes. \nThey are not meant to be taken seriously. \nPress Enter to continue to the song if you understand.",
            32);
        text.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
        text.screenCenter();
        add(text);
    }
    override function update(elapsed:Float)
    {
        if(controls.PAUSE)
        {
            if(PlayState.SONG.song.toLowerCase() == "supernovae")
            {
                var dontdelete:String = Highscore.formatSong("supernovae", 2);
			PlayState.SONG = Song.loadFromJson(dontdelete, "supernovae");
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
            PlayState.warningNeverDone = true;
			LoadingState.loadAndSwitchState(new PlayState());
            }
            else if(PlayState.SONG.song.toLowerCase() == "glitch")
            {
                var dontdelete:String = Highscore.formatSong("glitch", 2);
			PlayState.SONG = Song.loadFromJson(dontdelete, "glitch");
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
            PlayState.warningNeverDone = true;
			LoadingState.loadAndSwitchState(new PlayState());
            }
        }
        super.update(elapsed);
    }
}