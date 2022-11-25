package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;


class StartState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

        leftState = false;

		/*var bg = new FlxBackdrop(Paths.image('OldSally16'), 0, 0, true, true);
		bg.velocity.set(50, 25);
        bg.alpha = 0.25;
        add(bg);

        FlxTween.tween(bg, {alpha: 1}, 15, {startDelay: 3});*/

		warnText = new FlxText(0, 0, FlxG.width,
			"Warning:\nThis mod contains some loud sounds, spam,\nprobably flashing lights, some swearing,\nand a whole lot of awesomeness.\n\nYou have been warned,\n(Press Enter to continue)",
			32);
		warnText.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter();
        //bg.screenCenter();
        warnText.borderSize = 2;
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (FlxG.keys.justPressed.ENTER) {
				leftState = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxTween.tween(FlxG.camera, {zoom: 0.2}, 1, {ease: FlxEase.quadIn,startDelay: .5});
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
                        MusicBeatState.switchState(new TitleState());
                    }
				});
			}
		#if mobile
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
				{
					leftState = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
					FlxTween.tween(FlxG.camera, {zoom: 0.2}, 1, {ease: FlxEase.quadIn,startDelay: .5});
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		#end
		}
		super.update(elapsed);
	}
}
