package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class ShotTankmen extends FlxSprite{
    var runLeft:Bool;
    public function new (x:Float = 0, y:Float = 0, runLeft:Bool) {
        super(x, y);

        frames = Paths.getSparrowAtlas('tankmanKilled1', 'week7');
		animation.addByPrefix('run', 'tankman running', 24, true);
		animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
		animation.play('run');
		antialiasing = true;

        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            animation.play('shot');
            y -= 100;
        });

        this.runLeft = runLeft;
        if (runLeft == false) {
            flipX = true;
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (animation.curAnim.name != 'shot') {
            if (runLeft) {
                x -= 14;
            } else {
                x += 14;
            }
        }

        if (animation.curAnim.name == 'shot' && animation.curAnim.finished == true) {
            kill();
        }
    }
}