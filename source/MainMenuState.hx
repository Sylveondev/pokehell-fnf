package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import haxe.macro.Compiler;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var sallyEngineVersion:String = 'B1'; //This is also used for Discord RPC
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	
	public static var gitCommit:String = '';
	public static var isGitRelease:Bool = false;
	
	public static var pokehellVersion:String = #if DEVBUILD 'pre-1.4' #else '1.4' #end; //This is also used for Discord RPC

	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'extras', 'options'];
	var extrasShit:Array<String> = [#if ACHIEVEMENTS_ALLOWED 'awards', #end 'credits', #if !switch 'discord', #end #if !switch 'donate' #end];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var trackedAssets:Array<Dynamic> = [];
	var camFollowPos:FlxObject;

	var extrasSelected:Bool = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];


		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var imgthingy:String = 'menus/menu'+ FlxG.random.int(0, 5) +'Desat';

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image(imgthingy));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.color = 0x840000;
		add(bg);

		FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.quadInOut, type: BACKWARD});

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image(imgthingy));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xE40000;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		var invert = 1;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		var secretX:Float;
		menuItems.forEach(function(spr:FlxSprite){
			secretX = spr.x;
			invert *=  -1;
			spr.x = secretX + (256 * invert);
			spr.alpha = 0;
			FlxTween.tween(spr, {x: secretX}, 3,{ease: FlxEase.elasticOut, startDelay:0.5});
			FlxTween.tween(spr, {alpha: 1}, 3,{ease: FlxEase.quadOut, startDelay:0.5});
		});

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - #if !DEVBUILD 44 #else 64 #end, 0, "Psych Engine " + psychEngineVersion +" - " + sallyEngineVersion + " Sally Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("righteous.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - #if !DEVBUILD 24 #else 44 #end, 0, "Pokehell mod " + pokehellVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("righteous.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#if DEVBUILD
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Github commit: git@" + Compiler.getDefine('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("righteous.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end
		
		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		#if mobileC
		addVirtualPad(UP_DOWN, A_B_C);
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	function summonExtras(){
		if (extrasSelected == false){
		menuItems.forEach(function(spr:FlxSprite) {
			spr.kill();
		});

		for (i in 0...extrasShit.length)
			{
				var offset:Float = 108 - (Math.max(extrasShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + extrasShit[i]);
				menuItem.animation.addByPrefix('idle', extrasShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', extrasShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				var scr:Float = (extrasShit.length - 4) * 0.135;
				if(extrasShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();
			}
	
			var secretX:Float;
			var invert = 1;
			menuItems.forEach(function(spr:FlxSprite){
				secretX = spr.x;
				invert *=  -1;
				spr.x = secretX + (256 * invert);
				spr.alpha = 0;
				FlxTween.tween(spr, {x: secretX}, 3,{ease: FlxEase.elasticOut, startDelay:0.5});
				FlxTween.tween(spr, {alpha: 1}, 3,{ease: FlxEase.quadOut, startDelay:0.5});
			});

			selectedSomethin = false;
			extrasSelected = true;
			changeItem();
			FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.quadOut});

	}}

	function summonOptions(){
		if (extrasSelected == true){
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('cancelMenu'));

		var invert = 1;
		menuItems.forEach(function(spr:FlxSprite)
		{
			invert *= -1;
			FlxTween.tween(spr, {x: (spr.x + (500 * invert)), alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					spr.kill();



					menuItems.forEach(function(spr:FlxSprite) {
						spr.kill();
					});
			
					for (i in 0...optionShit.length)
						{
							var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
							var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
							menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
							menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
							menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
							menuItem.animation.play('idle');
							menuItem.ID = i;
							menuItem.screenCenter(X);
							menuItems.add(menuItem);
							var scr:Float = (optionShit.length - 4) * 0.135;
							if(optionShit.length < 6) scr = 0;
							menuItem.scrollFactor.set(0, scr);
							menuItem.antialiasing = ClientPrefs.globalAntialiasing;
							//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
							menuItem.updateHitbox();
						}
				
						var secretX:Float;
						var invert = 1;
						menuItems.forEach(function(spr:FlxSprite){
							secretX = spr.x;
							invert *=  -1;
							spr.x = secretX + (256 * invert);
							spr.alpha = 0;
							FlxTween.tween(spr, {x: secretX}, 3,{ease: FlxEase.elasticOut, startDelay:0.5});
							FlxTween.tween(spr, {alpha: 1}, 3,{ease: FlxEase.quadOut, startDelay:0.5});
						});
			
						selectedSomethin = false;
						extrasSelected = false;
						changeItem();
						FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.quadOut});

				}
			});
		});
	}}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if (extrasSelected == true){
					summonOptions();
				}else
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (extrasSelected == false && optionShit[curSelected] == 'extras')
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));

					var invert = 1;
					menuItems.forEach(function(spr:FlxSprite)
					{
						invert *= -1;
						FlxTween.tween(spr, {x: (spr.x + (500 * invert)), alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								summonExtras();
								spr.kill();
							}
						});
					});
				}
				else if (extrasSelected == true && extrasShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else if (extrasSelected == true && extrasShit[curSelected] == 'discord')
				{
					CoolUtil.browserLoad('https://discord.gg/efE9c9AkWy');
				}
				else
				{
					FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.5, {ease: FlxEase.quadOut,startDelay: 0.75});

					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					var invert = 1;
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							invert *= -1;
							FlxTween.tween(spr, {x: (spr.x + (500 * invert)), alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String;
								if (extrasSelected == false) 
									daChoice = optionShit[curSelected]; 
								else 
									daChoice = extrasShit[curSelected]; 
								
								unloadAssets();

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplaySelectState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new OptionsState());
								}
							});
						}
					});
				}
			}
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		trace(curSelected);
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
	override function add(Object:flixel.FlxBasic):flixel.FlxBasic
		{
			trackedAssets.insert(trackedAssets.length, Object);
			return super.add(Object);
		}
	
		function unloadAssets():Void
		{
			if (ClientPrefs.optimization) {
				for (asset in trackedAssets)
					{
						remove(asset);
					}
			}
		}
}
