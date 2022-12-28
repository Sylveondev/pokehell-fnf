package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import Shaders.PulseEffect;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.Capabilities;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import flash.geom.Point;
import flash.filters.ColorMatrixFilter;
import flixel.addons.display.FlxBackdrop;
import shaders.*;
import openfl.filters.ShaderFilter;

import openfl.Lib.application;


#if sys
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public var iconrot = 1;
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;
	public static var defaultNotePos:Array<Dynamic> = [];

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	public static var botplayList:Array<String> = [
		"BOTPLAY",
		"YOU SUCK",
		"STOP USING BOTPLAY",
		"CHEATING",
		"DAVE AND BAMBI MOMENT",
		"Mr Krabs is a robot",
		"Death X-Gaming",
		"SYSTEM SENSOR MASS ADA",
		"POSSASSIUM HYPE",
		"STOP MODDING THE XBOX",
		"DIRTY CHEATER",
		"APERTURE SCIENCE",
		"TOO HARD FOR YOU?",
		"JOIN MY DISCORD DAMMIT",
		"Follow my twitter",
		"STRIDENT CRISIS",
		"Thearchy mode",
		"Beep boop",
		"MEE6",
		"Why botplay"
	];
	
	#if (haxe >= "4.0.0")
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	#else
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, Dynamic>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	#end

	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;

	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var freeplayChar:Bool = false;
	public static var selectedBF:String = 'bf';
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	var newManiaVal:Int;

	public static var mania:Null<Int> = 3;
	public static var uiColor:Null<FlxColor> = FlxColor.fromString('0xFFF5AA42');

	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var fakegf:Null<Character>;
	public var boyfriend:Boyfriend;

	public var player2:Null<Character>;
	public var player3:Null<Character>;
	public var player4:Null<Character>;
	public var player5:Null<Character>;
	public var player6:Null<Character>;
	public var player7:Null<Character>;
	public var player8:Null<Character>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<Dynamic> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;
	private static var resetSpriteCache:Bool = false;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;
	public var highestcombo:Int = 0;

	public var perfects:Int = 0;
	public var awesomes:Int = 0;
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	public static var cameramovingoffset = 40;
	public static var cameramovingoffsetbf = 40; // idk why i made literally same variable

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	public var timeBarColor:FlxSprite;

	public var healthBarOverlay:FlxSprite;
	public var timeBarOverlay:FlxSprite;


	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	private var startingSong:Bool = false;
	private var updateTime:Bool = false;
	public static var practiceMode:Bool = false;
	public static var usedPractice:Bool = false;
	public static var changedDifficulty:Bool = false;
	public static var cpuControlled:Bool = false;

	var botplaySine:Float = 0;
	var botplayTxt:FlxText;

	var trackedAssets:Array<FlxBasic> = [];
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 0.5;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;
	
	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var blingRoads:FlxTypedGroup<FlxBackdrop>;
	var blingSky:BGSprite;
	var blingGreen:BGSprite;

	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var oldBlammedLightsBlack:ModchartSprite;
	var blammedLightsblackTween:FlxTween;
	var oldBlammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;
	
	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyWindowEvent:BGSprite;

	var phillyGlowGradient:PhillyGlow.PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlow.PhillyGlowParticle>;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var trippyBG:BGSprite;
	var boxBG:BGSprite;
	var squad:BGSprite;

	var road:FlxBackdrop;
	var mountains:FlxBackdrop;
	var trees:FlxBackdrop;

	var stageBackgrounds:FlxTypedGroup<BGSprite>;

	var rematch:BGSprite;
	var rematchVignette:BGSprite;


	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var ghostMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;
	var uiType:Int = 0;

	var allNotesMs:Float = 0;
	var averageMs:Float = 0;
	var ranking:String = 'N/A';
	public static var soundPrefix:Null<String> = '';

	var msTimeTxt:FlxText;
	var msTimeTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	//week 7 related stuff
	var tankmanRun:FlxTypedGroup<ShotTankmen>;
	var tankRolling:FlxSprite;
	var tankClouds:FlxSprite;
	var tankSky:FlxSprite;
	var tankmout:FlxSprite;
	var tankmouwt:FlxSprite;
	var tancuk:FlxSprite;
	var smokeLeft:FlxSprite;
	var smokeRight:FlxSprite;
	var tanjcuk:FlxSprite;
	var tankmouthh:FlxSprite;
	var tankbop0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankSpeed:Float = FlxG.random.float(5, 7);
    var tankAngle:Float = FlxG.random.float(-90, 45);
	var tankX:Int = 400;
	//end (wow thats a lot)

	var bfCar:FlxSprite;


	public var defaultCamZoom:Float = 1.05;
	public var defaultHudZoom:Float = 1;

	public var hueRotation:Int = 0; // degrees. Tested with values from 0...359
	// cosA and sinA are in radians
	public var cosA:Float;
	public var sinA:Float;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var changedMania:Bool = false;

	public var inCutscene:Bool = false;
	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	var scoretable:FlxText;

	var writerbg:FlxSprite;
	var writertxt:FlxText;

	var unsupportedText:FlxText;

	var isTweeningCam:Array<Bool> = [false, false];

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var luaArray:Array<FunkinLua> = [];

	//Achievement shit
	var keysPressed:Array<Bool> = [false, false, false, false];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	public var coDark:FlxSprite;
	public var coGfTrail:FlxTrail;
	public var coBfTrail:FlxTrail;
	public var coDadTrail:FlxTrail;

	override public function create()
	{

		//Screw this garbage line.
		//I'm gonna play quem now because epic
		instance = this;

		//Initialize unused variables
		if (SONG.noBotplay != false && SONG.noBotplay != true) SONG.noBotplay = false;
		if (SONG.noPractice != false && SONG.noPractice != true) SONG.noPractice = false;
		if (SONG.forceMiddlescroll != false && SONG.forceMiddlescroll != true) SONG.forceMiddlescroll = false;
		if (SONG.forceGhostingOff != false && SONG.forceGhostingOff != true) SONG.forceGhostingOff = false;
		if (SONG.hideGF != false && SONG.hideGF != true) SONG.hideGF = false;
		if (SONG.disableChartEditor != false && SONG.disableChartEditor != true) SONG.disableChartEditor = false;
		
		uiColor = FlxColor.fromString('0xFFF5AA42');
		if (SONG.fontColor != null) uiColor = FlxColor.fromString(SONG.fontColor);
		if (uiColor == null) uiColor = FlxColor.fromString('0xFFF5AA42');

		//Reset ui shit
		soundPrefix = ((SONG.soundPrefix != null || SONG.soundPrefix != "") ? SONG.soundPrefix : '');
		if (soundPrefix == null) soundPrefix = '';
		
		uiType = 0;
		ratingStuff = [
			['You Suck!', 0.2], //From 0% to 19%
			['Shit', 0.4], //From 20% to 39%
			['Bad', 0.5], //From 40% to 49%
			['Bruh', 0.6], //From 50% to 59%
			['Meh', 0.69], //From 60% to 68%
			['Nice', 0.7], //69%
			['Good', 0.8], //From 70% to 79%
			['Great', 0.9], //From 80% to 89%
			['Sick!', 1], //From 90% to 99%
			['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
		];


		unsupportedText = new FlxText(-100, FlxG.width * 0.25, 1000, "This chart may not be compatible with pokehell.\nFix this by pressing 7 and change mania to 3.", 32);
		unsupportedText.setFormat(Paths.font("righteous.ttf"), 32, uiColor, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		unsupportedText.screenCenter(X);
		unsupportedText.scrollFactor.set();
		unsupportedText.borderSize = 2;
		if (SONG.mania < 0){
			
		}

		#if MODS_ALLOWED
		Paths.destroyLoadedImages(resetSpriteCache);
		#end
		resetSpriteCache = false;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		trace('Loaded song. Mania: '+SONG.mania);

		mania = SONG.mania;
		
		

		if (mania < 0 || mania == null){
			mania = 3;
			add(unsupportedText);
		}
		trace('Mania is '+mania);

		iconrot = 1;

		rotCam = false;
		camera.angle = 0;
		
		swayNotes = false;

		practiceMode = false;
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		rotCamHud = false;
		camHUD.angle = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);
		

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = '' + CoolUtil.difficultyStuff[storyDifficulty][0];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);
		curStage = PlayState.SONG.stage.toLowerCase();
		trace('stage is: ' + curStage);
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				case 'smoking' | 'baked':
					curStage = 'ally';
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ugh' | 'guns' | 'stress':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100]
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		defaultHudZoom = 1;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if (ClientPrefs.overrideScroll) SONG.speed = ClientPrefs.scrollspeed;

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);

				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}
			
			case 'ally': //Week 1: Vaporeon
				var bg:BGSprite = new BGSprite('ally', -600, -200, 1, 1);
				add(bg);

			case 'greenally': //Secret Week 1: Denis
				var bg:BGSprite = new BGSprite('greenally', -600, -200, 1, 1);
				add(bg);

			case 'creepyhouse': //Secret Week 1: Denis
				var bg:BGSprite = new BGSprite('cursedHouse', -600, -180, 0.8, 0.8);
				add(bg);
			
			case 'sytrus': //Secret Week 1: Denis
				trippyBG = new BGSprite('SytrusStage', -100, -50, 0, 0, ['animated'], false, 12);
				add(trippyBG);
			case 'stage2': //Week 2: Jolteon
				var bg:BGSprite = new BGSprite('stage2', -600, -200, 1, 1);
				add(bg);

			case 'hell': //Week 3: Flareon
				var bg:BGSprite = new BGSprite('hell', -600, -200, 1, 1);
				add(bg);

			case 'icecave': //Week 4: Glaceon
				var bg:BGSprite = new BGSprite('icecave', -600, -200, 1, 1);
				add(bg);

			case 'house': //Unused stage for Week 5: Sylveon
				var bg:BGSprite = new BGSprite('house', -600, -200, 1, 1);
				add(bg);

			case 'mountains': //Week 6: Potassium
				var bg:BGSprite = new BGSprite('mountains', -600, -200, 1, 1);
				add(bg);

			case 'lightning': //Week 6: Potassium
				var bg:BGSprite = new BGSprite('lightning', -600, -200, 1, 1);
				add(bg);

			case 'rematch': //Week 11: Floombo's rematch week
				//Yessss. The background
				rematch = new BGSprite('rematch', -1000, -550, 1, 1);
				rematch.scale.set(1.4, 1.4);
				rematch.updateHitbox();
				add(rematch);

				//Load in the vignette.
				rematchVignette = new BGSprite('rematchVignette', -1000, -550, 0.9, 0.9);
				rematchVignette.scale.set(1.4, 1.4);
				rematchVignette.updateHitbox();
				add(rematchVignette);
				//These values clears after the sprites are loaded in.
				//That's just haxe.

				//These load if low quality is turned off.
				//aka, nvidia rtx 60fps 4k hdr
				//Not supported on chrome os :trol:
				if (!ClientPrefs.lowQuality){
					//Do a for loop for 3 empty sprites. How fun.
					//The values below will go in the for loop
					//Yeah ik these look really complex, but listen.
					//These will work. I'm not stopping till they do.
					var daPosValues:Array<Dynamic> = [[-125, -100, 0.9, 1.1],[1225, -100, 0.9, 1.1],[-500, -300, 1.3, 0.9]];
					for (i in 0...2){
						var empty:BGSprite = new BGSprite('empty', daPosValues[i][0], daPosValues[i][1], daPosValues[i][2], daPosValues[i][2]);
						empty.scale.set(daPosValues[i][3],daPosValues[i][3]);
						empty.updateHitbox();
						add(empty);

						//Weird thingy, causes an error so I omitted it.
						//if (i == 1) stagelight_right.flipX = true;
					}
				}

				

			case 'trippy': //Bonus
				
				trippyBG = new BGSprite('trippy', -600, -200, 1, 1.3);
				add(trippyBG);

				//This was originally gonna make the stage change colors
				//but this lagged the game alot, so it was scrapped.
				//Have dave and bambi instead.
				hueRotation = 25; 
				// Values from 0...359 will work.
				// cosA and sinA are in radians
				cosA = Math.cos(hueRotation * Math.PI / 180);
				sinA = Math.sin(hueRotation * Math.PI / 180);
			
			case 'treehouse': //Week 10: Eeveelution squad
				var bg:BGSprite = new BGSprite('treehouseback', -600, -200, 0.9, 0.9);
				var front:BGSprite = new BGSprite('treehousefront', -650, 550, 0.9, 0.9);
				front.setGraphicSize(Std.int(front.width * 1.1));
				
				add(bg);
				add(front);

				if (SONG.song.toLowerCase() == 'my-friends'||SONG.song.toLowerCase() == 'speeding'){
					trace('Eeveelution squad lol');

					squad = new BGSprite('squad',  350, 450, 0.9, 0.9);
					squad.setGraphicSize(Std.int(squad.width * 2.3));

					add(squad);
				}

				case 'treehouseb': //Week 10: Eeveelution squad
				var bg:BGSprite = new BGSprite('treehousebback', -600, -200, 0.9, 0.9);
				var front:BGSprite = new BGSprite('treehousebfront', -650, 600, 0.9, 0.9);
				front.setGraphicSize(Std.int(front.width * 1.1));
				
				add(bg);
				add(front);

				case '27': //Week 10: Eeveelution squad
				var bg:BGSprite = new BGSprite('27back', -600, -200, 0.9, 0.9);
				var front:BGSprite = new BGSprite('27front', -650, 600, 0.9, 0.9);
				front.setGraphicSize(Std.int(front.width * 1.1));
				
				add(bg);
				add(front);
			
			default:
				boxBG = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				boxBG.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				
				add(boxBG);
				if (SONG.song.toLowerCase() == 'forgotten'){
					boxBG.alpha = 0;
				}
			case 'sally':

				var bg:BGSprite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				bg.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFFB96414);
				add(bg);

				if (!ClientPrefs.lowQuality){
					var road = new FlxBackdrop(Paths.image('OldSally16'), 0, 0, true, true);
					road.velocity.set(100, 100);
					road.updateHitbox();
					road.scrollFactor.set(0.5, 0.5);
					road.antialiasing = ClientPrefs.globalAntialiasing;
					add(road);

					var road = new FlxBackdrop(Paths.image('OldSally4'), 0, 0, true, true);
					road.velocity.set(50, 50);
					road.updateHitbox();
					road.scrollFactor.set(0.75, 0.75);
					road.antialiasing = ClientPrefs.globalAntialiasing;
					add(road);
				}

				var road = new FlxBackdrop(Paths.image('OldSally'), 0, 0, true, true);
				road.velocity.set(25, 25);
				road.updateHitbox();
				road.scrollFactor.set(1, 1);
				road.antialiasing = ClientPrefs.globalAntialiasing;
				add(road);

				var bg:BGSprite = new BGSprite('sallyMap', -600, -200, 1, 1);
				add(bg);

			case 'box': //Week 9: Espeon
				if (SONG.song.toLowerCase() == 'crossover'){
					coDark = new FlxSprite(0,0).loadGraphic(Paths.image('lightgradient'));
					coDark.cameras = [camOther];
					coDark.visible = false;
					add(coDark);

					addCharacterToList('bfGray', 0);
					var bg:BGSprite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
					bg.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFFA0A0A0);
					add(bg);
					boxBG = new BGSprite('box-alt', -600, -200, 1, 1);
				}else
					boxBG = new BGSprite('box', -600, -200, 1, 1);
				add(boxBG);

			case 'forest'|'forest-dark': //Week 10: Leafeon
				if (SONG.song.toLowerCase() == 'a-scary-night-song' || SONG.song.toLowerCase() == 'unwanted-guest' || curStage == "forest-dark" || SONG.song.toLowerCase() == "spoopy"){
					boxBG = new BGSprite('forestdark', -600, -200, 1, 1);
				}else
					boxBG = new BGSprite('forest', -600, -200, 1, 1);
				
				add(boxBG);

			case 'coliseum':
				var bg:BGSprite = new BGSprite('coliseum', -600, -200, 1, 1);
				add(bg);

			/*case 'daSchool': //Secret Week 1: Denis
				var bg:BGSprite = new BGSprite('school', -600, -200, 1, 1);
				add(bg);*/
			
			case 'ferocious'|'daschool': //Secret Week 1: Denis
				var bg:BGSprite = new BGSprite('school', -600, -200, 1, 1);
				add(bg);

			case 'white-center': //Bonus song
				
				var bg:BGSprite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				bg.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				
				add(bg);

			case 'pringles': //Bonus song
				
				var bg:BGSprite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				bg.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF363A40);
				
				add(bg);

			case 'memz':
				var bg:BGSprite = new BGSprite('memz', -600, -200, 1, 1);
				add(bg);

				stageBackgrounds = new FlxTypedGroup<BGSprite>();
				add(stageBackgrounds);

				var dabg:BGSprite = new BGSprite('box-alt', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('stage2', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('rasda', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('vee-forest', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('lightning', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('red2', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('rematch', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);
				var dabg:BGSprite = new BGSprite('house', -600, -200, 1, 1);
				dabg.visible = false;
				stageBackgrounds.add(dabg);


			case 'road':
				//This makes things look like Vee Funkin.
				//This is exclusive to the Bling Blunkin song only.
				//You can't utilize this variable and this might not get
				//added to Austin Engine.
				if (SONG.song.toLowerCase() == 'bling-blunkin'){
					//soundPrefix = 'Vee-';
					//Makes the whole ui look like Vee Funkin
					uiType = 1;
					//Change the ratings.
					ratingStuff = [
						['..How are you not dead??', 0.2], //From 0% to 19%
						['I\'m speechless', 0.4], //From 20% to 39%
						['Yikes..', 0.5], //From 40% to 49%
						['wh', 0.6], //From 50% to 59%
						['Ehh...', 0.69], //From 60% to 68%
						['heh nice', 0.7], //69%
						['Ehh...', 0.8], //From 70% to 79%
						['Woohoo!', 0.9], //From 80% to 89%
						['Aw yeahh!!', 1], //From 90% to 99%
						['Whoaaa AWESOME!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
					];
				}

				var bg:BGSprite = new BGSprite('roadSkyAlt', 0, 0, 0, 0);
				bg.setGraphicSize(Std.int(bg.width * 2));
				add(bg);

				var bg:BGSprite = new BGSprite('roadSky', 0, 0, 0, 0);
				bg.setGraphicSize(Std.int(bg.width * 2));
				add(bg);
				blingSky = bg;

				if (!ClientPrefs.lowQuality){
					mountains = new FlxBackdrop(Paths.image('roadMountainsAlt'), 0, 0, true, false);
					mountains.velocity.set(100, 0);
					mountains.updateHitbox();
					mountains.scrollFactor.set(0.2, 0.2);
					mountains.antialiasing = ClientPrefs.globalAntialiasing;
					add(mountains);

					mountains = new FlxBackdrop(Paths.image('roadMountains'), 0, 0, true, false);
					mountains.velocity.set(100, 0);
					mountains.updateHitbox();
					mountains.scrollFactor.set(0.2, 0.2);
					mountains.antialiasing = ClientPrefs.globalAntialiasing;
					add(mountains);

					trees = new FlxBackdrop(Paths.image('roadTreesAlt'), 0, 250, true, false);
					trees.velocity.set(200, 0);
					trees.updateHitbox();
					trees.setGraphicSize(Std.int(trees.width * 1.25));
					trees.scrollFactor.set(0.7, 0.7);
					trees.antialiasing = ClientPrefs.globalAntialiasing;
					add(trees);

					trees = new FlxBackdrop(Paths.image('roadTrees'), 0, 250, true, false);
					trees.velocity.set(200, 0);
					trees.updateHitbox();
					trees.setGraphicSize(Std.int(trees.width * 1.25));
					trees.scrollFactor.set(0.7, 0.7);
					trees.antialiasing = ClientPrefs.globalAntialiasing;
					add(trees);

					
				}

				var bg:BGSprite = new BGSprite(null, -FlxG.width, 100 + 720, 1, 1);
				bg.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF55CC3D);
				add(bg);
				blingGreen = bg;

				road = new FlxBackdrop(Paths.image('roadGrassAlt'), 50, 0, true, false);
				road.velocity.set(500, 0);
				road.updateHitbox();
				road.scrollFactor.set(1, 1);
				road.setGraphicSize(Std.int(road.width * 1.25));
				road.antialiasing = ClientPrefs.globalAntialiasing;
				add(road);

				road = new FlxBackdrop(Paths.image('roadGrass'), 50, 0, true, false);
				road.velocity.set(500, 0);
				road.updateHitbox();
				road.scrollFactor.set(1, 1);
				road.setGraphicSize(Std.int(road.width * 1.25));
				road.antialiasing = ClientPrefs.globalAntialiasing;
				add(road);

			case 'playstation':
				var bg:BGSprite = new BGSprite('psGradient', -600, -200, 1, 1);
				add(bg);
				
				if (!ClientPrefs.lowQuality){
					var road = new FlxBackdrop(Paths.image('playstationbuttons'), 0, 0, true, true);
					road.velocity.set(150, 50);
					road.updateHitbox();
					road.scrollFactor.set(0.2, 0.2);
					road.antialiasing = ClientPrefs.globalAntialiasing;
					add(road);
				}

				var bg:BGSprite = new BGSprite('ps2', -600, -200, 1, 1);
				add(bg);

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				CoolUtil.precacheSound('thunder_1');
				CoolUtil.precacheSound('thunder_2');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}

				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyLightsColors = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
				phillyWindow = new BGSprite('philly/window', city.x, city.y, 0.3, 0.3);
				phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 0.85));
				phillyWindow.updateHitbox();
				add(phillyWindow);
				phillyWindow.alpha = 0;

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyCityLights = new FlxTypedGroup<BGSprite>();
				phillyCityLights.add(phillyWindow);
				add(phillyCityLights);

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				phillyStreet = new BGSprite('philly/street', -40, 50);
				add(phillyStreet);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					CoolUtil.precacheSound('dancerdeath');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				CoolUtil.precacheSound('Lights_Shut_off');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

			case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				/*if(!ClientPrefs.lowQuality) { //Does this even do something?
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
				}*/

				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}

				case 'tank':
					defaultCamZoom = 0.9;
				
					tankSky = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankSky', 'week7'));
					tankSky.antialiasing = true;
					tankSky.scrollFactor.set(0, 0);
					tankSky.setGraphicSize(Std.int(tankSky.width * 2.7));
					tankSky.active = false;
					add(tankSky);
				
					if (!ClientPrefs.lowQuality) {
						tankClouds = new FlxSprite(-700, -100).loadGraphic(Paths.image('tankClouds', 'week7'));
						tankClouds.antialiasing = true;
						tankClouds.scrollFactor.set(0.1, 0.1);
						tankClouds.active = true;
						tankClouds.velocity.x = FlxG.random.float(5, 15);
						add(tankClouds);
					}
				
					tankmout = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankMountains', 'week7'));
					tankmout.antialiasing = true;
					tankmout.scrollFactor.set(0.2, 0.2);
					tankmout.setGraphicSize(Std.int(tankmout.width * 1.1));
					tankmout.active = false;
					tankmout.updateHitbox();
					add(tankmout);
				
					tankmouwt = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankBuildings', 'week7'));
					tankmouwt.antialiasing = true;
					tankmouwt.scrollFactor.set(0.3, 0.3);
					tankmouwt.setGraphicSize(Std.int(tankmouwt.width * 1.1));
					tankmouwt.active = false;
					add(tankmouwt);
				
					if (!ClientPrefs.lowQuality) {
						tancuk = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankRuins', 'week7'));
						tancuk.antialiasing = true;
						tancuk.scrollFactor.set(0.35, 0.36);
						tancuk.setGraphicSize(Std.int(tancuk.width * 1.1));
						tancuk.active = false;
						add(tancuk);
					}
				
					if (!ClientPrefs.lowQuality) {
						smokeLeft = new FlxSprite(-200, -100).loadGraphic(Paths.image('smokeLeft', 'week7'));
						smokeLeft.frames = Paths.getSparrowAtlas('smokeLeft', 'week7');
						smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
						smokeLeft.animation.play('idle');
						smokeLeft.scrollFactor.set (0.4, 0.4);
						smokeLeft.antialiasing = true;
						add(smokeLeft);
					
						smokeRight = new FlxSprite(1100, -100).loadGraphic(Paths.image('smokeRight', 'week7'));
						smokeRight.frames = Paths.getSparrowAtlas('smokeRight', 'week7');
						smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
						smokeRight.animation.play('idle');
						smokeRight.scrollFactor.set (0.4, 0.4);
						smokeRight.antialiasing = true;
						add(smokeRight);
					}

					tanjcuk = new FlxSprite(100, 50);
					tanjcuk.frames = Paths.getSparrowAtlas('tankWatchtower', 'week7');
					tanjcuk.animation.addByPrefix('dancey', 'watchtower gradient color instance ', 24, false);
					tanjcuk.animation.play('dancey');
					tanjcuk.antialiasing = true;
					tanjcuk.scrollFactor.set(0.5, 0.5);
					tanjcuk.setGraphicSize(Std.int(tanjcuk.width * 1.2));
					tanjcuk.antialiasing = true;
					add(tanjcuk);
				
					tankRolling = new FlxSprite(300,300);
					tankRolling.frames = Paths.getSparrowAtlas('tankRolling', 'week7');
					tankRolling.animation.addByPrefix('idle', 'BG tank w lighting instance ', 24, true);
					tankRolling.scrollFactor.set(0.5, 0.5);
					tankRolling.antialiasing = true;
					tankRolling.animation.play('idle');
					add(tankRolling);
				
					tankmouthh = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankGround', 'week7'));
					tankmouthh.antialiasing = true;
					tankmouthh.setGraphicSize(Std.int(tankmouthh.width * 1.15));
					tankmouthh.active = false;
					tankmouthh.updateHitbox();
					add(tankmouthh);

					tankmanRun = new FlxTypedGroup<ShotTankmen>();
					if (!ClientPrefs.lowQuality)
						add(tankmanRun);
					
					tankbop0 = new FlxSprite(-500, 650);
					tankbop0.frames = Paths.getSparrowAtlas('tank0', 'week7');
					tankbop0.animation.addByPrefix('danceya', 'fg tankhead far right instance', 24, false);
					tankbop0.animation.play('danceya');
					tankbop0.antialiasing = true;
					add(tankbop0); 
					
					
					tank1 = new FlxSprite(-300, 750);
					tank1.frames = Paths.getSparrowAtlas('tank1', 'week7');
					tank1.animation.addByPrefix('dietz', 'fg tankhead 5 instance ', 24, false);
					tank1.animation.play('detz');
					tank1.scrollFactor.set(2, 0.2);
					tank1.antialiasing = true;
					add(tank1);
					
					tank2 = new FlxSprite(450, 940);
					tank2.frames = Paths.getSparrowAtlas('tank2', 'week7');
					tank2.animation.addByPrefix('idle', 'foreground man 3 instance ', 24, false);
					tank2.animation.play('idle');
					tank2.scrollFactor.set(1.5, 1.5);
					tank2.antialiasing = true;
					add(tank2);
					
					tank4 = new FlxSprite(1300, 900);
					tank4.frames = Paths.getSparrowAtlas('tank4', 'week7');
					tank4.animation.addByPrefix('idle', 'fg tankman bobbin 3 instance ', 24, false);
					tank4.animation.play('idle');
					tank4.scrollFactor.set(1.5, 1.5);
					tank4.antialiasing = true;
					add(tank4);
				
					tank5 = new FlxSprite(1620, 700);
					tank5.frames = Paths.getSparrowAtlas('tank5', 'week7');
					tank5.animation.addByPrefix('idle', 'fg tankhead far right instance ', 24, false);
					tank5.animation.play('idle');
					tank5.scrollFactor.set(1.5, 1.5);
					tank5.antialiasing = true;
					add(tank5);
					
					tank3 = new FlxSprite(1300, 1200);
					tank3.frames = Paths.getSparrowAtlas('tank3', 'week7');
					tank3.animation.addByPrefix('idle', 'fg tankhead 4 instance ', 24, false);
					tank3.animation.play('idle');
					tank3.scrollFactor.set(1.5, 1.5);
					tank3.antialiasing = true;
					add(tank3);
		}

		if (curStage == 'trippy' && !ClientPrefs.lowQuality){
			var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
			testshader.waveAmplitude = 0.1;
			testshader.waveFrequency = 5;
			testshader.waveSpeed = 2;
			trippyBG.shader = testshader.shader;
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dadGroup);
		add(boyfriendGroup);
		
		if(curStage == 'spooky') {
			add(halloweenWhite);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(curStage == 'philly') {
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			phillyCityLightsEvent.add(phillyWindow);
			/*for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}*/
		}
		
		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));

		if(!modchartSprites.exists('oldBlammedLightsBlack')) { //Creates blammed light black fade in case you didn't make your own
			oldBlammedLightsBlack = new ModchartSprite(FlxG.width * -0.5, FlxG.height * -0.5);
			oldBlammedLightsBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			var position:Int = members.indexOf(gfGroup);
			if(members.indexOf(boyfriendGroup) < position) {
				position = members.indexOf(boyfriendGroup);
			} else if(members.indexOf(dadGroup) < position) {
				position = members.indexOf(dadGroup);
			}
			insert(position, oldBlammedLightsBlack);

			oldBlammedLightsBlack.wasAdded = true;
			modchartSprites.set('oldBlammedLightsBlack', oldBlammedLightsBlack);
		}
		if(curStage == 'philly') insert(members.indexOf(oldBlammedLightsBlack) + 1, phillyCityLightsEvent);
		oldBlammedLightsBlack = modchartSprites.get('oldBlammedLightsBlack');
		oldBlammedLightsBlack.alpha = 0.0;
		#end

		
		var gfVersion:String = SONG.player3;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				default:
					gfVersion = 'gf';
			}
			SONG.player3 = gfVersion; //Fix for the Chart Editor
		}

		
		
		if (SONG.song.toLowerCase() == 'crossover'){
			fakegf = new Character(0, 0, gfVersion);
			startCharacterPos(fakegf);
			fakegf.y += 5;
			fakegf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(fakegf);
		}if (SONG.song.toLowerCase() == 'easedrop'||SONG.song.toLowerCase() == 'vomit'){
			fakegf = new Character(0, 0, 'gf');
			startCharacterPos(fakegf);
			fakegf.y -= 10;
			fakegf.x += 100;
			fakegf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(fakegf);
		}
		
		gf = new Character(0, 0, gfVersion);
		startCharacterPos(gf);
		gf.scrollFactor.set(0.95, 0.95);
		gfGroup.add(gf);
		
		if (SONG.hideGF == true || SONG.song.toLowerCase() == 'crossover') gf.visible = false;

		
	
		if (gfVersion == 'pico-speaker') {
			gf.x -= 100;
		}

		

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);

		if (SONG.song.toLowerCase() == 'memz-2'){
			player2 = new Character(0, 0, 'player');
			startCharacterPos(player2, true);
			dadGroup.add(player2);
			player3 = new Character(0, 0, 'silyvon');
			startCharacterPos(player3, true);
			dadGroup.add(player3);
			player4 = new Character(0, 0, 'redBambi');
			startCharacterPos(player4, true);
			dadGroup.add(player4);
			player5 = new Character(0, 0, 'zeraora');
			startCharacterPos(player5, true);
			dadGroup.add(player5);
			player6 = new Character(0, 0, 'vee');
			startCharacterPos(player6, true);
			dadGroup.add(player6);
			player7 = new Character(0, 0, 'sallyFloombo');
			startCharacterPos(player7, true);
			dadGroup.add(player7);
			player8 = new Character(0, 0, 'quem');
			startCharacterPos(player8, true);
			dadGroup.add(player8);

			player2.x = dad.x + FlxG.random.int(-250,250);
			player2.y = dad.y + FlxG.random.int(-50,50);
			player3.x = dad.x + FlxG.random.int(-250,250);
			player3.y = dad.y + FlxG.random.int(-50,50);
			player4.x = dad.x + FlxG.random.int(-250,250);
			player4.y = dad.y + FlxG.random.int(-50,50);
			player5.x = dad.x + FlxG.random.int(-250,250);
			player5.y = dad.y + FlxG.random.int(-50,50);
			player6.x = dad.x + FlxG.random.int(-250,250);
			player6.y = dad.y + FlxG.random.int(-50,50);
			player7.x = dad.x + FlxG.random.int(-250,250);
			player7.y = dad.y + FlxG.random.int(-50,50);
			player8.x = dad.x + FlxG.random.int(-250,250);
			player8.y = dad.y + FlxG.random.int(-50,50);

			player2.visible = false;
			player3.visible = false;
			player4.visible = false;
			player5.visible = false;
			player6.visible = false;
			player7.visible = false;
			player8.visible = false;
		}

		//Makes Flareon and polyeon go up and down.
		//Only if you have low quality off.
		//Yeah I know I'm using tweens, cry about it.
		if (!ClientPrefs.lowQuality){
			switch (SONG.player2){
				case 'polyeon'|'pulpeon':
					if (curStage == 'playstation'){
						dad.x += 100;
						dad.y += 25;
					}
					FlxTween.tween(dad, {y: dad.y - 400}, 2, {ease: FlxEase.quadInOut,type:PINGPONG});
				case 'flareon':
					FlxTween.tween(dad, {y: dad.y - 150}, 1, {ease: FlxEase.quadInOut,type:PINGPONG});
				case 'eivee-glitch':
					FlxTween.tween(dad, {y: dad.y - 200}, 5, {ease: FlxEase.quadInOut,type:PINGPONG});

			}
			switch (SONG.player1){
				case 'polyeon'|'pulpeon':
					if (curStage == 'playstation'){
						boyfriend.x += 100;
						boyfriend.y += 25;
					}
					FlxTween.tween(boyfriend, {y: boyfriend.y - 400}, 2, {ease: FlxEase.quadInOut,type:PINGPONG});
				case 'flareon':
					FlxTween.tween(boyfriend, {y: boyfriend.y - 150}, 1, {ease: FlxEase.quadInOut,type:PINGPONG});
				case 'eivee-glitch':
					FlxTween.tween(boyfriend, {y: boyfriend.y - 200}, 5, {ease: FlxEase.quadInOut,type:PINGPONG});

			}
		}

		boyfriend = new Boyfriend(0, 0, (!isStoryMode && freeplayChar ? selectedBF : SONG.player1));
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);

		if (SONG.song.toLowerCase() == 'sytrus'){
			dad.alpha = 0;
			boyfriend.visible = false;
			gf.visible = false;
			camHUD.visible = false;
		}
		if (SONG.song.toLowerCase() == 'distasteful'){
			boyfriend.visible = false;
		}
		if (SONG.song.toLowerCase() == 'bling-blunkin'){
			boyfriend.y -= 50;
			boyfriend.x += 200;
			bfCar = new FlxSprite(boyfriend.x - (boyfriend.width * 0.3), boyfriend.y + (boyfriend.height * 0.75));
			bfCar.frames = Paths.getSparrowAtlas('car');
			bfCar.animation.addByPrefix('idle', 'idle', 24, true);
			bfCar.animation.play('idle');
			bfCar.scrollFactor.set(1, 1);
			bfCar.antialiasing = true;
			add(bfCar);
		}
		
		var camPos:FlxPoint = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
		camPos.x += gf.cameraPosition[0];
		camPos.y += gf.cameraPosition[1];

		if(dad.curCharacter.startsWith('gf') || dad.curCharacter == gf.curCharacter) {
			dad.setPosition(GF_X, GF_Y);
			gf.visible = false;
		}

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);
			
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;
		
		if (curStage == 'white-center'){
			strumLine = new FlxSprite(STRUM_X_MIDDLESCROLL, 50).makeGraphic(FlxG.width, 10);
		}else{
			strumLine = new FlxSprite((ClientPrefs.middleScroll || SONG.forceMiddlescroll) ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		}
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		scoretable = new FlxText(-100, FlxG.height / 2, 0,
			'Song Score: '+ songScore +
			'\nCurrent Combo: '+ combo +
			'\nHighest combo: '+ highestcombo +
			'\nPerfects: '+ perfects +
			'\nAwesomes: '+ awesomes +
			'\nNices: '+ sicks +
			'\nCools: ' + goods +
			'\nBruhs: ' + bads +
			'\nTrashes: ' + shits +
			'\nMisses: ' + songMisses
		, 20);
		scoretable.setFormat(Paths.font("righteous.ttf"), 20, uiColor, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoretable.scrollFactor.set();
		scoretable.cameras = [camHUD];
		scoretable.alpha = 0;
		scoretable.visible = ClientPrefs.doScoretable;
		add(scoretable);

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 449, 20, 601, "", 32);
		timeTxt.screenCenter(X);
		timeTxt.setFormat(Paths.font("righteous.ttf"), 32, uiColor, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = !ClientPrefs.hideTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 45;

		writertxt = new FlxText(-1000, FlxG.width * 0.25, 400, "", 32);
		writertxt.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.BLACK, LEFT);
		writertxt.scrollFactor.set();
		
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('data/' + SONG.song.toLowerCase().replace(' ', '-') + '/artist.txt'); #else ''; #end
		#if sys
		trace(fileName);
		if(FileSystem.exists(fileName)) {
			foundFile = true;
			trace('artist found');
		}else{
			trace('Artist not found in mods folder.');
		}
		#end

		var curWriter:String;
		var artist:Array<String>;
		
		if(!foundFile) {
			fileName = Paths.txt(Paths.formatToSongPath(SONG.song) + '/' + 'artist');
			trace(fileName);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
				trace('artist found');
			}
		}
		if (foundFile == true) {
			artist = CoolUtil.coolTextFile(fileName);
			writertxt.text = artist.join('\n');
		}else{
			trace('No artists found');
			writertxt.text = "Artist unknown";
		}

		writerbg = new FlxSprite(-100, scoretable.y - writertxt.height - 4).makeGraphic(Std.int(writertxt.width + 2), Std.int(writertxt.height + 2), FlxColor.WHITE);
		writertxt.y = writerbg.y+1;

		writertxt.cameras = [camOther];
		writerbg.cameras = [camOther];
		writertxt.alpha = 0;
		writerbg.alpha = 0;

		writerbg.visible = ClientPrefs.doArtistinfo;
		writertxt.visible = ClientPrefs.doArtistinfo;

		add(writerbg);
		add(writertxt);

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = !ClientPrefs.hideTime;
		timeBarBG.color = uiColor;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;

		//This is probably really stupid.
		//Hopefully this doesn't crash this bitch.
		var timebarColor:Array<String> = ['0xFF915D0F', '0xFFFFA621'];
		if (SONG.timebarColor.length == 2){
			if (SONG.timebarColor[0] != "") timebarColor[0] = SONG.timebarColor[0];
			if (SONG.timebarColor[1] != "") timebarColor[1] = SONG.timebarColor[1];
			//timebarColor = SONG.timebarColor;
		}

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(FlxColor.fromString(timebarColor[0]), FlxColor.fromString(timebarColor[1]));
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = !ClientPrefs.hideTime;
		timeBarBG.sprTracker = timeBar;

		timeBarColor = new FlxSprite(timeBarBG.x + 4, timeBarBG.y + 4).loadGraphic(Paths.image('timebarColor'));
		timeBarColor.visible = !ClientPrefs.hideTime;
		timeBarColor.scale.y = timeBar.scale.y;
		timeBarColor.scale.x = timeBar.percent;
		timeBarColor.x = (timeBar.x / 2);
		timeBarColor.alpha = 0;
		timeBarColor.cameras = [camHUD];
		//add(timeBarColor);

		timeBarOverlay = new FlxSprite().loadGraphic(Paths.image('timeBarOverlay'));
		timeBarOverlay.frames = Paths.getSparrowAtlas('timeBarOverlay');
		timeBarOverlay.animation.addByPrefix('normal', 'normal', 12, true);
		timeBarOverlay.animation.play('normal');
		//timeBarOverlay.screenCenter(X);
		timeBarOverlay.scrollFactor.set();
		timeBarOverlay.scale.y += .25;
		timeBarOverlay.alpha = 0;
		timeBarOverlay.visible = !ClientPrefs.hideTime;
        timeBarOverlay.color = FlxColor.BLACK;
		timeBarOverlay.blend = MULTIPLY;
		timeBarOverlay.y = FlxG.height * 0.042;
		//timeBarOverlay.y = (FlxG.width / 2) - 248;
		timeBarOverlay.x = timeBar.x - 3.95;
		timeBarOverlay.antialiasing = ClientPrefs.globalAntialiasing;
		timeBarOverlay.cameras = [camHUD];
		//add(timeBarOverlay); 
		if(ClientPrefs.downScroll) timeBarOverlay.y = 0.953 * FlxG.height;
		add(timeBar);
		add(timeBarBG);
		add(timeTxt);

		msTimeTxt = new FlxText(0, 0, 400, "", 32);
		msTimeTxt.setFormat(Paths.font('righteous.ttf'), 32, uiColor, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		msTimeTxt.scrollFactor.set(1, 1);
		msTimeTxt.alpha = 1;
		msTimeTxt.visible = true;
		msTimeTxt.borderSize = 2;
		add(msTimeTxt);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		
		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys()) {
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(luaToLoad));
			}
		}
		for (event in eventPushedMap.keys()) {
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(luaToLoad));
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		
		FlxG.camera.follow(camFollowPos, LOCKON, 5);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		camHUD.zoom = defaultHudZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		healthBarBG.color = uiColor;
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		healthBarOverlay = new FlxSprite().loadGraphic(Paths.image('healthBarOverlay'));
		healthBarOverlay.frames = Paths.getSparrowAtlas('healthBarOverlay');
		healthBarOverlay.animation.addByPrefix('normal', 'normal', 12, true);
		healthBarOverlay.animation.play('normal');
		healthBarOverlay.screenCenter(X);
		healthBarOverlay.scale.set(healthBarOverlay.scale.x + 0.01, healthBarOverlay.scale.x + 0.25);
		healthBarOverlay.scrollFactor.set();
		healthBarOverlay.visible = !ClientPrefs.hideHud;
        healthBarOverlay.color = FlxColor.BLACK;
		healthBarOverlay.blend = MULTIPLY;
		healthBarOverlay.y = FlxG.height * 0.89;
		healthBarOverlay.x = healthBarBG.x-1.9;
		healthBarOverlay.antialiasing = ClientPrefs.globalAntialiasing;
		healthBarOverlay.cameras = [camHUD];
		if (!ClientPrefs.classicHUD) add(healthBarOverlay); 
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarOverlay.y = 0.11 * FlxG.height;

		//Ripped straight from Kade Engine, fight me over it
		
		kadeEngineWatermark = new FlxText(4, healthBarBG.y
			+ 50, 0,
			SONG.song
			+ " - Pokehell " + MainMenuState.pokehellVersion, 16);
		kadeEngineWatermark.setFormat(Paths.font("righteous.ttf"), 16, uiColor, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.updateHitbox();
		kadeEngineWatermark.cameras = [camHUD];
		add(kadeEngineWatermark);

		

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.visible = !ClientPrefs.hideHud;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.visible = !ClientPrefs.hideHud;
		if (curSong == 'drugged'){
				iconP2.alpha = 0;
		}
		add(iconP2);
		reloadHealthBarColors();

		healthBarBG.y += 150;
		healthBar.y += 150;
		healthBarOverlay.y += 150;
		iconP1.y += 150;
		iconP2.y += 150;
		FlxTween.tween(healthBarBG, {y: healthBarBG.y - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.5});
		FlxTween.tween(healthBarBG, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(healthBar, {y: healthBar.y - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.5});
		FlxTween.tween(healthBar, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(healthBarOverlay, {y: healthBarOverlay.y - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.5});
		FlxTween.tween(healthBarOverlay, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(iconP1, {y: iconP1.y - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.6});
		FlxTween.tween(iconP1, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.6});
		FlxTween.tween(iconP2, {y: iconP2.y - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.6});
		FlxTween.tween(iconP2, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.6});
		

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("righteous.ttf"), 20, uiColor, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		scoreTxt.alpha = 0;
		add(scoreTxt);

		FlxTween.tween(scoreTxt, {y: (healthBarBG.y + 36) - 150}, 1, {ease: FlxEase.backOut, startDelay: 0.6});
		FlxTween.tween(scoreTxt, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.6});
		

		botplayTxt = new FlxText(400,FlxG.height * 0.7 /*(ClientPrefs.classicBotplayText ? (ClientPrefs.downScroll ? timeBarBG.y - 55 : timeBarBG.y + 55) : (ClientPrefs.downScroll ? healthBarBG.y + 155 : healthBarBG.y - 155))*/, FlxG.width - 800, botplayList[FlxG.random.int(0,botplayList.length)], 32);
		botplayTxt.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.RED);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.5;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		/*if(ClientPrefs.downScroll && !ClientPrefs.classicBotplayText) {
			botplayTxt.y = timeBarBG.y + 78;
		}*/

		unsupportedText.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camOther];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;

		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'data/' + Paths.formatToSongPath(SONG.song) + '/script.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		
		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));
		#end
		
		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.elasticOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				
				case 'smoked-out':
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.elasticOut,
								onComplete: function(twn:FlxTween)
								{
									startDialogue(dialogueJson);
								}
							});
						});
				case 'smoking' | 'squad' | 'speeding' | 'crossover':
					var leSong:String = SONG.song.toLowerCase();
					startVideo(leSong + 'Cutscene');
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'tutorial' | 'headache'|'electric'|'rock'|'metal'|'sinful'|'flaming'|'burned'|'cold'|'solid'|'frozen'|'hopeful'|'easedrop'|'finale'|'friend'|'vomit'|'angery'|'drugged'|'hypergalcemia'|'banana'|'my-friends'|'hammerburst'|'retro-stab'|'lancer':
					startDialogue(dialogueJson);
				case 'ugh' | 'guns' | 'stress':
					var leSong:String = SONG.song.toLowerCase();
					if (leSong == 'stress')
						GameOverSubstate.characterName = 'bf-holding-gf-dead';
					startVideo(leSong + 'Cutscene');
				default:
					startCountdown();
			}
			seenCutscene = true;
		} else {
			var daSong:String = Paths.formatToSongPath(curSong);
			switch(daSong){
				case 'sytrus':
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
						{
							trippyBG.animation.play('animated',true);

							camHUD.visible = false;
							dad.alpha = 0;
							boyfriend.alpha = 0;
							gf.alpha = 0;
							new FlxTimer().start(2.5, function(tmr:FlxTimer)
								{
									camHUD.visible = true;
									FlxTween.tween(dad, {alpha: 1}, 1.5, {
										ease: FlxEase.linear
									});
									startCountdown();
								});
						});
				default:
					startCountdown();
			}
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end
		
		
		callOnLuas('onCreatePost', []);
		
		
		
		super.create();

		if (SONG.song.toLowerCase() == 'stress')
			GameOverSubstate.characterName = 'bf-holding-gf-dead';

		if (curStage == 'trippy' && !ClientPrefs.lowQuality){
				var evilTrail = new FlxTrail(boyfriend, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(boyfriendGroup) - 1, evilTrail);
				var evilTrail = new FlxTrail(gf, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(gfGroup) - 1, evilTrail);
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}
		if (SONG.song.toLowerCase() == 'crossover'){
			
		}
		if (curStage == 'greenally'){
			var dark:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('darkgradient'));
			dark.cameras = [camHUD];
			add(dark);
		}
	}

	public function addTextToDebug(text:String) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});
		luaDebugGroup.add(new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					newBoyfriend.alreadyLoaded = false;
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					newDad.alreadyLoaded = false;
				}

			case 2:
				if(!gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					newGf.alreadyLoaded = false;
				}
		}
	}
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				if(endingSong) {
					endSong();
				} else {
					if (SONG.song.toLowerCase() == 'smoking' || SONG.song.toLowerCase() == 'squad' || SONG.song.toLowerCase() == 'speeding' || SONG.song.toLowerCase() == 'crossover'){					
						startDialogue(dialogueJson);
					}else startCountdown();
				}
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
		if(endingSong) {
			endSong();
		} else {
			startCountdown();
		}
	}

	public function startMidSongVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			(new FlxVideo(fileName)).finishCallback = function() {
				trace('video finished');
			}
			return;
		} else
			trace('video not found');
		#end
	}

	var dialogueCount:Int = 0;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			var doof:DialogueBoxPsych = new DialogueBoxPsych(dialogueFile, song);
			doof.scrollFactor.set();
			if(endingSong) {
				doof.finishThing = endSong;
			} else {
				doof.finishThing = startCountdown;
			}
			doof.nextDialogueThing = startNextDialogue;
			doof.skipDialogueThing = skipDialogue;
			doof.cameras = [camHUD];
			add(doof);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countDownSprites:Array<FlxSprite> = [];

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
				defaultNotePos.push([playerStrums.members[i].x, playerStrums.members[i].y]);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				defaultNotePos.push([opponentStrums.members[i].x, opponentStrums.members[i].y]);
				if(ClientPrefs.middleScroll || SONG.forceMiddlescroll == true) opponentStrums.members[i].visible = false;
				if(curStage == 'white-center') opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);

			var swagCounter:Int = 0;


			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (tmr.loopsLeft % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
				{
					gf.dance();

					if (fakegf != null) fakegf.dance();
				}
				if(tmr.loopsLeft % 2 == 0) {
					if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing'))
					{
						boyfriend.dance();
					}
					if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
					{
						dad.dance();

						if (SONG.song.toLowerCase() == 'memz-2'){
							player2.dance();
							player3.dance();
							player4.dance();
							player5.dance();
							player6.dance();
							player7.dance();
							player8.dance();
						}
					}
				}
				else if(dad.danceIdle && dad.animation.curAnim != null && !dad.stunned && !dad.curCharacter.startsWith('gf') && !dad.animation.curAnim.name.startsWith("sing"))
				{
					dad.dance();

					if (SONG.song.toLowerCase() == 'memz-2'){
						player2.dance();
						player3.dance();
						player4.dance();
						player5.dance();
						player6.dance();
						player7.dance();
						player8.dance();
					}
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);
	
					bottomBoppers.dance(true);
					santa.dance(true);
				}
				trace('Starting countdown with sound prefix:'+soundPrefix);
				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound(soundPrefix+'intro3' + introSoundsSuffix), 0.6);
						FlxTween.tween(FlxG.camera, {zoom: 1.1}, Conductor.crochet / 1500, {ease: FlxEase.quadOut, type: BACKWARD});
						for (i in 0...playerStrums.length) {
							playerStrums.members[i].angle = 45;
							FlxTween.tween(playerStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
						for (i in 0...opponentStrums.length) {
							opponentStrums.members[i].angle = 45;
							FlxTween.tween(opponentStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
					case 1:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();

						if (PlayState.isPixelStage)
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

						ready.screenCenter();
						ready.antialiasing = antialias;
						add(ready);
						countDownSprites.push(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(ready);
								remove(ready);
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound(soundPrefix+'intro2' + introSoundsSuffix), 0.6);
						FlxTween.tween(FlxG.camera, {zoom: 1.1}, Conductor.crochet / 1500, {ease: FlxEase.quadOut, type: BACKWARD});
						for (i in 0...playerStrums.length) {
							playerStrums.members[i].angle = -45;
							FlxTween.tween(playerStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
						for (i in 0...opponentStrums.length) {
							opponentStrums.members[i].angle = -45;
							FlxTween.tween(opponentStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
					case 2:
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();

						if (PlayState.isPixelStage)
							set.setGraphicSize(Std.int(set.width * daPixelZoom));

						set.screenCenter();
						set.antialiasing = antialias;
						add(set);
						countDownSprites.push(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(set);
								remove(set);
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound(soundPrefix+'intro1' + introSoundsSuffix), 0.6);
						FlxTween.tween(FlxG.camera, {zoom: 1.1}, Conductor.crochet / 1500, {ease: FlxEase.quadOut, type: BACKWARD});
						for (i in 0...playerStrums.length) {
							playerStrums.members[i].angle = 45;
							FlxTween.tween(playerStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
						for (i in 0...opponentStrums.length) {
							opponentStrums.members[i].angle = 45;
							FlxTween.tween(opponentStrums.members[i],{angle: 0}, Conductor.crochet / 1500, {ease: FlxEase.quadOut});
						}
					case 3:
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();

						if (PlayState.isPixelStage)
							go.setGraphicSize(Std.int(go.width * daPixelZoom));

						go.updateHitbox();

						go.screenCenter();
						go.antialiasing = antialias;
						add(go);
						countDownSprites.push(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(go);
								remove(go);
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound(soundPrefix+'introGo' + introSoundsSuffix), 0.6);
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, Conductor.crochet / 1000, {ease: FlxEase.quadOut, type: BACKWARD});
						
						for (i in 0...playerStrums.length) {
							playerStrums.members[i].angle = -360;
							FlxTween.tween(playerStrums.members[i],{angle: 0}, Conductor.crochet / 1000, {ease: FlxEase.quadOut});
						}
						for (i in 0...opponentStrums.length) {
							opponentStrums.members[i].angle = -360;
							FlxTween.tween(opponentStrums.members[i],{angle: 0}, Conductor.crochet / 1000, {ease: FlxEase.quadOut});
						}
					case 4:
				}

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = 1 * note.multAlpha;
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				if (generatedMusic)
				{
					notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
				}

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = finishSong;
		vocals.play();

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		var timebarbgwidth = timeBarBG.scale.x;
		timeBarBG.scale.x = 0;
		var timebarwidth = timeBar.scale.x;
		timeBar.scale.x = 0;

		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeBarOverlay, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeBarColor, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeBar.scale, {x: timebarwidth}, 0.5, {ease: FlxEase.backOut});
		FlxTween.tween(timeBarOverlay.scale, {x: timebarwidth}, 0.5, {ease: FlxEase.backOut});
		FlxTween.tween(timeBarBG.scale, {x: timebarbgwidth}, 0.5, {ease: FlxEase.backOut});

		var timetxtheight = timeTxt.y;
		timeTxt.y -= 25;
		FlxTween.tween(timeTxt, {alpha: 1, y: timetxtheight}, 0.5, {ease: FlxEase.circOut, startDelay: 0.75});

		FlxTween.tween(scoretable, {alpha: 1, x: 4}, 1, {ease: FlxEase.backOut});
		
		FlxTween.tween(writertxt, {alpha: 1}, 1, {ease: FlxEase.circOut,startDelay:0.5});
		FlxTween.tween(writertxt, {x: 4}, 1, {ease: FlxEase.backOut});
		FlxTween.tween(writerbg, {alpha: 1, x: 0}, 1, {ease: FlxEase.backOut});


		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if sys
		if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/events')) ||#end FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<SwagSection> = Song.loadFromJson('events', songName).notes;
			for (section in eventsData)
			{
				for (songNotes in section.sectionNotes)
				{
					if(songNotes[1] < 0) {
						eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4]]);
						eventPushed(songNotes);
					}
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % Main.ammo[SONG.mania]);

					var gottaHitNote:Bool = section.mustHitSection;

					if (songNotes[1] > Main.ammo[SONG.mania] - 1)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.mustPress = gottaHitNote;
					swagNote.sustainLength = songNotes[2];
					swagNote.noteType = songNotes[3];
					if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
					swagNote.scrollFactor.set();

					//trace(daNoteData);

					var susLength:Float = swagNote.sustainLength;

					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);

					var floorSus:Int = Math.floor(susLength);
					if(floorSus > 0) {
						for (susNote in 0...floorSus+1)
						{
							oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

							var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(SONG.speed, 2)), daNoteData, oldNote, true);
							sustainNote.mustPress = gottaHitNote;
							sustainNote.noteType = swagNote.noteType;
							sustainNote.scrollFactor.set();
							unspawnNotes.push(sustainNote);

							if (sustainNote.mustPress)
							{
								sustainNote.x += FlxG.width / 2; // general offset
							}
						}
					}

					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else {}

					if(!noteTypeMap.exists(swagNote.noteType)) {
						noteTypeMap.set(swagNote.noteType, true);
					}
				} else { //Event Notes
					eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4]]);
					eventPushed(songNotes);
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:Array<Dynamic>) {
		switch(event[2]) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event[3].toLowerCase()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event[3]);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event[4];
				addCharacterToList(newCharacter, charType);
			case 'Philly Glow':
				blammedLightsBlack = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blammedLightsBlack.visible = false;
				insert(members.indexOf(phillyStreet), blammedLightsBlack);

				phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
				phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 0.85));
				phillyWindowEvent.updateHitbox();
				phillyWindowEvent.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);


				phillyGlowGradient = new PhillyGlow.PhillyGlowGradient(-400, 225); //This shit was refusing to properly load FlxGradient so fuck it
				phillyGlowGradient.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);
				if(!ClientPrefs.flashing) phillyGlowGradient.intendedAlpha = 0.7;

				Paths.image('philly/particle'); //precache particle image
				phillyGlowParticles = new FlxTypedGroup<PhillyGlow.PhillyGlowParticle>();
				phillyGlowParticles.visible = false;
				insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);
		}

		if(!eventPushedMap.exists(event[2])) {
			eventPushedMap.set(event[2], true);
		}
	}

	function eventNoteEarlyTrigger(event:Array<Dynamic>):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event[2]]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event[2]) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
			case 'Spawn Tankmen':
				return 1500;	//1500 ms is what the timer is set to i guess
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		var earlyTime1:Float = eventNoteEarlyTrigger(Obj1);
		var earlyTime2:Float = eventNoteEarlyTrigger(Obj2);
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0] - earlyTime1, Obj2[0] - earlyTime2);
	}

	private function generateStaticArrows(player:Int, isChangingMania:Bool = false):Void
		{
			for (i in 0...Main.ammo[mania])
			{
				// FlxG.log.add(i);
				var babyArrow:StrumNote;
				if (curStage == "white-center"){
					babyArrow = new StrumNote(STRUM_X_MIDDLESCROLL, strumLine.y, i);
				}else{
					babyArrow = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i);
				}

				var skin:String = 'NOTE_assets';
				
				//Appearently note skins aren't supported in the extra keys mod.
				//These will hardcode skins to the mod, meaning these can't be changed
				//unless you know how to modify and compile the source code.
				//Fuck you tposejank, always taking the good stuff out of Psych.
				switch (curStage) {
					case 'sally':
						skin = 'SALLY_NOTE_assets';
					case 'school' | 'schoolEvil':
						skin = 'PIXEL_NOTE_assets';
						babyArrow.antialiasing = false;
					default:
						skin = 'NOTE_assets';
						babyArrow.antialiasing = ClientPrefs.globalAntialiasing;
				}
	
				babyArrow.frames = Paths.getSparrowAtlas(skin);
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
				babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.scales[mania]));
	
				babyArrow.x += babyArrow.width * Note.scales[mania] * i;
						
				var dirName = Main.gfxDir[Main.gfxHud[mania][i]];
				var pressName = ClientPrefs.noteOrder[Main.gfxIndex[mania][i]];
				switch (pressName){
					case 'A':
						dirName = 'LEFT';
					case 'B':
						dirName = 'DOWN';
					case 'C':
						dirName = 'UP';
					case 'D':
						dirName = 'RIGHT';
					case 'E':
						dirName = 'SPACE';
					case 'F':
						dirName = 'LEFT';
					case 'G':
						dirName = 'DOWN';
					case 'H':
						dirName = 'UP';
					case 'I':
						dirName = 'RIGHT';
				}
				babyArrow.animation.addByPrefix('static', 'arrow' + dirName);
				babyArrow.animation.addByPrefix('pressed', pressName + ' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', pressName + ' confirm', 24, false);
	
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();
				
				babyArrow.alpha = 0;
				babyArrow.y -= 150;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 150}, 1, {ease: FlxEase.backOut, startDelay: 0.5 + (0.2 * i)});
				FlxTween.tween(babyArrow, {alpha: 1}, 0.2, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				
				babyArrow.ID = i;
	
				if (player == 1)
				{
					playerStrums.add(babyArrow);
				}
				else
				{
					opponentStrums.add(babyArrow);
				}
	
				babyArrow.playAnim('static');
				babyArrow.x += 50;
				babyArrow.x += ((FlxG.width / 2) * player);
				if (isChangingMania) {
					babyArrow.x -= 115;
				}
				babyArrow.x -= Note.posRest[SONG.mania];

				if (SONG.mania == 8 || SONG.mania == 7 || SONG.mania == 6)
					babyArrow.x -= 25;
				//else
					//babyArrow.x += 25;
	
				strumLineNotes.add(babyArrow);

				trace('BABYARROW X = ' + babyArrow.x + ' | PLAYER ' + player);
				
			}
		}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;

			if(oldBlammedLightsBlackTween != null)
				oldBlammedLightsBlackTween.active = false;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;

			if(oldBlammedLightsBlackTween != null)
				oldBlammedLightsBlackTween.active = true;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;
			
			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	public static var rotCam = false;
	var rotCamSpd:Float = 1;
	var rotCamRange:Float = 10;
	var rotCamInd = 0;

	public static var rotCamHud = false;
	var rotCamHudSpd:Float = 1;
	var rotCamHudRange:Float = 10;
	var rotCamHudInd = 0;
				
	public static var swayNotes = false;
	var swayNotesSpd:Float = 1;
	var swayNotesRange:Float = 10;
	var swayNotesInd = 0;
	var swayWinInd = 0;

	var bfspd:Float = FlxG.random.float(1, 5);
	var bfangspd:Float = FlxG.random.float(1,10);
	var bfangr:Float = FlxG.random.float(5, 45);
	var bfrang:Float = FlxG.random.float(-90, 90);
	var bfind = 0;

	var gfspd:Float = FlxG.random.float(1, 5);
	var gfangspd:Float = FlxG.random.float(1,10);
	var gfangr:Float = FlxG.random.float(5, 25);
	var gfrang:Float = FlxG.random.float(-90, 90);
	var gfind = 0;

	var dadspd:Float = FlxG.random.float(1, 5);
	var dadangspd:Float = FlxG.random.float(1,10);
	var dadangr:Float = FlxG.random.float(5, 25);
	var dadrang:Float = FlxG.random.float(-90, 90);
	var dadind = 0;

	var stageSpd:Float = 5;
	var stageRange:Float = 10;
	var stageInd = 0;

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}

		callOnLuas('onUpdate', [elapsed]);

		if (SONG.noPractice) practiceMode = false;
		if (SONG.noBotplay) cpuControlled = false;

		timeBarColor.scale.y = timeBar.scale.y;
		timeBarColor.scale.x = timeBar.percent;
		timeBarColor.x = (timeBar.x / 2);
		timeBarOverlay.visible = timeBar.visible;

		switch (curStage)
		{
			case 'memz':
				if (SONG.song.toLowerCase() == 'memz-2' && ClientPrefs.sourceModcharts){
					if (curBeat < 0){
						dad.visible = false;
						iconP2.visible = false;
						camGame.alpha = 0;
					}
					if (curBeat == 64){
						FlxTween.tween(camGame,{alpha: 1}, 3, {ease: FlxEase.linear});
					}
					if (curBeat == 128){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						dad.visible = true;
						iconP2.visible = true;
						stageBackgrounds.members[0].visible = true;
					}
					if (curBeat == 704){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[0].visible = false;
						stageBackgrounds.members[1].visible = true;
					}
					if (curBeat == 1408){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[1].visible = false;
						stageBackgrounds.members[2].visible = true;
					}
					if (curBeat == 1856){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[2].visible = false;
						stageBackgrounds.members[3].visible = true;
					}
					if (curBeat == 2560){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[3].visible = false;
						stageBackgrounds.members[4].visible = true;
					}
					if (curBeat == 3008){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[4].visible = false;
						stageBackgrounds.members[5].visible = true;
					}
					if (curBeat == 3552){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[5].visible = false;
						stageBackgrounds.members[6].visible = true;
					}
					if (curBeat == 4160){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[6].visible = false;
						stageBackgrounds.members[7].visible = true;
					}
					if (curBeat == 4488){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						stageBackgrounds.members[7].visible = false;
					}
					if (curBeat == 4736){
						triggerEventNote('Change Character', 'dad', 'renderite');

						player2.visible = true;
						player3.visible = true;
						player4.visible = true;
						player5.visible = true;
						player6.visible = true;
						player7.visible = true;
						player8.visible = true;

						iconP2.changeIcon('memzeveryone');
						
					}
				}
			case 'white-center'|'pringles':
				dad.x = boyfriend.x;
				dad.y = boyfriend.y;
				dad.visible = false;
				gf.visible = false;
				iconP2.visible = false;
			case 'blank':
				if (SONG.song.toLowerCase() == 'forgotten'){
				gf.visible = false;}
			case 'cursedhouse':
				gf.visible = false;
				boyfriend.visible = false;
			case 'ally':
				if (SONG.song.toLowerCase() == 'headache' && ClientPrefs.sourceModcharts){
					
				}
			case 'road':
				if (SONG.song.toLowerCase() == 'bling-blunkin' && ClientPrefs.sourceModcharts){
					if (curBeat == 812){
						FlxG.camera.flash(FlxColor.WHITE, 1);
						dad.shader = new YoshiBlammedShader(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
						boyfriend.shader = new YoshiBlammedShader(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
						bfCar.shader = new YoshiBlammedShader(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
						
						blingSky.visible = false;
						blingGreen.visible = false;
						road.visible = false;
						blingGreen.color = 0x0000000;
						
						if (!ClientPrefs.lowQuality){
							mountains.visible = false;
							trees.visible = false;
						}
					}
					else if (curBeat > 812 && curBeat < 908){
						cast(dad.shader, YoshiBlammedShader);
						cast(boyfriend.shader, YoshiBlammedShader);
						cast(bfCar.shader, YoshiBlammedShader);
					}
					else if (curBeat == 908){
						FlxG.camera.flash(FlxColor.WHITE, 1);

						boyfriend.shader = null;
						dad.shader = null;
						bfCar.shader = null;
						
						blingSky.visible = true;
						blingGreen.visible = true;
						road.visible = true;
						blingGreen.color = 0xFF55CC3D;
						
						if (!ClientPrefs.lowQuality){
							mountains.visible = true;
							trees.visible = true;}
					}
				}
			case 'trippy':
				if (!ClientPrefs.lowQuality){
					var shad = cast(trippyBG.shader, Shaders.GlitchShader);
					shad.uTime.value[0] += elapsed;

					stageInd ++;
					trippyBG.angle = Math.sin(stageInd / 100 * bfangspd) * 15;
					trippyBG.x = -600 + Math.sin(stageInd / 100 * stageSpd) * 100;
					trippyBG.y = -200 +Math.sin(stageInd / 100 * stageSpd) * 100;

					bfind ++;
					boyfriend.angle = Math.sin(bfind / 100 * bfangspd) * bfangr;
					boyfriend.x = BF_X + Math.sin(bfind / 100 * bfspd) * bfrang;
					
					gfind ++;
					gf.angle = Math.sin(gfind / 100 * gfangspd) * gfangr;
					gf.x = GF_X + Math.sin(gfind / 100 * gfspd) * gfrang;
					
					dadind ++;
					dad.angle = Math.sin(dadind / 100 * dadangspd) * dadangr;
					dad.x = DAD_X + Math.sin(dadind / 100 * dadspd) * dadrang;
				}
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
			case 'tank':
				moveTank();
		}



		if (rotCam)
		{
			rotCamInd ++;
			camera.angle = Math.sin(rotCamInd / 100 * rotCamSpd) * rotCamRange;
		}
		else
		{
			rotCamInd = 0;
		}

		if (rotCamHud)
		{
			rotCamHudInd ++;
			camHUD.angle = Math.sin(rotCamHudInd / 100 * rotCamHudSpd) * rotCamHudRange;
		}
		else
		{
			rotCamHudInd = 0;
		}
		
		if (swayNotes)
		{
			swayNotesInd ++;
			camHUD.x = Math.sin(swayNotesInd / 100 * swayNotesSpd) * swayNotesRange;
		}
		else
		{
			swayNotesInd = 0;
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		if (songMisses >= 100) {
			GameOverSubstate.deathReason = 'Died by reaching 100 misses.';
			health = -1;
		}

		super.update(elapsed);

		if(ratingString == '?') {
			scoreTxt.text = (!ClientPrefs.classicHUD ? ('Sc.: ' + songScore + ' | Mis.: ' + songMisses + ' | Avg.: ?' + ' | Ra.: ' + ratingString + (cpuControlled ? ' | Botplay':'') + (practiceMode ? ' | NoDeath':'')):('Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingString + (cpuControlled ? ' | Botplay':'') + (practiceMode ? ' | NoDeath':'')));
		} else {
			scoreTxt.text = (!ClientPrefs.classicHUD ? ('Sc.: ' + songScore + ' | Mis.: ' + songMisses + ' | Avg.: ' + Math.round(averageMs) + 'ms' + ' | Ra.: ' + ratingString + ' (' + Math.floor(ratingPercent * 100) + '%)' + ' | (' + ratingFC + ') ' + ranking + (cpuControlled ? ' | Botplay':'') + (practiceMode ? ' | NoDeath':'')):('Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingString + ' (' + Math.floor(ratingPercent * 100) + '%)'+ (cpuControlled ? ' | Botplay':'') + (practiceMode ? ' | NoDeath':'')));
		}

		if(cpuControlled) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = ClientPrefs.classicBotplayText ? 1 - Math.sin((Math.PI * botplaySine) / 180) : 1;
		}
		botplayTxt.visible = cpuControlled;

		scoretable.text = 'Song Score: '+ songScore +
		'\nCurrent Combo: '+ combo +
		'\nHighest combo: '+ highestcombo +
		'\nPerfects: '+ perfects +
		'\nAwesomes: '+ awesomes +
		'\nNices: '+ sicks +
		'\nCools: ' + goods +
		'\nBruhs: ' + bads +
		'\nTrashes: ' + shits +
		'\nMisses: ' + songMisses;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					MusicBeatState.switchState(new GitarooPause());
				}
				else {
					if(FlxG.sound.music != null) {
						FlxG.sound.music.pause();
						vocals.pause();
					}
					PauseSubState.transCamera = camOther;
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
			
				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}

		if (FlxG.keys.justPressed.THREE && !endingSong && !inCutscene)
		{
			FlxG.mouse.visible = true;
		}
		if (FlxG.mouse.justPressed)
		{
			trace('Overlapping: '+FlxG.mouse.overlaps(dad));
			if (FlxG.mouse.overlaps(dad))
			{
				var songData = SONG;
				curSong = songData.song;
				
				/*
				If sunshine is clicked, load twentyseven. 
				You need to press 3 to unlock the mouse cursor first.
				*/
				if (curSong.toLowerCase() == 'squad'){
					var poop:String = Highscore.formatSong('execution', 1);
					PlayState.SONG = Song.loadFromJson(poop, 'execution');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;

					PlayState.storyWeek = 8;
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

					unloadAssets();
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
		}
		if (FlxG.keys.justPressed.SEVEN && !endingSong && !inCutscene)
		{
			var songData = SONG;
			curSong = songData.song;

			/*
			If 7 is pressed in headache, load denis. Otherwise, load
			the chart editor. Denis can't be loaded in the chart editor
			unless you're in the song. Don't worry guys. This isn't a
			bug. It's supposed to be like that.
			*/
			#if !debug
			if (curSong.toLowerCase() == 'headache'){
				var poop:String = Highscore.formatSong('denis', 1);
				PlayState.SONG = Song.loadFromJson(poop, curSong.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 1;

				PlayState.storyWeek = 1;
				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

				unloadAssets();
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			}else if (curSong.toLowerCase() == 'mansion'||curSong.toLowerCase() == 'banger'||curSong.toLowerCase() == 'fair'){
				var pee:String = FlxG.random.bool(5) ? 'treacherous':'raging';
				var poop:String = Highscore.formatSong(pee, 1);
				PlayState.SONG = Song.loadFromJson(poop, pee);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 1;
				
				PlayState.storyWeek = 12;
				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

				unloadAssets();
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			}else{#end
				trace('Chart editor disabled is '+SONG.disableChartEditor);
				if (SONG.disableChartEditor != true){
				persistentUpdate = false;
				paused = true;
				cancelFadeTween();
				CustomFadeTransition.nextCamera = camOther;
				MusicBeatState.switchState(new ChartingState());

				#if desktop
				DiscordClient.changePresence("Chart Editor", null, null, true);
				#end
				}
			#if !debug } #end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		//if (!ClientPrefs.dohealthrot){
			//Old version of classic bumpin
			//iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));
			//iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));
		//}

		

		

		var iconOffset:Int = 26;

		if (ClientPrefs.dohealthrot){
			var multX:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			var multY:Float = FlxMath.lerp(1, iconP1.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			var multAngle:Float = FlxMath.lerp(1, iconP1.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP1.scale.set(multX, multY);
			iconP1.angle = multAngle;
			iconP1.updateHitbox();
	
			var multX:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			var multY:Float = FlxMath.lerp(1, iconP2.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			var multAngle:Float = FlxMath.lerp(1, iconP2.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP2.scale.set(multX, multY);
			iconP2.angle = multAngle;
			iconP2.updateHitbox();
		}else{
			var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP1.scale.set(mult, mult);
			iconP1.updateHitbox();
	
			var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP2.scale.set(mult, mult);
			iconP2.updateHitbox();
	
			//Old version of the icon bumpin'

			//iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			//iconP2.setGraphicSize(Std.int(iconP2.width + 30));
		}

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var multAngle:Float = FlxMath.lerp(1, scoreTxt.angle, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		scoreTxt.angle = multAngle;
		timeBarBG.angle = multAngle;
		timeBarOverlay.angle = multAngle;
		timeTxt.angle = multAngle;
		timeBar.angle = multAngle;

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20){
			iconP1.animation.curAnim.curFrame = 1;
		
			if (iconP2.animation.curAnim.numFrames == 3) 
				iconP2.animation.curAnim.curFrame = 2;
		}else if (healthBar.percent > 80){
			iconP2.animation.curAnim.curFrame = 1;
		
			if (iconP1.animation.curAnim.numFrames == 3) 
				iconP1.animation.curAnim.curFrame = 2;
		}else{
			iconP2.animation.curAnim.curFrame = 0;
			iconP1.animation.curAnim.curFrame = 0;
		}

		if (FlxG.keys.justPressed.EIGHT && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelFadeTween();
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					timeTxt.text = (!ClientPrefs.classicHUD ?  "- " +SONG.song + " - " + FlxStringUtil.formatTime(secondsTotal, false)+" -" : FlxStringUtil.formatTime(secondsTotal, false));
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			if (cameraTwn == null) FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			if (camhudTwn == null) camHUD.zoom = FlxMath.lerp(defaultHudZoom, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (controls.RESET && !inCutscene && !endingSong)
		{
			GameOverSubstate.deathReason = 'You reset yourself.';
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		var roundedSpeed:Float = FlxMath.roundDecimal(SONG.speed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				if(!daNote.mustPress && ClientPrefs.middleScroll)
				{
					daNote.active = true;
					daNote.visible = false;
				}
				else if(!daNote.mustPress && SONG.forceMiddlescroll == true)
				{
					daNote.active = true;
					daNote.visible = false;
				}
				else if(!daNote.mustPress && curStage == 'white-center')
				{
					daNote.active = true;
					daNote.visible = false;
				}
				else if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				// i am so fucking sorry for this if condition
				var strumX:Float = 0;
				var strumY:Float = 0;
				var strumAngle:Float = 0;
				var strumAlpha:Float = 0;
				if(daNote.mustPress) {
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
					strumAngle = playerStrums.members[daNote.noteData].angle;
					strumAlpha = playerStrums.members[daNote.noteData].alpha;
				} else {
					strumX = opponentStrums.members[daNote.noteData].x;
					strumY = opponentStrums.members[daNote.noteData].y;
					strumAngle = opponentStrums.members[daNote.noteData].angle;
					strumAlpha = opponentStrums.members[daNote.noteData].alpha;
				}

				

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;
				var center:Float = strumY + Note.swagWidth / 2;
				var add:Float = 0;

				switch (SONG.mania) {
					case 0:
						add = 60;
					case 1:
						add = 45;
					case 2:
						add = 40;
					case 3:
						add = 30;
					case 4 | 5 | 6:
						add = 32;
					case 7:
						add = 28;
					case 8:
						add = 20;
				}

				if(daNote.copyX) {
					daNote.x = strumX + (daNote.isSustainNote ? add : 0);
				}

				if(daNote.isSustainNote) {
					daNote.alpha = 0.6;
				}
				if(daNote.copyAngle) {
					daNote.angle = strumAngle;
				}
				if(daNote.copyAlpha) {
					if (!daNote.isSustainNote)
						daNote.alpha = strumAlpha;
				}
				if(daNote.copyY) {
					if (ClientPrefs.downScroll) {
						daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
						if (daNote.isSustainNote) {
							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if (daNote.animation.curAnim.name.endsWith('end')) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8;
								} else {
									daNote.y -= 19;
								}
							} 
							daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
							daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (roundedSpeed - 1);

							if(daNote.mustPress || !daNote.ignoreNote)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}
					} else {
						daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

						if(daNote.mustPress || !daNote.ignoreNote)
						{
							if (daNote.isSustainNote
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && (daNote.ignoreNote || daNote.hitCausesMiss) && !daNote.hitByOpponent) {
					//trace('this note BAD\n' + daNote.noteType + '\nanalysis: \nhit cause miss: ' + daNote.hitCausesMiss + '\nignore da note: ' + daNote.ignoreNote + '\nnote will NOT BE PRESSED!');
				} else if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					//trace('this note GOOD!');
					if (Paths.formatToSongPath(SONG.song) != 'tutorial')
						camZooming = true;

					if(daNote.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
						dad.playAnim('hey', true);
						dad.specialAnim = true;
						dad.heyTimer = 0.6;
					}else if (daNote.noteType == 'Memz'){
						var animToPlay:String = '';
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(daNote.noteData))]];
						if(daNote.noteType == 'GF Sing') {
							gf.playAnim(animToPlay, true);
							gf.holdTimer = 0;
						} else {
							dad.playAnim(animToPlay, true);
							dad.holdTimer = 0;
							player2.playAnim(animToPlay, true);
							player2.holdTimer = 0;
							player3.playAnim(animToPlay, true);
							player3.holdTimer = 0;
							player4.playAnim(animToPlay, true);
							player4.holdTimer = 0;
						}
					}else if (daNote.noteType == 'Memz Alt'){
						var animToPlay:String = '';
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(daNote.noteData))]];
						if(daNote.noteType == 'GF Sing') {
							gf.playAnim(animToPlay, true);
							gf.holdTimer = 0;
						} else {
							player5.playAnim(animToPlay, true);
							player5.holdTimer = 0;
							player6.playAnim(animToPlay, true);
							player6.holdTimer = 0;
							player7.playAnim(animToPlay, true);
							player7.holdTimer = 0;
							player8.playAnim(animToPlay, true);
							player8.holdTimer = 0;
						}
					
					} else if(!daNote.noAnimation) {
						var altAnim:String = "";

						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim || daNote.noteType == 'Alt Animation') {
								altAnim = '-alt';
							}
						}

						var animToPlay:String = '';
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(daNote.noteData))]];
						if(daNote.noteType == 'GF Sing') {
							gf.playAnim(animToPlay + altAnim, true);
							gf.holdTimer = 0;
						} else {
							dad.playAnim(animToPlay + altAnim, true);
							dad.holdTimer = 0;
						}
					}

					if (SONG.needsVoices)
						vocals.volume = 1;

					var time:Float = 0.15;
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}

					opponentStrums.forEach(function(spr:StrumNote)
						{
							if (Math.abs(daNote.noteData) == spr.ID && !daNote.isSustainNote)
							{
								if (spr.bumpTween != null){
									spr.bumpTween.cancel();
									spr.bumpTween = null;
								}
								spr.scale.x = Note.scales[PlayState.SONG.mania] + 0.4;
								spr.scale.y = Note.scales[PlayState.SONG.mania] - 0.4;
								spr.bumpTween = FlxTween.tween(spr.scale, {x: Note.scales[PlayState.SONG.mania], y: Note.scales[PlayState.SONG.mania]}, 0.3, {ease: FlxEase.quadOut, onComplete: function(_){
									spr.bumpTween = null;
								}});
							}
						});
					StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % Main.ammo[mania], time);
					daNote.hitByOpponent = true;
					
					if (ClientPrefs.cameraMoveOnNotes) {
						if(SONG.notes[Math.floor(curStep / 16)].mustHitSection == false && !daNote.isSustainNote)
							{
								if (!dad.stunned)
									{
										switch(Std.int(Math.abs(daNote.noteData)))
										{
											case 0:
												camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
												camFollow.x += dad.cameraPosition[0] - cameramovingoffset; camFollow.y += dad.cameraPosition[1];
											case 1:
												camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
												camFollow.x += dad.cameraPosition[0]; camFollow.y += dad.cameraPosition[1] + cameramovingoffset;
											case 2:
												camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
												camFollow.x += dad.cameraPosition[0]; camFollow.y += dad.cameraPosition[1] - cameramovingoffset;
											case 3:							
												camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
												camFollow.x += dad.cameraPosition[0] + cameramovingoffset; camFollow.y += dad.cameraPosition[1];
										}                   
									}
							} 
					}
					callOnLuas('opponentNoteHit', [notes.members.indexOf(daNote), Math.abs(daNote.noteData), daNote.noteType, daNote.isSustainNote]);

					if (!daNote.isSustainNote)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}

				if(daNote.mustPress && cpuControlled) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var doKill:Bool = daNote.y < -daNote.height;
				if(ClientPrefs.downScroll) doKill = daNote.y > FlxG.height;

				if (doKill)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote &&!daNote.isSustainNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					if (daNote.noteType == 'Sylveon Note'){
						dad.playAnim('swing');
						dad.specialAnim = true;
						boyfriend.playAnim('scared');
						boyfriend.specialAnim = true;
					} 

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();

		if (!inCutscene) {
			setOnLuas('mania', mania);	//bullshit
			if(!cpuControlled) {
				keyShit();
			} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
				boyfriend.dance();
			}
		}
		
		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				FlxG.sound.music.pause();
				vocals.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime + 800 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime + 800 >= Conductor.songPosition) {
						break;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}

				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();

				vocals.time = Conductor.songPosition;
				vocals.play();
			}
		}

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', PlayState.cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
		#end
	}

	var isDead:Bool = false;
	function doDeathCheck() {
		if (health <= 0 && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				unloadAssets();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollowPos.x, camFollowPos.y, this));
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		
		while(eventNotes.length > 0) {
			var early:Float = eventNoteEarlyTrigger(eventNotes[0]);
			var leStrumTime:Float = eventNotes[0][0];
			if(Conductor.songPosition < leStrumTime - early) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0][3] != null)
				value1 = eventNotes[0][3];

			var value2:String = '';
			if(eventNotes[0][4] != null)
				value2 = eventNotes[0][4];

			triggerEventNote(eventNotes[0][2], value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value)) value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				if(lightId > 0 && curLightEvent != lightId) {
					if(lightId > 5) lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch(lightId) {
						case 1: //Blue
							color = 0xff31a2fd;
						case 2: //Green
							color = 0xff31fd8c;
						case 3: //Pink
							color = 0xfff794f7;
						case 4: //Red
							color = 0xfff96d63;
						case 5: //Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if(oldBlammedLightsBlack.alpha == 0) {
						if(oldBlammedLightsBlackTween != null) {
							oldBlammedLightsBlackTween.cancel();
						}
						oldBlammedLightsBlackTween = FlxTween.tween(oldBlammedLightsBlack, {alpha: 1}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								oldBlammedLightsBlackTween = null;
							}
						});

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = FlxTween.color(chars[i], 1, FlxColor.WHITE, color, {onComplete: function(twn:FlxTween) {
								chars[i].colorTween = null;
							}, ease: FlxEase.quadInOut});
						}
					} else {
						if(oldBlammedLightsBlackTween != null) {
							oldBlammedLightsBlackTween.cancel();
						}
						oldBlammedLightsBlackTween = null;
						oldBlammedLightsBlack.alpha = 1;

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						gf.color = color;
					}
					
					if(curStage == 'philly') {
						if(phillyCityLightsEvent != null) {
							phillyCityLightsEvent.forEach(function(spr:BGSprite) {
								spr.visible = false;
							});
							phillyCityLightsEvent.members[0].visible = true;
							phillyCityLightsEvent.members[0].alpha = 1;
						}
					}
				} else {
					if(oldBlammedLightsBlack.alpha != 0) {
						if(oldBlammedLightsBlackTween != null) {
							oldBlammedLightsBlackTween.cancel();
						}
						oldBlammedLightsBlackTween = FlxTween.tween(oldBlammedLightsBlack, {alpha: 0}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								oldBlammedLightsBlackTween = null;
							}
						});
					}

					if(curStage == 'philly') {
						phillyCityLights.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[0];
						if(memb != null) {
							memb.visible = true;
							memb.alpha = 1;
							if(phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) {
								phillyCityLightsEventTween = null;
							}, ease: FlxEase.quadInOut});
						}
					}

					var chars:Array<Character> = [boyfriend, gf, dad];
					for (i in 0...chars.length) {
						if(chars[i].colorTween != null) {
							chars[i].colorTween.cancel();
						}
						chars[i].colorTween = FlxTween.color(chars[i], 1, chars[i].color, FlxColor.WHITE, {onComplete: function(twn:FlxTween) {
							chars[i].colorTween = null;
						}, ease: FlxEase.quadInOut});
					}

					curLight = 0;
					curLightEvent = 0;
				}
			
			case 'Philly Glow':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var doFlash:Void->Void = function() {
					var color:FlxColor = FlxColor.WHITE;
					if(!ClientPrefs.flashing) color.alphaFloat = 0.5;

					FlxG.camera.flash(color, 0.15, null, true);
				};

				

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch(lightId)
				{
					case 0:
						if(oldBlammedLightsBlack.visible == false) {
							oldBlammedLightsBlack.visible = true;
						}
						if(phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
						}

					case 1: //turn on
						if(oldBlammedLightsBlack.visible) {
							oldBlammedLightsBlack.visible = false;
						}
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if(!phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if(ClientPrefs.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.25;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						var charColor:FlxColor = color;
						if(!ClientPrefs.flashing) charColor.saturation *= 0.5;
						else charColor.saturation *= 0.75;

						for (who in chars)
						{
							who.color = charColor;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlow.PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						color.brightness *= 0.5;
						phillyStreet.color = color;

					case 2: // spawn particles
						if(!ClientPrefs.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlow.PhillyGlowParticle = new PhillyGlow.PhillyGlowParticle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Change Mania':
				var players:Int = 2;
				players = Std.parseInt(value2);
				var maniaChange:Int = 3;
				maniaChange = Std.parseInt(value1);
				changeMania(maniaChange, players);
				trace('PLAYER' + players);
				trace('MANIA ' + maniaChange);


			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.playAnim(value1, true);
				char.specialAnim = true;

			case 'Pico Speaker Shoot':
				var shootInt:Int = 1;
				shootInt = FlxG.random.int(1,4);
				gf.playAnim('shoot' + shootInt, true);
				gf.specialAnim = true;
				//trace('shoot' + shootInt);

			case 'Spawn Tankmen':
				if (FlxG.random.bool(65)) {	//pico isnt in genocide mode
					if (FlxG.random.bool(50)) {
						var tempTankman:ShotTankmen = new ShotTankmen(gf.x + (((14 * ClientPrefs.framerate) * 2) + 300), gf.y + 80, true);
						tankmanRun.add(tempTankman);
					} else {
						var tempTankman:ShotTankmen = new ShotTankmen(gf.x - (((14 * ClientPrefs.framerate) * 2) + 300), gf.y + 80, false);
						tankmanRun.add(tempTankman);
					}
				} else {
					//trace('tankmen didnt spawn *vine boom* *vine boom*');
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.idleSuffix = value2;
				char.recalculateDanceIdle();

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = Std.parseFloat(split[0].trim());
					var intensity:Float = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case '3':
						charType = 3;
					case '4':
						charType = 3;
					case '5':
						charType = 3;
					case '6':
						charType = 3;
					case '7':
						charType = 3;
					case '8':
						charType = 3;
					case 'gf' | 'girlfriend'|'2':
						charType = 2;
					case 'dad' | 'opponent'|'1':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							boyfriend.visible = false;
							boyfriend = boyfriendMap.get(value2);
							if(!boyfriend.alreadyLoaded) {
								boyfriend.alpha = 1;
								boyfriend.alreadyLoaded = true;
							}
							boyfriend.visible = true;
							iconP1.changeIcon(boyfriend.healthIcon);
						}

					case 1:
						if (value2 == 'everyone-memz2' && SONG.song.toLowerCase() == 'memz-2'){
							/*if(!dadMap.exists('renderite')) {
								addCharacterToList('renderite', charType);
							}
							dad.visible = false;
							dad = dadMap.get('renderite');

							if(!dadMap.exists('player')) {
								addCharacterToList('player', charType);
							}
							player2 = dadMap.get('player');

							if(!dadMap.exists('quem')) {
								addCharacterToList('quem', charType);
							}
							player3 = dadMap.get('quem');

							if(!dadMap.exists('vee')) {
								addCharacterToList('vee', charType);
							}
							player4 = dadMap.get('vee');

							if(!dadMap.exists('zeraora')) {
								addCharacterToList('zeraora', charType);
							}
							player5 = dadMap.get('zeraora');

							if(!dadMap.exists('redBambi')) {
								addCharacterToList('redBambi', charType);
							}
							player6 = dadMap.get('redBambi');

							if(!dadMap.exists('sallyFloombo')) {
								addCharacterToList('sallyFloombo', charType);
							}
							player7 = dadMap.get('sallyFloombo');

							if(!dadMap.exists('silyvon')) {
								addCharacterToList('silyvon', charType);
							}
							player8 = dadMap.get('silyvon');

							add(player2);
							player2.x = dad.x + FlxG.random.int(-250,250);
							player2.y = dad.y + FlxG.random.int(-250,250);
							add(player3);
							player3.x = dad.x + FlxG.random.int(-250,250);
							player3.y = dad.y + FlxG.random.int(-250,250);
							add(player4);
							player4.x = dad.x + FlxG.random.int(-250,250);
							player4.y = dad.y + FlxG.random.int(-250,250);
							add(player5);
							player5.x = dad.x + FlxG.random.int(-250,250);
							player5.y = dad.y + FlxG.random.int(-250,250);
							add(player6);
							player6.x = dad.x + FlxG.random.int(-250,250);
							player6.y = dad.y + FlxG.random.int(-250,250);
							add(player7);
							player7.x = dad.x + FlxG.random.int(-250,250);
							player7.y = dad.y + FlxG.random.int(-250,250);
							add(player8);
							player8.x = dad.x + FlxG.random.int(-250,250);
							player8.y = dad.y + FlxG.random.int(-250,250);
							*/
							iconP2.changeIcon('memzeveryone');
							reloadHealthBarColors();
						}
						else if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							dad.visible = false;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf) {
									gf.visible = true;
								}
							} else {
								gf.visible = false;
							}
							if(!dad.alreadyLoaded) {
								dad.alpha = 1;
								dad.alreadyLoaded = true;
							}
							if (value2 == 'evzero'){
								FlxTween.tween(dad, {y: -1500}, 3, {ease: FlxEase.elasticInOut, type: BACKWARD});

							}
							dad.visible = true;
							iconP2.changeIcon(dad.healthIcon);
						}

					case 2:
						if(gf.curCharacter != value2) {
							if(!gfMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							gf.visible = false;
							gf = gfMap.get(value2);
							if(!gf.alreadyLoaded) {
								gf.alpha = 1;
								gf.alreadyLoaded = true;
							}
						}
				}
				reloadHealthBarColors();
			
			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();
			case 'Set Camera Zoom'|'Default Camera Zoom':
				if (ClientPrefs.sourceEvents){
				var duration:Float = 0.5;
				if (value2 != null) { duration = Std.parseFloat(value2); }
				if (Math.isNaN(duration)) duration = 0.5;
				if (value1 != null){
					defaultCamZoom = Std.parseFloat(value1);
				}else{
					switch (curStage){
						case 'tank':
							defaultCamZoom = 0.9;
						default:
							var stageData:StageFile = StageData.getStageFile(curStage);
							if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
								stageData = {
									directory: "",
									defaultZoom: 0.9,
									isPixelStage: false,
								
									boyfriend: [770, 100],
									girlfriend: [400, 130],
									opponent: [100, 100]
								};
							}
							defaultCamZoom = stageData.defaultZoom;
					}
				}

				if (cameraTwn != null) cameraTwn.cancel();
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, duration, {ease: FlxEase.circInOut,
					onComplete:function(_){
						cameraTwn = null;
				}});
				}	
			case 'Set CamHUD Zoom'|'Default CamHUD Zoom':
				if (ClientPrefs.sourceEvents){
				var duration:Float = 0.5;
				if (value2 != null) { duration = Std.parseFloat(value2); }
				if (Math.isNaN(duration)) duration = 0.5;
				if (value1 != null){
					defaultHudZoom = Std.parseFloat(value1);
				}else{
					defaultHudZoom = 1;
				}

				if (camhudTwn != null) camhudTwn.cancel();
				camhudTwn = FlxTween.tween(camHUD, {zoom: defaultHudZoom}, duration, {ease: FlxEase.circInOut,
					onComplete:function(_){
						camhudTwn = null;
				}});
				}
			case 'Flash camera':
				if (ClientPrefs.sourceEvents){
				var flashduration:Float = 1;
				if (value1 != null) { flashduration = Std.parseFloat(value1); }
				if (Math.isNaN(flashduration)) flashduration = 1;
				
				FlxG.camera.flash(FlxColor.WHITE, flashduration);
				camHUD.flash(FlxColor.WHITE, flashduration);}	
			case 'Do Camera rotate':
				if (ClientPrefs.sourceEvents){
				//Some Shaggy mod code because I have no fkin' idea what I'm doing :skull
				rotCam = true;
				rotCamSpd = Std.parseFloat(value1);
				rotCamRange = Std.parseFloat(value2);}
			case 'Stop Camera rotate':
				if (ClientPrefs.sourceEvents){
				rotCam = false;
				camera.angle = 0;}
			case 'Set Camera speed':
				if (ClientPrefs.sourceEvents){
					var camSpeed:Float = 0.5;
					if (value1 != null) camSpeed = Std.parseFloat(value1);
					if (Math.isNaN(camSpeed)) camSpeed = 0.5;
					if (camSpeed < 0) camSpeed = 0;
						cameraSpeed = camSpeed;
				}
			case 'Do CamHud rotate':
				if (ClientPrefs.sourceEvents){
				//Some Shaggy mod code because I have no fkin' idea what I'm doing :skull
				rotCamHud = true;
				rotCamHudSpd = Std.parseFloat(value1);
				rotCamHudRange = Std.parseFloat(value2);}
			case 'Stop CamHud rotate':
				if (ClientPrefs.sourceEvents){
				rotCamHud = false;
				camHUD.angle = 0;}
			case 'Do note move':
				if (ClientPrefs.sourceEvents){
				swayNotes = true;
				swayNotesSpd = Std.parseFloat(value1);
				swayNotesRange = Std.parseFloat(value2);}
			case 'Stop note move':
				if (ClientPrefs.sourceEvents){
				swayNotes = false;
				camHUD.x = 0;}
			case 'Flip CamHud':
				if (ClientPrefs.sourceEvents){
				camHUD.angle = camHUD.angle + 180;}
			case 'Hide Elements':
				if (ClientPrefs.sourceEvents){
				var type:Int = Std.parseInt(value1);
				var enabled:Bool = false;
				if (value2 == "true")
					enabled = true;

				if (Math.isNaN(type)) 
					type = 0;
				
				switch(type){
					case 0:
						camHUD.visible = enabled;
						/*
						playerStrums.members[0].visible = enabled;
						strumLineNotes.members[4].visible = enabled;
						playerStrums.members[1].visible = enabled;
						strumLineNotes.members[5].visible = enabled;
						playerStrums.members[2].visible = enabled;
						strumLineNotes.members[6].visible = enabled;
						playerStrums.members[3].visible = enabled;
						strumLineNotes.members[7].visible = enabled;
						opponentStrums.members[0].visible = enabled;
						strumLineNotes.members[0].visible = enabled;
						opponentStrums.members[1].visible = enabled;
						strumLineNotes.members[1].visible = enabled;
						opponentStrums.members[2].visible = enabled;
						strumLineNotes.members[2].visible = enabled;
						opponentStrums.members[3].visible = enabled;
						strumLineNotes.members[3].visible = enabled;
						scoreTxt.visible = enabled;
						iconP1.visible = enabled;
						iconP2.visible = enabled;
						healthBar.visible = enabled;
						healthBarBG.visible = enabled; */
					case 1: 
						playerStrums.members[0].visible = enabled;
						strumLineNotes.members[4].visible = enabled;
						playerStrums.members[1].visible = enabled;
						strumLineNotes.members[5].visible = enabled;
						playerStrums.members[2].visible = enabled;
						strumLineNotes.members[6].visible = enabled;
						playerStrums.members[3].visible = enabled;
						strumLineNotes.members[7].visible = enabled;
					case 2:
						opponentStrums.members[0].visible = enabled;
						strumLineNotes.members[0].visible = enabled;
						opponentStrums.members[1].visible = enabled;
						strumLineNotes.members[1].visible = enabled;
						opponentStrums.members[2].visible = enabled;
						strumLineNotes.members[2].visible = enabled;
						opponentStrums.members[3].visible = enabled;
						strumLineNotes.members[3].visible = enabled;
					case 3:
						scoreTxt.visible = enabled;
						iconP1.visible = enabled;
						iconP2.visible = enabled;
						healthBar.visible = enabled;
						healthBarBG.visible = enabled;
						healthBarOverlay.visible = enabled;
				}}
			case 'Scroll speed':
				if (ClientPrefs.sourceEvents){
			if (!ClientPrefs.overrideScroll){
				var newspeed:Float = 3;
				if (value1 != null) { newspeed = Std.parseFloat(value1); }
				if (Math.isNaN(newspeed)) newspeed = 3;


				FlxTween.tween(SONG, {speed:newspeed}, 1, {ease:FlxEase.quadOut});
			}}
			case 'Jumpscare':
				if (ClientPrefs.sourceEvents){
				var val2 = value2;
				
				//If no value specified, don't fire event
				if (value1 != null && val2 != null){
					var split:Array<String> = value2.split(',');

					var jumpscare = new FlxSprite(0, 0).loadGraphic(Paths.image(value1));
					add(jumpscare);
					jumpscare.visible = false;
					//So small ass jumpscares look blurry lol
					jumpscare.screenCenter();
					jumpscare.updateHitbox();
					jumpscare.antialiasing = ClientPrefs.globalAntialiasing;
					//You won't be seeing the notes very good so yeah
					jumpscare.cameras = [camHUD];

					jumpscare.visible = true;
					FlxG.sound.play(Paths.sound(split[0]), 1);

					FlxTween.tween(jumpscare, {alpha:0}, 3, {startDelay:Std.parseFloat(split[1]),ease:FlxEase.quadInOut,onComplete:function(twn:FlxTween){
						//Cleanup
						remove(jumpscare);
					}});
				}}

		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	var camhudTwn:FlxTween;
	public function moveCamera(isDad:Bool) {
		if(isDad) {
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0];
			camFollow.y += dad.cameraPosition[1];
			tweenCamIn();
		} else {
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}
			camFollow.x -= boyfriend.cameraPosition[0];
			camFollow.y += boyfriend.cameraPosition[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween) {
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function finishSong():Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	var transitioning = false;
	public function endSong():Void
	{
		//You ain't getting out of this that easily.
		if (songMisses >= 100) health = -1;
		if (ClientPrefs.antispam){
			//Should kill you if you tried to cheat
			if(!startingSong) {
				notes.forEach(function(daNote:Note) {
					if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
						health -= 0.0475;
					}
				});
				for (daNote in unspawnNotes) {
					if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
						health -= 0.0475;
					}
				}

				if(doDeathCheck()) {
					return;
				}
			}
		}
		
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
				'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		
		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('dialogue'));

					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					unloadAssets();
					MusicBeatState.switchState(new ResultsState());

					// if ()
					if(!usedPractice) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					usedPractice = false;
					changedDifficulty = false;
					cpuControlled = false;
				}
				else
				{
					var difficulty:String = '' + CoolUtil.difficultyStuff[storyDifficulty][1];

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelFadeTween();
							//resetSpriteCache = true;
							unloadAssets();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelFadeTween();
						//resetSpriteCache = true;
						unloadAssets();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				cancelFadeTween();
				unloadAssets();
				CustomFadeTransition.nextCamera = camOther;
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				MusicBeatState.switchState(new ResultsState());
				FlxG.sound.playMusic(Paths.music('dialogue'));
				usedPractice = false;
				changedDifficulty = false;
				cpuControlled = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + 8);
		allNotesMs += noteDiff;
		averageMs = allNotesMs/songHits;
		msTimeTxt.alpha = 1;
		msTimeTxt.text =Std.string(Math.round(noteDiff)) + "ms";
		if (msTimeTxtTween != null){
			msTimeTxtTween.cancel(); msTimeTxtTween.destroy(); // top 10 awesome code
		}
		msTimeTxtTween = FlxTween.tween(msTimeTxt, {alpha: 0}, 0.25, {
			onComplete: function(tw:FlxTween) {msTimeTxtTween = null;}, startDelay: 0.7
		});
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//
		var daRating:String;
		var rating:FlxSprite = new FlxSprite();
		rating.cameras = [(ClientPrefs.lockrating ? camHUD : camGame)];
		var score:Int = 450;

		if (!ClientPrefs.newInput){
		

		daRating = "perfect";

		if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'shit';
			score = 50;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.5)
		{
			daRating = 'bad';
			score = 100;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			score = 200;
			goods++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.15)
		{
			spawnNoteSplashOnNote(note);
			daRating = 'sick';
			score = 350;
			sicks++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.05)
		{
			spawnNoteSplashOnNote(note);
			daRating = 'awesome';
			score = 400;
			awesomes++;
		}

		if(daRating == 'perfect')
		{
			spawnNoteSplashOnNote(note);
			perfects++;
		}
		}else{
			daRating = Conductor.judgeNote(note, noteDiff);

			if (daRating == 'shit')
				{
					score = 50;
					shits++;
				}
				else if (daRating == 'bad')
				{
					score = 100;
					bads++;
				}
				else if (daRating == 'good')
				{
					daRating = 'good';
					score = 200;
					goods++;
				}
				else if (daRating == 'sick')
				{
					spawnNoteSplashOnNote(note);
					daRating = 'sick';
					score = 350;
					sicks++;
				}
				else if (daRating == 'awesome')
				{
					spawnNoteSplashOnNote(note);
					daRating = 'awesome';
					score = 400;
					awesomes++;
				}
		
				if(daRating == 'perfect')
				{
					spawnNoteSplashOnNote(note);
					perfects++;
				}
		}

		//trace(daRating);

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			songHits++;
			RecalculateRating();
			/*if(scoreTxtTween != null) {
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.1;
			scoreTxt.scale.y = 1.1;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});*/
		}

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = !ClientPrefs.hideHud;

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = !ClientPrefs.hideHud;
		comboSpr.cameras = [(ClientPrefs.lockrating ? camHUD : camGame)];

		msTimeTxt.x = comboSpr.x+100;
		msTimeTxt.y = comboSpr.y-50;
		msTimeTxt.cameras = [(ClientPrefs.lockrating ? camHUD : camGame)];

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(comboSpr);
		add(rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;
			numScore.cameras = [(ClientPrefs.lockrating ? camHUD : camGame)];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	
	private function keyShit():Void
		{
			var oneHold = [controls.B5];
			var onePress = [controls.B5_P];
			var oneRelease = [controls.B5_R];

			var twoHold = [controls.NOTE_LEFT, controls.NOTE_RIGHT];
			var twoPress = [controls.NOTE_LEFT_P, controls.NOTE_RIGHT_P];
			var twoRelease = [controls.NOTE_LEFT_R, controls.NOTE_LEFT_R];

			var threeHold = [controls.A3, controls.A4, controls.A5];
			var threePress = [controls.A3_P, controls.A4_P, controls.A5_P];
			var threeRelease = [controls.A3_R, controls.A4_R, controls.A5_R];

			var fourHold = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
			var fourPress = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			var fourRelease = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];

			var fiveHold = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.B5, controls.NOTE_UP, controls.NOTE_RIGHT];
			var fivePress = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.B5_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			var fiveRelease = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.B5_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
	
			var sixHold = [controls.A1, controls.A2, controls.A3, controls.A5, controls.A6, controls.A7];
			var sixPress = [controls.A1_P, controls.A2_P, controls.A3_P, controls.A5_P, controls.A6_P, controls.A7_P];
			var sixRelease = [controls.A1_R, controls.A2_R, controls.A3_R, controls.A5_R, controls.A6_R, controls.A7_R];
	
			var sevenHold = [controls.A1, controls.A2, controls.A3, controls.A4, controls.A5, controls.A6, controls.A7];
			var sevenPress = [controls.A1_P, controls.A2_P, controls.A3_P, controls.A4_P, controls.A5_P, controls.A6_P, controls.A7_P];
			var sevenRelease = [controls.A1_R, controls.A2_R, controls.A3_R, controls.A4_R, controls.A5_R, controls.A6_R, controls.A7_R];

			var eightHold = [controls.B1, controls.B2, controls.B3, controls.B4, controls.B6, controls.B7, controls.B8, controls.B9];
			var eightPress = [controls.B1_P, controls.B2_P, controls.B3_P, controls.B4_P, controls.B6_P, controls.B7_P, controls.B8_P, controls.B9_P];
			var eightRelease = [controls.B1_R, controls.B2_R, controls.B3_R, controls.B4_R, controls.B6_R, controls.B7_R, controls.B8_R, controls.B9_R];
	
			var nineHold = [controls.B1, controls.B2, controls.B3, controls.B4, controls.B5, controls.B6, controls.B7, controls.B8, controls.B9];
			var ninePress = [controls.B1_P, controls.B2_P, controls.B3_P, controls.B4_P, controls.B5_P, controls.B6_P, controls.B7_P, controls.B8_P, controls.B9_P];
			var nineRelease = [controls.B1_R, controls.B2_R, controls.B3_R, controls.B4_R, controls.B5_R, controls.B6_R, controls.B7_R, controls.B8_R, controls.B9_R];

			var controlArray:Array<Bool> = fourPress;
			var controlReleaseArray:Array<Bool> = fourRelease;
			var controlHoldArray:Array<Bool> = fourHold;
	
			switch (mania)
			{
				case 0:
					controlArray = onePress;
					controlReleaseArray = oneRelease;
					controlHoldArray = oneHold;
				case 1:
					controlArray = twoPress;
					controlReleaseArray = twoRelease;
					controlHoldArray = twoHold;
				case 2:
					controlArray = threePress;
					controlReleaseArray = threeRelease;
					controlHoldArray = threeHold;
				case 3:
					controlArray = fourPress;
					controlReleaseArray = fourRelease;
					controlHoldArray = fourHold;
				case 4:
					controlArray = fivePress;
					controlReleaseArray = fiveRelease;
					controlHoldArray = fiveHold;
				case 5:
					controlArray = sixPress;
					controlReleaseArray = sixRelease;
					controlHoldArray = sixHold;
				case 6:
					controlArray = sevenPress;
					controlReleaseArray = sevenRelease;
					controlHoldArray = sevenHold;
				case 7:
					controlArray = eightPress;
					controlReleaseArray = eightRelease;
					controlHoldArray = eightHold;
				case 8:
					controlArray = ninePress;
					controlReleaseArray = nineRelease;
					controlHoldArray = nineHold;
			}
	
			var anyH = false;
			var anyP = false;
			var anyR = false;
			for (i in 0...controlArray.length)
			{
				if (controlHoldArray[i])
					anyH = true;
				if (controlArray[i])
					anyP = true;
				if (controlReleaseArray[i])
					anyR = true;
			}

			for (i in 0...controlArray.length) {
				FlxG.watch.addQuick('key ' + i + ' pressed = ', controlArray[i]);
			}
	
			// FlxG.watch.addQuick('asdfa', upP);
			if (!boyfriend.stunned && generatedMusic)		//turned back onto this - tposejank
				{	//might enable thropies again (why the fuck do i say it like the old ps3 times wow)
					// rewritten inputs???
					notes.forEachAlive(function(daNote:Note)
					{
						// hold note functions
						if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
						&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
							goodNoteHit(daNote);
						}
					});
		
					if ((controlHoldArray.contains(true) || controlArray.contains(true)) && !endingSong) {
						var canMiss:Bool = (!ClientPrefs.ghostTapping);
						if (controlArray.contains(true)) {
							for (i in 0...controlArray.length) {
								// heavily based on my own code LOL if it aint broke dont fix it
								var pressNotes:Array<Note> = [];
								var notesDatas:Array<Int> = [];
								var notesStopped:Bool = false;
		
								var sortedNotesList:Array<Note> = [];
								notes.forEachAlive(function(daNote:Note)
								{
									if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate 
									&& !daNote.wasGoodHit && daNote.noteData == i) {
										sortedNotesList.push(daNote);
										notesDatas.push(daNote.noteData);
										canMiss = true;
									}
								});
								sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		
								if (sortedNotesList.length > 0) {
									for (epicNote in sortedNotesList)
									{
										for (doubleNote in pressNotes) {
											if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 10) {
												doubleNote.kill();
												notes.remove(doubleNote, true);
												doubleNote.destroy();
											} else
												notesStopped = true;
										}
											
										// eee jack detection before was not super good
										if (controlArray[epicNote.noteData] && !notesStopped) {
											goodNoteHit(epicNote);
											pressNotes.push(epicNote);
										}
		
									}
								}
								else if (canMiss && !ClientPrefs.ghostTapping) 
									ghostMiss(controlArray[i], i, true);
								else if (canMiss && ClientPrefs.antispam) 
									ghostMiss(controlArray[i], i, true);
		
								// I dunno what you need this for but here you go
								//									- Shubs
		
								// Shubs, this is for the "Just the Two of Us" achievement lol
								//									- Shadow Mario
								if (!keysPressed[i] && controlArray[i]) 
									keysPressed[i] = true;
							}
						}
		
						#if ACHIEVEMENTS_ALLOWED
						var achieve:String = checkForAchievement(['oversinging']);
						if (achieve != null) {
							startAchievement(achieve);
						}
						#end
					} else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing')
					&& !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.dance();
				}
		
				playerStrums.forEach(function(spr:StrumNote)
				{
					if(controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm') {
						spr.playAnim('pressed');
						spr.resetAnim = 0;
					}
					if(controlReleaseArray[spr.ID]) {
						spr.playAnim('static');
						spr.resetAnim = 0;
					}
				});
			}

	function ghostMiss(statement:Bool = false, direction:Int = 0, ?ghostMiss:Bool = false) {
		if (statement) {
			GameOverSubstate.deathReason = 'Died by spamming.';
			noteMissPress(direction, ghostMiss);
			callOnLuas('noteMissPress', [direction]);
		}
	}

	function noteMiss(daNote:Note):Void
		{
			if (!boyfriend.stunned)
			{
				GameOverSubstate.deathReason = 'Died by missing notes.';
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))		//pico never sad when bf miss so fuck yea
				{
					gf.playAnim('sad');
				}
				combo = 0;
	
				if(!practiceMode) songScore -= 10;
				if(!endingSong){
					songMisses++;
					camHUD.shake(0.05, 0.25);
				};
				RecalculateRating();
	
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');
	
				/*boyfriend.stunned = true;
				// get stunned for 1/60 of a second, makes you able to
				new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});*/

				vocals.volume = 0;
				
				
				if (daNote.noteType == 'GF Sing') {
					gf.playAnim('sing' + Main.charDir[Main.gfxHud[mania][daNote.noteData]] + 'miss', true);
				} else if (daNote.noteType == 'AntiMiss Note') {
					GameOverSubstate.deathReason = "Died by missing an antimiss note.";
					health = 0;
				}else {
					var daAlt = '';

					if (SONG.notes[Math.floor(curStep / 16)].altAnim || daNote.noteType == 'Alt Animation') {	//bf can play alt notes too without having plagiarize the chart
						daAlt = '-alt';
					}
					if (boyfriend.animOffsets.exists('sing' + Main.charDir[Main.gfxHud[mania][daNote.noteData]] + 'miss' + daAlt)){
						boyfriend.playAnim('sing' + Main.charDir[Main.gfxHud[mania][daNote.noteData]] + 'miss' + daAlt, true);
					}
				}
				callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
			}
		}

	function noteMissPress(direction:Int = 1, ?ghostMiss:Bool = false):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				if(ghostMiss) ghostMisses++;
				songMisses++;
			}
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			boyfriend.playAnim('sing' + Main.charDir[Main.gfxHud[mania][direction]] + 'miss', true);
			vocals.volume = 0;
		}
	}

	function goodNoteHit(note:Note):Void
		{
			if (!note.wasGoodHit)
			{
				if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;	//fuck you you cant press this note dumbass
				if (!note.isSustainNote && (!note.ignoreNote || !note.hitCausesMiss)) {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Heal Note':
						if(!boyfriend.stunned)
						{
							health = 100;
							note.wasGoodHit = true;
						}
					case 'Kill Note' | 'Sylveon Note':
						if(!boyfriend.stunned)
						{
							GameOverSubstate.deathReason = 'Died by hitting a kill note.';
							health = 0;
							note.wasGoodHit = true;
						}
					case 'AntiMiss Note':
						if (!boyfriend.stunned)
						{
							note.wasGoodHit = true;
						}
					case 'Hurt Note': //Hurt note
	
						if(!boyfriend.stunned)
						{
							noteMiss(note);
							if(!endingSong)
							{
								--songMisses;
								RecalculateRating();
								if(!note.isSustainNote) {
									health -= 0.26;
								}
								else health -= 0.06; //0.06 + 0.04 = -0.1 (-5%) of HP if you hit a hurt sustain note
		
								if(boyfriend.animation.getByName('hurt') != null) {
									boyfriend.playAnim('hurt', true);
									boyfriend.specialAnim = true;
								}
							}
	
							note.wasGoodHit = true;
							vocals.volume = 0;
	
							if (!note.isSustainNote)
							{
								note.kill();
								notes.remove(note, true);
								note.destroy();
							}
						}
						return;
				}
	
				if (!note.isSustainNote)
				{
					//Disables the rating system entirely if botplay is enabled.
					//This should prevent lagging on spammy songs.
					if (!cpuControlled) popUpScore(note);
					if (combo < 9999) combo += 1;	//who the fuck put 9999+ notes
					if (combo > highestcombo) highestcombo = combo;
				}

				/**
				 * Im really stupid ngl
				 */
				if (!note.noAnimation) {
					if (note.noteType == 'Hey!') {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
			
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
					else if (note.noteType == 'GF Sing') {
						gf.playAnim('sing' + Main.charDir[Main.gfxHud[mania][note.noteData]], true);
					} else {
						var daAlt = '';
						if(note.noteType == 'Alt Animation') daAlt = '-alt';
						var animToPlay:String = '';
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(note.noteData))]];
						boyfriend.playAnim(animToPlay + daAlt, true);
					}
				}
	
				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;
	
				if(cpuControlled) {
					var time:Float = 0.15;
					if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}
					playerStrums.forEach(function(spr:StrumNote)
						{
							if (Math.abs(note.noteData) == spr.ID && !note.isSustainNote)
							{
								if (spr.bumpTween != null){
									spr.bumpTween.cancel();
									spr.bumpTween = null;
								}
								spr.scale.x = Note.scales[PlayState.SONG.mania] + 0.4;
								spr.scale.y = Note.scales[PlayState.SONG.mania] - 0.4;
								spr.bumpTween = FlxTween.tween(spr.scale, {x: Note.scales[PlayState.SONG.mania], y: Note.scales[PlayState.SONG.mania]}, 0.3, {ease: FlxEase.quadOut, onComplete: function(_){
									spr.bumpTween = null;
								}});
							}
						});
					StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % Main.ammo[mania], time);
				} else {
					playerStrums.forEach(function(spr:StrumNote)
					{
						if (Math.abs(note.noteData) == spr.ID && !note.isSustainNote)
						{
							if (spr.bumpTween != null){
								spr.bumpTween.cancel();
								spr.bumpTween = null;
							}
							spr.scale.x = Note.scales[PlayState.SONG.mania] + 0.4;
							spr.scale.y = Note.scales[PlayState.SONG.mania] - 0.4;
							spr.bumpTween = FlxTween.tween(spr.scale, {x: Note.scales[PlayState.SONG.mania], y: Note.scales[PlayState.SONG.mania]}, 0.3, {ease: FlxEase.quadOut, onComplete: function(_){
								spr.bumpTween = null;
							}});
							spr.playAnim('confirm', true);
						}
					});
				}
	
				note.wasGoodHit = true;
				vocals.volume = 1;
	
				var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
				var leData:Int = note.noteData;
				var leType:String = note.noteType;
				if (!note.isSustainNote)
				{
					if(cpuControlled) {
						boyfriend.holdTimer = 0;
					}
					note.kill();
					notes.remove(note, true);
					note.destroy();
				} else if(cpuControlled) {
					var targetHold:Float = Conductor.stepCrochet * 0.001 * boyfriend.singDuration;
					if(boyfriend.holdTimer + 0.2 > targetHold) {
						boyfriend.holdTimer = targetHold - 0.2;
					}
				}
				callOnLuas('goodNoteHit', [leData, leType, isSus]);

				if(ClientPrefs.cameraMoveOnNotes){
					if(SONG.notes[Math.floor(curStep / 16)].mustHitSection == true && !note.isSustainNote){
						if (!boyfriend.stunned){
							switch(Std.int(Math.abs(note.noteData))){				 
								case 0:
									camFollow.set(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y - 100);
									camFollow.x += boyfriend.cameraPosition[0] - cameramovingoffsetbf; camFollow.y += boyfriend.cameraPosition[1];	
								case 1:
									camFollow.set(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y - 100);
									camFollow.x += boyfriend.cameraPosition[0]; camFollow.y += boyfriend.cameraPosition[1] + cameramovingoffsetbf;			
								case 2:
									camFollow.set(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y - 100);
									camFollow.x += boyfriend.cameraPosition[0]; camFollow.y += boyfriend.cameraPosition[1] - cameramovingoffsetbf;
								case 3:							
									camFollow.set(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y - 100);
									camFollow.x += boyfriend.cameraPosition[0] + cameramovingoffsetbf; camFollow.y += boyfriend.cameraPosition[1];			
							}                        
						}
					}
				}
			}
		}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int) {
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, false);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function moveTank()
        {
                tankAngle += FlxG.elapsed * tankSpeed;
                tankRolling.angle = tankAngle - 90 + 15;
                tankRolling.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
                tankRolling.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
        }

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
			gf.specialAnim = true;
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.danced = false; //Sets head to the correct position once the animation ends
		gf.playAnim('hairFall');
		gf.specialAnim = true;
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}
		if(gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5, {ease: FlxEase.circInOut});
				FlxTween.tween(camHUD, {zoom: defaultHudZoom}, 0.5, {ease: FlxEase.circInOut});
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];
		super.destroy();
	}

	public function cancelFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);

		if (curStage == 'trippy') {
		

		//Dave and bambi glitch effect for the background.
		
	}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;

	var invert:Int = 1;
	

	
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}
		trace('curBeat: '+curBeat);

		//Fix the notes
		//opponentStrums.forEach(function(spr:StrumNote) { FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.1); });
		//playerStrums.forEach(function(spr:StrumNote) { FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.1); });
		
		if (SONG.player2.endsWith('-bumpin')){
			if (curBeat % 2 == 0){
				dad.flipX = true;
			}else{
				dad.flipX = false;
			}
			FlxTween.tween(dad, {angle: invert*36}, Conductor.crochet / 800, {ease: FlxEase.quadInOut,onComplete:function(twn:FlxTween){
				FlxTween.tween(dad, {angle: 0}, Conductor.crochet / 800, {ease: FlxEase.quadInOut});
			}});

			FlxTween.tween(dad, {y: dad.y - 360}, Conductor.crochet / 1800, {ease: FlxEase.circOut,type:PINGPONG});
		}

		if (ClientPrefs.dobumpin){
			FlxTween.tween(dad.scale, {x: dad.scale.x + 0.5, y: dad.scale.y - 0.25}, Conductor.crochet / 2000, {ease: FlxEase.quadOut, type: BACKWARD});
			FlxTween.tween(boyfriend.scale, {x: boyfriend.scale.x + 0.25, y: boyfriend.scale.y - 0.1}, Conductor.crochet / 2000, {ease: FlxEase.quadOut, type: BACKWARD});
			FlxTween.tween(gf.scale, {x: gf.scale.x + 0.5, y: gf.scale.y - 0.25}, Conductor.crochet / 2000, {ease: FlxEase.quadOut, type: BACKWARD});

		}

		//Hide the song artist thing now
		if (curBeat >= 10 && curBeat % 4 == 0){
			FlxTween.tween(writertxt, {alpha: 0, x: -1000}, .5, {ease: FlxEase.backIn});
			FlxTween.tween(writerbg, {alpha: 0, x: -1000}, .5, {ease: FlxEase.backIn});
			FlxTween.tween(unsupportedText, {alpha: 0}, 10, {ease: FlxEase.circOut});
		}
		
		//I have no god damn idea what I'm doing.
		//The old icon rotation was glitchy so I moved it to beathit.
		/*
		if (curBeat % gfSpeed == 0) {
			curBeat % (gfSpeed * 2) == 0 ? {
				if (ClientPrefs.dohealthrot){
					FlxTween.angle(iconP1, -(ClientPrefs.healthrot), 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.tween(iconP1.scale, {x: (iconP1.scale.x - 0.2), y: (iconP1.scale.y + 0.3)}, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut,type:BACKWARD});
					FlxTween.angle(iconP2, ClientPrefs.healthrot, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.tween(iconP2.scale, {x: (iconP1.scale.x + 0.2), y: (iconP1.scale.y - 0.3)}, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut,type:BACKWARD});
				}
			} : {
				if (ClientPrefs.dohealthrot){
					FlxTween.angle(iconP2, -(ClientPrefs.healthrot), 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.tween(iconP1.scale, {x: (iconP1.scale.x + 0.2), y: (iconP1.scale.y - 0.3)}, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut,type:BACKWARD});
					FlxTween.angle(iconP1, ClientPrefs.healthrot, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.tween(iconP2.scale, {x: (iconP1.scale.x - 0.2), y: (iconP1.scale.y + 0.3)}, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut,type:BACKWARD});
				}
			}
			
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}*/

		if (curStage == 'tank') {
			if (curBeat % 2 == 0) {
				tanjcuk.animation.play('dancey');
				tankbop0.animation.play('danceya');
				tank1.animation.play('dietz');
				tank2.animation.play('idle');
				tank3.animation.play('idle');
				tank4.animation.play('idle');
				tank5.animation.play('idle');
			}
		}

		if (SONG.song.toLowerCase() == 'my-friends' || SONG.song.toLowerCase() == 'speeding'){
			FlxTween.tween(squad.scale, {x: squad.scale.x + 0.5, y: squad.scale.y - 0.25}, Conductor.crochet / 2000, {ease: FlxEase.quadOut, type: BACKWARD});
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (!ClientPrefs.dohealthrot){
			//Old version of the icon bumpin'

			//iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			//iconP2.setGraphicSize(Std.int(iconP2.width + 30));
		}

		iconrot = iconrot * -1;
		invert = invert * -1;

		//This code doesn't work right, look in beatHit() for the working code
		//FlxTween.angle(iconP1, (32 * iconrot), 0, 1, {ease: FlxEase.quartOut});
		//FlxTween.angle(iconP2, -(32 * iconrot), 0, 1, {ease: FlxEase.quartOut});

		if (ClientPrefs.dohealthrot){
			curBeat % (gfSpeed * 2) == 0 ? {
				iconP1.angle = ClientPrefs.healthrot;
				iconP2.angle = -ClientPrefs.healthrot;
				iconP1.scale.set(1, 2);
				iconP2.scale.set(2, 1);
			} : {
				iconP1.angle = -ClientPrefs.healthrot;
				iconP2.angle = ClientPrefs.healthrot;
				iconP1.scale.set(2, 1);
				iconP2.scale.set(1, 2);
			}
			
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}else{
			iconP1.scale.set(1.2, 1.2);
			iconP2.scale.set(1.2, 1.2);
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		curBeat % (gfSpeed * 2) == 0 ? {
			scoreTxt.angle = 8;
			//timeBarBG.angle = 8;
			//timeBarOverlay.angle = 8;
			timeTxt.angle = 8;
			//timeBar.angle = 8;
		} : {
			scoreTxt.angle = -8;
			//timeBarBG.angle = -8;
			//timeBarOverlay.angle = -8;
			timeTxt.angle = -8;
			//timeBar.angle = -8;
		}

		if (curBeat % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
		{
			gf.dance();

			if (fakegf != null) fakegf.dance();
		}

		if(curBeat % 2 == 0) {
			if (boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith("sing"))
			{
				boyfriend.dance();
			}
			if (dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned)
			{
				dad.dance();

				if (SONG.song.toLowerCase() == 'memz-2'){
							player2.dance();
							player3.dance();
							player4.dance();
							player5.dance();
							player6.dance();
							player7.dance();
							player8.dance();
						}
			}
		} else if(dad.danceIdle && dad.animation.curAnim.name != null && !dad.curCharacter.startsWith('gf') && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned) {
			dad.dance();

			if (SONG.song.toLowerCase() == 'memz-2'){
							player2.dance();
							player3.dance();
							player4.dance();
							player5.dance();
							player6.dance();
							player7.dance();
							player8.dance();
						}
		}

		switch (curStage)
		{
			case 'ally':
				if (ClientPrefs.sourceModcharts){
				// Stop vaporeon from going into pain when beat 224 hits (the end of headache).
				// This so vaporeon doesn't wake up from his sleep
				if (SONG.song.toLowerCase() == 'headache' && FlxG.random.bool(5) && curBeat < 224)
					dad.playAnim('headache',true);}
			case 'icecave':
				if (ClientPrefs.sourceModcharts){
				// Glaceon freezes at beat 160. Stop the random animations here.
				if (SONG.song.toLowerCase() == 'solid' && FlxG.random.bool(5) && curBeat < 160)
					dad.playAnim('cold',true);}
			case 'blank':
				if (ClientPrefs.sourceModcharts){
					if (SONG.song.toLowerCase() == 'forgotten'){
						if (curBeat == 96){
							FlxTween.tween(boxBG,{alpha: 1},12,{ease:FlxEase.quadInOut});
						}
					}
				}
			case 'road':
				if (ClientPrefs.sourceModcharts){
					if (SONG.song.toLowerCase() == 'bling-blunkin'){
						
				}}
			case 'forest':
				if (ClientPrefs.sourceModcharts){
					if (SONG.song.toLowerCase() == 'a-scary-night-song'){
						if (curBeat == 192){
							coBfTrail = new FlxTrail(boyfriend, null, 16, 6, 0.6, 0.2); //nice
							coBfTrail.visible = false;
							insert(members.indexOf(boyfriendGroup) - 1, coBfTrail);
							var dargb = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
							dargb.saturation = 1;
							coBfTrail.color = dargb;

							coDadTrail = new FlxTrail(dad, null, 16, 6, 0.6, 0.2); //nice
							coDadTrail.visible = false;
							insert(members.indexOf(dadGroup) - 1, coDadTrail);
							var dargb = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
							dargb.saturation = 1;
							coDadTrail.color = dargb;

							coBfTrail.visible = true;
							coDadTrail.visible = true;
						}
						if (curBeat == 256){
							coBfTrail.visible = false;
							coDadTrail.visible = false;

							coBfTrail.destroy();
							coDadTrail.destroy();
						}

						if (curBeat == 384){
							coBfTrail = new FlxTrail(boyfriend, null, 16, 6, 0.6, 0.2); //nice
							coBfTrail.visible = false;
							insert(members.indexOf(boyfriendGroup) - 1, coBfTrail);
							var dargb = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
							dargb.saturation = 1;
							coBfTrail.color = dargb;

							coDadTrail = new FlxTrail(dad, null, 16, 6, 0.6, 0.2); //nice
							coDadTrail.visible = false;
							insert(members.indexOf(dadGroup) - 1, coDadTrail);
							var dargb = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
							dargb.saturation = 1;
							coDadTrail.color = dargb;

							coBfTrail.visible = true;
							coDadTrail.visible = true;
						}
						if (curBeat == 512){
							coBfTrail.visible = false;
							coDadTrail.visible = false;

							coBfTrail.destroy();
							coDadTrail.destroy();
						}
					}
				}
			case 'box':
				if (ClientPrefs.sourceModcharts){
				if (SONG.song.toLowerCase() == 'crossover'){
					if (curBeat >= 32 && curBeat <= 47){
						FlxTween.tween(camHUD, {angle: invert * 2}, Conductor.stepCrochet*0.008, {ease:FlxEase.circOut, type:BACKWARD});
						FlxTween.tween(FlxG.camera, {angle: invert * 2}, Conductor.stepCrochet*0.008, {ease:FlxEase.circOut, type:BACKWARD});

						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.2;

						/*var lenoteinvert = invert;
						for (i in 0...playerStrums.length){
							FlxTween.tween(strumLineNotes.members[i + 4], {x: defaultNotePos[i][0] + lenoteinvert * 32}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
							lenoteinvert = -lenoteinvert;
						}
						//Set it back to invert
						lenoteinvert = invert;
						for (i in 0...opponentStrums.length){
							FlxTween.tween(strumLineNotes.members[i], {x: defaultNotePos[i + 4][0] + lenoteinvert * 32}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
							lenoteinvert = -lenoteinvert;
						}*/
					}
					if (curBeat == 48){
						coBfTrail = new FlxTrail(boyfriend, null, 16, 6, 0.6, 0.2); //nice
						coBfTrail.visible = false;
						insert(members.indexOf(boyfriendGroup) - 1, coBfTrail);
						coGfTrail = new FlxTrail(fakegf, null, 16, 6, 0.6, 0.2); //nice
						coGfTrail.visible = false;
						insert(members.indexOf(gfGroup) - 1, coGfTrail);
						coDadTrail = new FlxTrail(dad, null, 16, 6, 0.6, 0.2); //nice
						coDadTrail.visible = false;
						insert(members.indexOf(dadGroup) - 1, coDadTrail);

						var dargb = FlxColor.fromRGB(gf.healthColorArray[0], gf.healthColorArray[1], gf.healthColorArray[2]);
						dargb.saturation = 1;

						coGfTrail.color = dargb;

						var dargb = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
						dargb.saturation = 1;

						coBfTrail.color = dargb;

						var dargb = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
						dargb.saturation = 1;

						coDadTrail.color = dargb;
						
						coBfTrail.visible = true;
                    	coGfTrail.visible = true;
                    	coDadTrail.visible = true;

						/*for (i in 0...playerStrums.length){
							FlxTween.tween(strumLineNotes.members[i + 4], {x: defaultNotePos[i][0],y: defaultNotePos[i][1], angle: 0}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
						}
						for (i in 0...opponentStrums.length){
							FlxTween.tween(strumLineNotes.members[i], {x: defaultNotePos[i + 4][0], y: defaultNotePos[i + 4][1], angle: 0}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
						}*/					
					}
					if (curBeat >= 48 && curBeat < 79){
						FlxTween.tween(camHUD, {angle: invert * 16}, Conductor.stepCrochet*0.004, {ease:FlxEase.circOut, type:BACKWARD});
						FlxTween.tween(FlxG.camera, {angle: invert * 16}, Conductor.stepCrochet*0.004, {ease:FlxEase.circOut, type:BACKWARD});
						
						FlxG.camera.zoom += 1.5;
						camHUD.zoom += 0.6;

						/*var lenoteinvert = invert;
						for (i in 0...playerStrums.length){
							FlxTween.tween(strumLineNotes.members[i + 4], {y: defaultNotePos[i][1] + lenoteinvert * 32}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
							lenoteinvert = -lenoteinvert;
						}
						//Set it back to invert
						lenoteinvert = invert;
						for (i in 0...opponentStrums.length){
							FlxTween.tween(strumLineNotes.members[i], {y: defaultNotePos[i + 4][1] + lenoteinvert * 32}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
							lenoteinvert = -lenoteinvert;
						}
					}
					if (curBeat == 79){
						for (i in 0...playerStrums.length){
							FlxTween.tween(strumLineNotes.members[i + 4], {x: defaultNotePos[i][0],y: defaultNotePos[i][1], angle: 0}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
						}
						for (i in 0...opponentStrums.length){
							FlxTween.tween(strumLineNotes.members[i], {x: defaultNotePos[i + 4][0], y: defaultNotePos[i + 4][1], angle: 0}, Conductor.stepCrochet*0.004, {ease: FlxEase.circOut});
						}*/
					}
					if (curBeat == 80){
						FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quadOut});
					}
					if (ClientPrefs.flashing && curBeat >= 80 && curBeat <= 112){
						FlxG.camera.zoom += 0.6;
						camHUD.zoom += 0.3;

						if (curBeat == 91) 
							FlxTween.tween(camHUD, {alpha: 1}, 10, {ease: FlxEase.quadInOut});
						if (curBeat == 80)
							FlxG.camera.flash(FlxColor.WHITE, 1);
							camHUD.angle = 0;
							camGame.angle = 0;
						if (curBeat % 2 == 0){
							var dargb = FlxColor.fromRGB(FlxG.random.int(0,255),FlxG.random.int(0,255),FlxG.random.int(0,255));
							
							dargb.saturation = 1;
							coDark.visible = true;
							coDark.alpha = 1;
							coDark.color = dargb;
							FlxTween.tween(coDark, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
							
							dargb.saturation = 1;

							//Eat your leg
							boxBG.color = FlxColor.BLACK;
							dad.color = dargb;
							fakegf.color = dargb;
							boyfriend.color = dargb;

							//Change da trail color
							coGfTrail.color = dargb;
							coBfTrail.color = dargb;
							coDadTrail.color = dargb;

							//Change da ui colors
							//You can't pull this off in lua,
							//Can you spongey :/
							kadeEngineWatermark.color = dargb;
							scoretable.color = dargb;
							scoreTxt.color = dargb;
							healthBarBG.color = dargb;
							timeBarBG.color = dargb;
							timeTxt.color = dargb;
						}
					}
					if (curBeat == 112){
						if (ClientPrefs.flashing){
							FlxG.camera.flash(FlxColor.WHITE, 1);
							coDark.visible = false;
							boxBG.color = FlxColor.WHITE;
							dad.color = FlxColor.WHITE;
							fakegf.color = FlxColor.WHITE;
							boyfriend.color = FlxColor.WHITE;

							kadeEngineWatermark.color = uiColor;
							scoretable.color = uiColor;
							scoreTxt.color = uiColor;
							healthBarBG.color = uiColor;
							timeBarBG.color = uiColor;
							timeTxt.color = uiColor;
						}
						coBfTrail.visible = false;
                    	coGfTrail.visible = false;
                    	coDadTrail.visible = false;

						coBfTrail.destroy();
						coGfTrail.destroy();
						coDadTrail.destroy();
					}
					if (curBeat == 1060){
						FlxTween.tween(gf, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
						FlxTween.tween(boxBG, {alpha: 0}, 2, {ease: FlxEase.quadInOut});

						if(boyfriend.curCharacter != "bfGray") {
							if(!boyfriendMap.exists("bfGray")) {
								addCharacterToList("bfGray", 0);
							}

							boyfriend.visible = false;
							boyfriend = boyfriendMap.get("bfGray");
							if(!boyfriend.alreadyLoaded) {
								boyfriend.alpha = 1;
								boyfriend.alreadyLoaded = true;
							}
							boyfriend.visible = true;
							iconP1.changeIcon(boyfriend.healthIcon);
							reloadHealthBarColors();
						}
					}
					if (curBeat == 1124){
							FlxTween.tween(gf, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
							FlxTween.tween(boxBG, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
	
							if(boyfriend.curCharacter != "bf") {
								if(!boyfriendMap.exists("bf")) {
									addCharacterToList("bf", 0);
								}
	
								boyfriend.visible = false;
								boyfriend = boyfriendMap.get("bf");
								if(!boyfriend.alreadyLoaded) {
									boyfriend.alpha = 1;
									boyfriend.alreadyLoaded = true;
								}
								boyfriend.visible = true;
								iconP1.changeIcon(boyfriend.healthIcon);
								reloadHealthBarColors();
							}
						}
				}}
			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat);
		callOnLuas('onBeatHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingString:String;
	public var ratingPercent:Float;
	public static var ratingPercentStatic:Float;
	public var ratingFC:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('ghostMisses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop) {
			ratingPercent = songScore / ((songHits + songMisses - ghostMisses) * 350);
			ratingPercentStatic = ratingPercent;
			if(!Math.isNaN(ratingPercent) && ratingPercent < 0) ratingPercent = 0;

			if(Math.isNaN(ratingPercent)) {
				ratingString = '?';
			} else if(ratingPercent >= 1) {
				ratingPercent = 1;
				ratingString = ratingStuff[ratingStuff.length-1][0]; //Uses last string
			} else {
				for (i in 0...ratingStuff.length-1) {
					if(ratingPercent < ratingStuff[i][1]) {
						ratingString = ratingStuff[i][0];
						break;
					}
				}
			}

			ratingFC = "";
			if (awesomes > 0 || perfects > 0) ratingFC = "AFC"; //You'll never get an AFC on a song but you could try anyway
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10 && songMisses < 100) ratingFC = "Clear";
			else if (songMisses >= 100) ratingFC = "Fail";

			var accuracy:Float = Math.floor(ratingPercent * 100);

			//Basically Kade Engine's ranking system but I improved it.
			if (accuracy >= 98) ranking = 'S+';
			else if (accuracy >= 96) ranking = 'S';
			else if (accuracy >= 90) ranking = 'A';
			else if (accuracy >= 83) ranking = 'B';
			else if (accuracy >= 73) ranking = 'C';
			else if (accuracy >= 63) ranking = 'D';
			else if (accuracy < 63) ranking = 'F';

			if (usedPractice) ranking = '---';
			//Cool Kade Engine stuff in psych lol
			setOnLuas('kadeRanking',ranking);

			//Everything else
			setOnLuas('rating', ratingPercent);
			setOnLuas('ratingName', ratingString);
			setOnLuas('ratingFC', ratingFC);
		}
	}

	public function changeMania(value:Int, player = 0)
		{
			if (value < 9) {
				opponentStrums.forEach(function(spr:StrumNote) { FlxTween.tween(spr, {alpha: 0}, 1); });
				opponentStrums.clear();
				SONG.mania = value;
				mania = value;
				generateStaticArrows(0, true);
				playerStrums.forEach(function(spr:StrumNote) { FlxTween.tween(spr, {alpha: 0}, 1); });
				playerStrums.clear();
				generateStaticArrows(1, true);
				callOnLuas('onChangeMania', [value]);
			}
		}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String>):String {
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if(achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if(achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if(achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if(achievementName == 'week4_nomiss') unlock = true;
								case 'week6':
									if(achievementName == 'week5_nomiss') unlock = true;
								case 'week7':
									if(achievementName == 'week6_nomiss') unlock = true;
								case 'week12':
									if(achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode && !cpuControlled) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice && !cpuControlled) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 20 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing && !ClientPrefs.imagesPersist) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	override function add(Object:FlxBasic):FlxBasic
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

	var curLight:Int = 0;
	var curLightEvent:Int = 0;
}
