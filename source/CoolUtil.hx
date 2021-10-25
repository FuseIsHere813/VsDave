package;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD","LEGACY"];

	public static function difficultyString():String
	{
		switch (PlayState.storyWeek)
		{
			case 3:
				return 'FINALE';
			default:
				return difficultyArray[PlayState.storyDifficulty];
		}
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
	public static function formatString(string:String):String
		{
			 var split:Array<String> = string.split('-');
			 var formattedString:String = '';
			 for (i in 0...split.length) 
			 {
				  var piece:String = split[i];
				  var allSplit = piece.split('');
				  var firstLetterUpperCased = allSplit[0].toUpperCase();
				  var substring = piece.substr(1, piece.length - 1);
				  var newPiece = firstLetterUpperCased + substring;
				  if (i != split.length - 1)
				  {
						newPiece += " ";
				  }
				  formattedString += newPiece;
			 }
			 return formattedString;
		}
}
