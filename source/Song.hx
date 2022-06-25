package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;
	var mania:Null<Int>;
	var player1:String;
	var player2:String;
	var player3:String;
	var stage:String;

	var arrowSkin:String;
	var splashSkin:String;
	var validScore:Bool;

	var forceMiddlescroll:Bool;
	var forceGhostingOff:Bool;
	var noBotplay:Bool;
	var noPractice:Bool;
	var timebarColor:Array<String>;
	var fontColor:String;
	var hideGF:Bool;
	var disableChartEditor:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var speed:Float = 1;
	public var stage:String;
	public var mania:Null<Int> = 3;
	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var player3:String = 'gf';

	public var forceMiddlescroll:Bool = false;
	public var forceGhostingOff:Bool = false;
	public var noBotplay:Bool = false;
	public var noPractice:Bool = false;
	public var timebarColor:Array<String> = ['0xFF915D0F', '0xFFFFA621'];
	public var fontColor:String = '0xFFF5AA42';
	public var hideGF:Bool = false;
	public var disableChartEditor:Bool = false;

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson(formattedFolder + '/' + formattedSong);
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
		}
		#end

		if(rawJson == null) {
			#if sys
			rawJson = File.getContent(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#else
			rawJson = Assets.getText(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#end
		}


		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}
		
		

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daBpm = songData.bpm; */

		var songJson:SwagSong = parseJSONshit(rawJson);
		trace('Mania: '+songJson.mania);
		if (songJson.mania < 0 || songJson.mania == null)
			{
				songJson.mania = 3;
				trace('New Mania: '+songJson.mania);
			}
		if (!Std.isOfType(songJson.timebarColor,Array))
			{
				songJson.timebarColor = ['0xFF915D0F', '0xFFFFA621'];
			}
		if (songJson.fontColor == "")
			{
				songJson.fontColor = '0xFFF5AA42';
			}
			trace('Final Mania: '+songJson.mania);

		if(jsonInput != 'events') StageData.loadDirectory(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
