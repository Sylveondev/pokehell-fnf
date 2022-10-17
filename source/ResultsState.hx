package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class ResultsState extends MusicBeatState
{
    var daScore:Float = 0;
	public var scoretxt:FlxText;
	public var realscoretxt:FlxText;
	public var weektitle:FlxText;
	public var entertocont:FlxText;
    public var boyfriend:Character;

    var candance:Bool = true;

	var lerpScore:Float = 0;

    override function create()
	{
        Conductor.changeBPM(100);
		persistentUpdate = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menu'+ FlxG.random.int(0, 5) +'Desat'));
		bg.scrollFactor.set();
		bg.color = 0xFF74C2C1;
		add(bg);
        
        scoretxt = new FlxText(FlxG.height / 2, FlxG.height / 2, 0, '?', 20);
		scoretxt.setFormat(Paths.font("righteous.ttf"), 460, FlxColor.fromString('0xFFFFFFFF'), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoretxt.borderSize = 12;
        scoretxt.scrollFactor.set();
        scoretxt.screenCenter();
        add(scoretxt);
        scoretxt.alpha = 16;

        weektitle = new FlxText(FlxG.height / 2, 10, 0, '?', 20);
		weektitle.setFormat(Paths.font("righteous.ttf"), 100, FlxColor.fromString('0xFFFFFFFF'), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		weektitle.borderSize = 4;
        weektitle.scrollFactor.set();
        weektitle.screenCenter(X);
        add(weektitle);

        realscoretxt = new FlxText(FlxG.height / 2, FlxG.height / 2, 0, 'Accuracy: 0%', 20);
		realscoretxt.setFormat(Paths.font("righteous.ttf"), 50, FlxColor.fromString('0xFFFFFFFF'), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		realscoretxt.borderSize = 2;
        realscoretxt.scrollFactor.set();
        realscoretxt.screenCenter(X);
        add(realscoretxt);

        if (PlayState.isStoryMode){
            weektitle.text = WeekData.getCurrentWeek().weekName;
        }else{
            weektitle.text = PlayState.SONG.song.toLowerCase();
        }
        weektitle.screenCenter(X);

        entertocont = new FlxText(FlxG.height / 2, FlxG.height / 2, 0, 'Press enter to continue...', 20);
		entertocont.setFormat(Paths.font("righteous.ttf"), 50, FlxColor.fromString('0xFFFFFFFF'), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		entertocont.borderSize = 2;
        entertocont.scrollFactor.set();
        entertocont.screenCenter(X);
        add(entertocont);
        entertocont.alpha = 0;
		entertocont.y = FlxG.height * 0.9;
        realscoretxt.y = FlxG.height * 0.8;

        boyfriend = new Character(FlxG.height / 2, FlxG.width / 2, PlayState.SONG.player1, true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.8));
        boyfriend.screenCenter();
		boyfriend.updateHitbox();
		boyfriend.dance();
        boyfriend.alpha = 0;
		add(boyfriend);

        trace(boyfriend.scale.y);
        trace(boyfriend.y);

        
        FlxTween.tween(scoretxt,{angle: -16}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});

        

		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Results Menu", null);
		#end

		

        FlxTween.tween(scoretxt,{x: (FlxG.height / 2 - 200)}, 2, {ease: FlxEase.quadInOut, startDelay: 1});
        FlxTween.tween(boyfriend,{alpha: 1, x: (FlxG.height / 2 + 300)}, 2, {ease: FlxEase.quadInOut, startDelay: 1});
        FlxTween.tween(entertocont,{alpha: 1}, 2, { 
            onComplete: function(twn:FlxTween){
                FlxTween.tween(entertocont,{alpha: 0.25}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
                calculateRating();
            },
            ease: FlxEase.quadInOut,
            startDelay: 1
        });
        
		super.create();
	}

    function calculateRating(){
        daScore = (PlayState.usedPractice ? 0 : Math.floor(PlayState.ratingPercentStatic * 100));

        new FlxTimer().start(0.75, function(tmr:FlxTimer)
            {
                if (daScore < 63){
                    scoretxt.text = "F";
                    FlxG.camera.shake(0.25, 0.1);
			        FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			        boyfriend.playAnim('singDOWN', true);
                    //If the bf doesn't have a miss animation, this won't fire
			        boyfriend.playAnim('singDOWN' + 'miss', true);
                    candance = false;
                }
                else if (daScore > 62 && daScore < 73){
                    scoretxt.text = "D";
			        FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			        boyfriend.playAnim('singDOWN', true);
                    candance = false;
                }
                else if (daScore > 72 && daScore < 83){
                    scoretxt.text = "C";
                }
                else if (daScore > 82 && daScore < 90){
                    scoretxt.text = "B";
			        boyfriend.playAnim('singUP', true);
                    candance = false;
                }
                else if (daScore > 89 && daScore < 96){
                    scoretxt.text = "A";
			        FlxG.sound.play(Paths.sound('hey'), 0.7);
                    FlxG.camera.flash(FlxColor.WHITE, 1);
			        boyfriend.playAnim('singUP', true);
			        boyfriend.playAnim('hey', true);
                    candance = false;
                }else if (daScore > 95 && daScore < 98){
                    scoretxt.text = "S";
			        FlxG.sound.play(Paths.sound('titleShoot'), 0.7);
			        FlxG.sound.play(Paths.sound('hey'), 0.7);
                    FlxG.camera.flash(FlxColor.WHITE, 1);
                    FlxTween.tween(FlxG.camera, {zoom: 2}, 0.5,{type:BACKWARD});
			        boyfriend.playAnim('singUP', true);
			        boyfriend.playAnim('hey', true);
                    candance = false;
                }else if (daScore > 97){
                    scoretxt.text = "S+";
			        FlxG.sound.play(Paths.sound('titleShoot'), 0.7);
			        FlxG.sound.play(Paths.sound('hey'), 0.7);
                    FlxG.camera.flash(FlxColor.WHITE, 1);
                    FlxTween.tween(FlxG.camera, {zoom: 2}, 0.5,{type:BACKWARD});
			        boyfriend.playAnim('singUP', true);
			        boyfriend.playAnim('hey', true);
                    candance = false;
                }
				

            });
    }

	override function update(elapsed:Float)
	{
        super.update(elapsed);

        if (boyfriend.scale.y < 0.854014598540146){
            boyfriend.scale.set(boyfriend.scale.x + 0.01, boyfriend.scale.y + 0.01);
        }else if (boyfriend.scale.y > 0.854014598540146){
            boyfriend.scale.set(boyfriend.scale.x - 0.01, boyfriend.scale.y - 0.01);
        }

        if (boyfriend.y < 142.5){
            boyfriend.y += 0.5;
        }else if (boyfriend.y > 142.5){
            boyfriend.y -= 0.5;
        }

        if (lerpScore < daScore && lerpScore < 101){
            lerpScore += 1;
        }
        if (lerpScore > daScore && daScore > -1){
            lerpScore -= 1;
        }
        realscoretxt.text = 'Accuracy: ' + lerpScore +"%"+(PlayState.usedPractice ? '\nCheats used':'');
        realscoretxt.screenCenter(X);
        if (Math.abs(lerpScore - daScore) <= 10)
			lerpScore = daScore;
		realscoretxt.text = 'Accuracy: ' + lerpScore +"%";
        realscoretxt.screenCenter(X);
        
        if(candance == true && boyfriend != null && boyfriend.animation.curAnim.finished) {
			boyfriend.dance();
		}


		if (controls.BACK || controls.ACCEPT)
		{
    		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
            if (PlayState.isStoryMode == false){
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			    MusicBeatState.switchState(new FreeplayState());
            }else{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			    MusicBeatState.switchState(new StoryMenuState());
            }
		}
    }
}