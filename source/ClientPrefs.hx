package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	//TO DO: Redo ClientPrefs in a way that isn't too stupid
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var noteSounds:Bool = false;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var doArtistinfo:Bool = true;
	public static var doScoretable:Bool = true;
	public static var dohealthrot:Bool = true;
	public static var dobumpin:Bool = false;
	public static var windowMove:Bool = false;
	public static var cameraMoveOnNotes:Bool = false;
	public static var antispam:Bool = true;
	public static var overrideScroll:Bool = false;
	public static var newInput:Bool = true;
	public static var scrollspeed:Float = 1.0;
	public static var classicBotplayText:Bool = false;
	public static var classicHUD:Bool = false;
	public static var sourceModcharts:Bool = true;
	public static var sourceEvents:Bool = true;
	public static var useOgg:Bool = #if html5 false #else true #end;
	public static var maxmisslimit:Bool = true;
	public static var lockrating:Bool = false;
	public static var healthrot:Int = 32;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [
	[1, 1, 1], 
	[1, 1, 1], 
	[1, 1, 1], 
	[1, 1, 1],
	[1, 1, 1], 
	[1, 1, 1], 
	[1, 1, 1], 
	[1, 1, 1],
	[1, 1, 1],
	[1, 1, 1]
	];
	public static var noteOrder:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
	public static var noteOption:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var hideTime:Bool = false;
	public static var optimization:Bool = false;

	public static var defaultKeys:Array<FlxKey> = [
		A, LEFT,			//Note Left
		S, DOWN,			//Note Down
		W, UP,				//Note Up
		D, RIGHT,			//Note Right

		A, LEFT,			//UI Left
		S, DOWN,			//UI Down
		W, UP,				//UI Up
		D, RIGHT,			//UI Right

		NONE, NONE,			//Reset
		SPACE, ENTER,		//Accept
		BACKSPACE, ESCAPE,	//Back
		ENTER, ESCAPE,		//Pause

		S, NONE,
		D, NONE,
		F, NONE,
		SPACE, NONE,
		J, LEFT,
		K, DOWN,
		L, RIGHT,

		A, NONE,
		S, NONE,
		D, NONE,
		F, NONE,
		SPACE, NONE,
		H, NONE,
		J, NONE,
		K, NONE,
		L, NONE
	];
	//Every key has two binds, these binds are defined on defaultKeys! If you want your control to be changeable, you have to add it on ControlsSubState (inside OptionsState)'s list
	public static var keyBinds:Array<Dynamic> = [
		//Key Bind, Name for ControlsSubState
		[Control.NOTE_LEFT, 'Left'],
		[Control.NOTE_DOWN, 'Down'],
		[Control.NOTE_UP, 'Up'],
		[Control.NOTE_RIGHT, 'Right'],

		[Control.UI_LEFT, 'Left '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_DOWN, 'Down '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_UP, 'Up '],			//Added a space for not conflicting on ControlsSubState
		[Control.UI_RIGHT, 'Right '],	//Added a space for not conflicting on ControlsSubState

		[Control.RESET, 'Reset'],
		[Control.ACCEPT, 'Accept'],
		[Control.BACK, 'Back'],
		[Control.PAUSE, 'Pause'],

		[Control.A1, 'Left 1'],
		[Control.A2, 'Up  '],
		[Control.A3, 'Right 1'],
		[Control.A4, 'Center'],
		[Control.A5, 'Left 2'],
		[Control.A6, 'Down  '],
		[Control.A7, 'Right 2'],

		[Control.B1, 'Left 1 '],
		[Control.B2, 'Down 1'],
		[Control.B3, 'Up 1'],
		[Control.B4, 'Right 1 '],
		[Control.B5, 'Center '],
		[Control.B6, 'Left 2 '],
		[Control.B7, 'Down 2'],
		[Control.B8, 'Up 2'],
		[Control.B9, 'Right 2 ']
	];
	public static var lastControls:Array<FlxKey> = defaultKeys.copy();

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.noteSounds = noteSounds;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.doScoretable = doScoretable;
		FlxG.save.data.doArtistinfo = doArtistinfo;
		FlxG.save.data.dohealthrot = dohealthrot;
		FlxG.save.data.dobumpin = dobumpin;
		FlxG.save.data.windowMove = windowMove;
		FlxG.save.data.cameraMoveOnNotes = cameraMoveOnNotes;
		FlxG.save.data.antispam = antispam;
		FlxG.save.data.newInput = newInput;
		FlxG.save.data.overrideScroll = overrideScroll;
		FlxG.save.data.scrollspeed = scrollspeed;
		FlxG.save.data.classicBotplayText = classicBotplayText;
		FlxG.save.data.classicHUD = classicHUD;
		FlxG.save.data.sourceModcharts = sourceModcharts;
		FlxG.save.data.sourceEvents = sourceEvents;
		FlxG.save.data.useOgg = useOgg;
		FlxG.save.data.healthrot = healthrot;
		FlxG.save.data.maxmisslimit = maxmisslimit;
		FlxG.save.data.lockrating = lockrating;
		FlxG.save.data.cursing = cursing;
		FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.noteOrder = noteOrder;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.hideTime = hideTime;
		FlxG.save.data.optimization = optimization;

		/*
		var achieves:Array<String> = [];
		for (i in 0...Achievements.achievementsUnlocked.length) {
			if(Achievements.achievementsUnlocked[i][1]) {
				achieves.push(Achievements.achievementsUnlocked[i][0]);
			}
		}
		

		FlxG.save.data.achievementsUnlocked = achieves;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.flush();
		*/

		var save:FlxSave = new FlxSave();
		save.bind('controls', 'shaggymod'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = lastControls;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.noteSounds != null) {
			noteSounds = FlxG.save.data.noteSounds;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		if(FlxG.save.data.dohealthrot != null){
			dohealthrot = FlxG.save.data.dohealthrot;
		}
		if(FlxG.save.data.dobumpin != null){
			dobumpin = FlxG.save.data.dobumpin;
		}
		if(FlxG.save.data.windowMove != null){
			windowMove = FlxG.save.data.windowMove;
		}
		if(FlxG.save.data.cameraMoveOnNotes != null){
			cameraMoveOnNotes = FlxG.save.data.cameraMoveOnNotes;
		}
		if(FlxG.save.data.antispam != null){
			antispam = FlxG.save.data.antispam;
		}
		if(FlxG.save.data.overrideScroll != null){
			overrideScroll = FlxG.save.data.overrideScroll;
		}
		if(FlxG.save.data.newInput != null){
			newInput = FlxG.save.data.newInput;
		}
		if(FlxG.save.data.classicBotplayText != null){
			classicBotplayText = FlxG.save.data.classicBotplayText;
		}
		if(FlxG.save.data.classicHUD != null){
			classicHUD = FlxG.save.data.classicHUD;
		}
		if(FlxG.save.data.sourceModcharts != null){
			sourceModcharts = FlxG.save.data.sourceModcharts;
		}
		if(FlxG.save.data.sourceEvents != null){
			sourceEvents = FlxG.save.data.sourceEvents;
		}
		if(FlxG.save.data.useOgg != null){
			useOgg = FlxG.save.data.useOgg;
		}
		if(FlxG.save.data.maxmisslimit != null){
			maxmisslimit = FlxG.save.data.maxmisslimit;
		}
		if(FlxG.save.data.lockrating != null){
			lockrating = FlxG.save.data.lockrating;
		}
		if(FlxG.save.data.scrollspeed != null){
			scrollspeed = FlxG.save.data.scrollspeed;
		}
		if(FlxG.save.data.healthrot != null) {
			healthrot = FlxG.save.data.healthrot;
		}
		if(FlxG.save.data.doArtistinfo != null){
			doArtistinfo = FlxG.save.data.doArtistinfo;
		}
		if(FlxG.save.data.doScoretable != null) {
			doScoretable = FlxG.save.data.doScoretable;
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.imagesPersist != null) {
			imagesPersist = FlxG.save.data.imagesPersist;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.hideTime != null) {
			hideTime = FlxG.save.data.hideTime;
		}
		if(FlxG.save.data.optimization != null) {
			optimization = FlxG.save.data.optimization;
		}
		if (FlxG.save.data.noteOrder != null) {
			noteOrder = FlxG.save.data.noteOrder;
		}
		var save:FlxSave = new FlxSave();
		save.bind('controls', 'shaggymod');
		if(save != null && save.data.customControls != null) {
			reloadControls(save.data.customControls);
		}

		if (FlxG.save.data.language == null) FlxG.save.data.languaje = 0;

		FlxG.updateFramerate = framerate;
		FlxG.drawFramerate = framerate;

		FlxG.save.data.noteSkin = [0, 0, 0, 0];
		if (FlxG.save.data.s_FirstBoot == null)
		{
			trace('yasss');
			reloadControls(defaultKeys);
			FlxG.save.data.s_keyWarning = true;
			FlxG.save.data.s_FirstBoot = false;
			FlxG.save.flush();
			saveSettings();
		}
	}

	public static function reloadControls(newKeys:Array<FlxKey>) {
		ClientPrefs.removeControls(ClientPrefs.lastControls);
		ClientPrefs.lastControls = newKeys.copy();
		ClientPrefs.loadControls(ClientPrefs.lastControls);
	}

	private static function removeControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToRemove:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToRemove.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToRemove.length > 0) {
				PlayerSettings.player1.controls.unbindKeys(keyBinds[i][0], controlsToRemove);
			}
		}
	}
	private static function loadControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToAdd:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToAdd.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToAdd.length > 0) {
				PlayerSettings.player1.controls.bindKeys(keyBinds[i][0], controlsToAdd);
			}
		}
	}
}