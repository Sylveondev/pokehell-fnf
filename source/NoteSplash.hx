package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
/**
 * I tried
 */
class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var lastNoteType:Int = -1;

	public static var scales:Array<Float> = [0.85, 0.8, 0.75, 0.7, 0.66, 0.6, 0.55, 0.50, 0.46];
	public static var swidths:Array<Float> = [210, 190, 170, 160, 150, 120, 110, 95, 90];
	public static var posRest:Array<Int> = [0, 0, 0, 0, 25, 35, 50, 60, 70];

	var onekey:Array<String> = ['center'];
	var twokey:Array<String> = ['purple', 'red'];
	var threekey:Array<String> = ['purple', 'center', 'red'];
	var fourkey:Array<String> = ['purple', 'blue', 'green', 'red'];
	var fivekey:Array<String> = ['purple', 'blue', 'center', 'green', 'red'];
	var sixKey:Array<String> = ['purple', 'green', 'red', 'yellow', 'blue', 'darkblue'];
	var sevenkey:Array<String> = ['purple', 'green', 'red', 'center', 'yellow', 'blue', 'darkblue'];
	var eightkey:Array<String> = ['purple', 'blue', 'green', 'red', 'yellow', 'darkpurple', 'twored', 'darkblue'];
	var ninekey:Array<String> = ['purple', 'blue', 'green', 'red', 'center', 'yellow', 'darkpurple', 'twored', 'darkblue'];

	public function new(x:Float = 0, y:Float = 0, noteData:Int) {
		super(x, y);

		setupNoteSplash(x, y, noteData);
	}

	public function setupNoteSplash(x:Float, y:Float, noteData:Int) {
		frames = Paths.getSparrowAtlas('noteSplashes');
		antialiasing = true;
		setPosition(x - Note.swagWidth * 0.95 - 85, y - Note.swagWidth - 95);

		var ogW = width;
		var ogH = height;
		var mania = PlayState.SONG.mania;

		x += swidths[mania] * Note.swagWidth - 30;
		setGraphicSize(Std.int(ogW * scales[PlayState.SONG.mania]), Std.int(ogH * scales[PlayState.SONG.mania]));

		alpha = 1;

		var prefix = 'note splash ';
		switch (mania) {
			case 0:
				for (i in 0...onekey.length) animation.addByPrefix(onekey[i], prefix + onekey[i], 24, false);
				animation.play(onekey[noteData]);
			case 1:
				for (i in 0...twokey.length) animation.addByPrefix(twokey[i], prefix + twokey[i], 24, false);
				animation.play(twokey[noteData]);
			case 2:
				for (i in 0...threekey.length) animation.addByPrefix(threekey[i], prefix + threekey[i], 24, false);
				animation.play(threekey[noteData]);
			case 3:
				for (i in 0...fourkey.length) animation.addByPrefix(fourkey[i], prefix + fourkey[i], 24, false);
				animation.play(fourkey[noteData]);
			case 4:
				for (i in 0...fivekey.length) animation.addByPrefix(fivekey[i], prefix + fivekey[i], 24, false);
				animation.play(fivekey[noteData]);
			case 5:
				for (i in 0...sixKey.length) animation.addByPrefix(sixKey[i], prefix + sixKey[i], 24, false);
				animation.play(sixKey[noteData]);
			case 6:
				for (i in 0...sevenkey.length) animation.addByPrefix(sevenkey[i], prefix + sevenkey[i], 24, false);
				animation.play(sevenkey[noteData]);
			case 7:
				for (i in 0...eightkey.length) animation.addByPrefix(eightkey[i], prefix + eightkey[i], 24, false);
				animation.play(eightkey[noteData]);
			case 8:
				for (i in 0...ninekey.length) animation.addByPrefix(ninekey[i], prefix + ninekey[i], 24, false);
				animation.play(ninekey[noteData]);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}