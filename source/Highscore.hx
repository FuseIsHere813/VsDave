package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songChars:Map<String, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songChars:Map<String, String> = new Map<String,String>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?char:String = "bf"):Void
	{
		var daSong:String = formatSong(song, diff);
		trace("saveScore" + daSong);

		#if !switch
		NGio.postScore(score, song);
		#end


		if (songScores.exists(daSong))
			{
				if (songScores.get(daSong) < score)
				{
					setScore(daSong, score,char);
				}
			}
			else
			{
				setScore(daSong, score,char);
			}
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0, ?char:String = "bf"):Void
		{
	
			#if !switch
			NGio.postScore(score, "Week " + week);
			#end
	
	
			var daWeek:String = formatSong('week' + week, diff);
	
			if (songScores.exists(daWeek))
			{
				if (songScores.get(daWeek) < score)
				{
					setScore(daWeek, score,char);
				}
			}
			else
			{
				setScore(daWeek, score,char);
			}
		}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	public static function setScore(song:String, score:Int, char:String):Void
	{
		trace("setscore " + song);
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		songChars.set(song,char);
		FlxG.save.data.songScores = songScores;
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	static function setChar(song:String, char:String):Void
	{
		trace("setchar " + song + ":" + char);
		songChars.set(song,char);
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';
		else if (diff == 3)
			daSong += '-unnerf';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
		{
			if (!songScores.exists(formatSong(song, diff)))
			{
				setScore(formatSong(song, diff), 0, "bf");
			}
			return songScores.get(formatSong(song, diff));
		}

		public static function getChar(song:String, diff:Int):String
			{
				if (songChars == null)
					return "ERROR";
				if (!songChars.exists(formatSong(song, diff)))
				{
					setChar(formatSong(song, diff),"bf");
					return "bf";
				}
				return songChars.get(formatSong(song, diff));
			}

			public static function getWeekScore(week:Int, diff:Int):Int
				{
					if (!songScores.exists(formatSong('week' + week, diff)))
					{
						setScore(formatSong('week' + week, diff), 0, "bf");
					}
					return songScores.get(formatSong('week' + week, diff));
				}

				public static function getWeekChar(week:Int, diff:Int):String
					{
						if (!songScores.exists(formatSong('week' + week, diff)))
						{
							setChar(formatSong('week' + week, diff),"bf");
							return "bf";
						}
						return songChars.get(formatSong('week' + week, diff));
					}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songNames != null)
		{
			songChars = FlxG.save.data.songNames;
		}
	}
}
