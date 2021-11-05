package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;

	public static var maniaSwitchPositions:Array<Dynamic> = [
		["NONE", "NONE", "NONE", "NONE", 0, "NONE", "NONE", "NONE", "NONE"],
        [0, "NONE", "NONE", 1, "NONE", "NONE", "NONE", "NONE", "NONE"],
        [0, "NONE", "NONE", 2, 1, "NONE", "NONE", "NONE", "NONE"],
        [0, 1, 2, 3, "NONE", "NONE", "NONE", "NONE", "NONE"],
        [0, 4, 1, 2, "NONE", 3, "NONE", "NONE", 5],
        [0, 1, 2, 3, 4, 5, 6, 7, 8],
        [0, 1, 3, 4, 2, "NONE", "NONE", "NONE", "NONE"],
        [0, 5, 1, 2, 3, 4, "NONE", "NONE", 6],
        [0, 1, 2, 3, "NONE", 4, 5, 6, 7]
    ];

	public var defaultY:Float;
	public var defaultX:Float;

	public function new(x:Float, y:Float, leData:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		super(x, y);
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		updateHitbox();
		offset.x = frameWidth / 2;
		offset.y = frameHeight / 2;

		offset.x -= 156 * Note.scales[PlayState.SONG.mania] / 2;
		offset.y -= 156 * Note.scales[PlayState.SONG.mania] / 2;
		if(animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;
		}
	}

	public function movePos(spr:FlxSprite, value:Int, player:Int):Void 
		{
			spr.x = ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X;
			
			spr.alpha = 1;
			
			if (maniaSwitchPositions[value][spr.ID] == "NONE")
			{
				spr.alpha = 0.6;
			}            
			else
			{
				spr.x += Note.swidths[value] * maniaSwitchPositions[value][spr.ID];
			}
				
			spr.x += 50;
			spr.x += ((FlxG.width / 2) * player);
			spr.x -= Note.posRest[value];
	
			defaultX = spr.x;
			trace(spr.x);
		}
}