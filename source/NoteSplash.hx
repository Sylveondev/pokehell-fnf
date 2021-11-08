package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public static var scales:Array<Float> = [0.85, 0.8, 0.75, 0.7, 0.66, 0.6, 0.55, 0.50, 0.46];
	public static var swidths:Array<Float> = [141, 124, 116, 108, 102, 93, 85, 77, 71];
	public static var posRest:Array<Int> = [0, 0, 0, 0, 25, 35, 50, 60, 70];

	var ogW:Float;
	var ogH:Float;

	var mania:Int;

	public function new(x:Float = 0, y:Float = 0, noteData:Int = 0) {
		super(x, y);

		ogW = width;
		ogH = height;

		mania = PlayState.SONG.mania;

		setupNoteSplash(x, y, noteData);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, noteData:Int = 0) {
		frames = Paths.getSparrowAtlas('noteSplashes');
		for (i in 0...9) {
			animation.addByPrefix(Main.gfxLetter[i], 'note splash ' + Main.gfxLetter[i], 24, false);
		}

		//alpha = 0.6;

		ogW = width;
		ogH = height;

		mania = PlayState.SONG.mania;

		setGraphicSize(Std.int(ogW * scales[PlayState.SONG.mania]), Std.int(ogH * scales[PlayState.SONG.mania]));

		animation.play(Main.gfxLetter[Main.gfxIndex[mania][noteData]]);

		switch (mania) {
			case 0: setPosition(x - swidths[mania] + 50, y - swidths[mania] + 50);
			case 1: setPosition(x - swidths[mania] + 30, y - swidths[mania] + 30);
			case 2:	setPosition(x - swidths[mania] + 12, y - swidths[mania] + 12);
			case 3 | 4: setPosition(x - swidths[mania] + 10, y - swidths[mania]);
			case 5:	setPosition(x - swidths[mania] - 5, y - swidths[mania] - 5);
			case 6: setPosition(x - swidths[mania] - 20, y - swidths[mania] - 20);
			case 7: setPosition(x - swidths[mania] - 28, y - swidths[mania] - 28);
			case 8: setPosition(x - swidths[mania] - 35, y - swidths[mania] - 35);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}