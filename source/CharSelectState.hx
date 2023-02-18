package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if sys
import sys.FileSystem;
#end
import lime.utils.Assets;

using StringTools;

class CharSelectState extends MusicBeatState
{
	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
    var index:Int;

    public var songName:FreeplayState.SongMetadata;

	override function create(name:FreeplayState.SongMetadata)
	{
        songName = name;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		add(bg);

        var boyfriend:Character = null;
        add(boyfriend);

		super.create();
        changeSelection();
	}

	override function update(elapsed:Float)
	{
        if(controls.ACCEPT) {
			FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.5, {ease: FlxEase.quadOut});
			var songLowercase:String = Paths.formatToSongPath(songName.songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songName.week;
			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			unloadAssets();
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			LoadingState.loadAndSwitchState(new PlayState());


			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
        if (controls.UI_LEFT_P)
			changeSelection(-1);
		if (controls.UI_RIGHT_P)
			changeSelection(1);
        
        if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

    function changeSelection(Number:Int)
    {
        index += Number;

        if (index < 0) index = 0;
        if (index > 1) index = 1;

        if (index == 1){
            remove(boyfriend);
            
            boyfriend = 'bf-car';

            add(boyfriend);
        }else{
            remove(boyfriend);
            
            boyfriend = 'bf';

            add(boyfriend);
        }

		FlxG.sound.play(Paths.sound('scrollMenu'));

    }
}

