package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;


class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = LoadingState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;
	public static var engVar:EngVer;
	public static var drums:Bool = false;
	public static var menuBad:Bool = false;
	public static var menuMusPlay:Bool = false;
	public static var skipDes:Bool = false;
	public static var ammo:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9];
	public static var gfxIndex:Array<Dynamic> = [
		[4],
		[0, 3],
		[0, 4, 3],
		[0, 1, 2, 3],
		[0, 1, 4, 2, 3],
		[0, 2, 3, 5, 1, 8],
		[0, 2, 3, 4, 5, 1, 8],
		[0, 1, 2, 3, 5, 6, 7, 8],
		[0, 1, 2, 3, 4, 5, 6, 7, 8]
	];
	public static var gfxHud:Array<Dynamic> = [
		[4],
		[0, 3],
		[0, 4, 3],
		[0, 1, 2, 3],
		[0, 1, 4, 2, 3],
		[0, 2, 3, 0, 1, 3],
		[0, 2, 3, 4, 0, 1, 3],
		[0, 1, 2, 3, 0, 1, 2, 3],
		[0, 1, 2, 3, 4, 0, 1, 2, 3]
	];
	public static var gfxAlterInd:Array<Dynamic> = [
		[2, 3, 3, 2],
		[0, 1, 2, 2, 1, 0],
		[0, 1, 2, 3, 2, 1, 0],
		[0, 1, 2, 1, 3, 1, 2, 1, 0]
	];
	public static var letterMax:Array<Int> = [9, 4];
	public static var skinName:Array<String> = ['assets', 'alter'];
	public static var gfxDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE'];
	public static var charDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP'];
	public static var gfxLetter:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if desktop Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash); #end


		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}
	
	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = LoadingState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		engVar = new EngVer(1170, 3, 0xFFFFFF);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		addChild(fpsVar);
		addChild(engVar);

		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}

	#if desktop
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var errDiag:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		path = "crash/" + "SE_" + dateNow + ".txt";

		errMsg += "\nA fatal error occured: \"" + e.error + "\"\nSally Engine has crashed due to some uncaught error. Bring this to SylveonDev's attention.\n\n";

		errMsg += "--- Begin crash dump ---\n";
		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}
		errMsg += "--- End crash dump ---";

		if (!FileSystem.exists("crash/"))
			FileSystem.createDirectory("crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Seriously?!");

		Sys.exit(1);
	}
	#end
}