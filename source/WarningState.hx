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
import flixel.util.FlxTimer;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

        leftState = false;

		var bg:FlxSprite = new FlxSprite(0, FlxG.height * 0.4).loadGraphic(Paths.image('pokehelldevs'));
        bg.alpha = 0;
		bg.scale.set(1.5,1.5);
        add(bg);

        FlxTween.tween(bg, {alpha: 1}, 15, {startDelay: 3});

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, thanks for "+
            #if !html5 "downloading the mod!"+ #else "playing the mod online!" #end
            "\n\nNobody records any footage on Youtube, so thanks for giving us a chance.\nBefore you continue, heads up that this mod contains some language that isn't suitable to younger audiences.\nAlso this mod has screen shaking that may trigger some users.\nYou can't disable these so be careful."+
            #if html5 "Also, consider downloading the mod on gamebanana to enjoy more of the mod,\nIt'd really help us out."+ #end
            "\nAlso remember to have fun playing <3 -The devs of pokehell\n\n(Press Enter to continue)",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter();
        bg.screenCenter();
        warnText.borderSize = 2;
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT || controls.BACK) {
				leftState = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
