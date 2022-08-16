package options;

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
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class NoteColorSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private static var curSelectedLetter:Int = 0;
	private var grpLetters:FlxTypedGroup<FlxText>;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var grpAvailable:FlxTypedGroup<FlxText>;
	var state:String;
	var hsvText:Alphabet;
	var resetText:Alphabet;
	var SET_WIDTH:Float;
	var canSelectLetter:Bool = false;

	var posX = 250;
	public function new() {
		super();
		FlxTween.color(OptionsState.menuBG,1, OptionsState.menuBG.color, FlxColor.fromString("0xBA5DAF"));

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpLetters = new FlxTypedGroup<FlxText>();
		add(grpLetters);
		grpAvailable = new FlxTypedGroup<FlxText>();
		add(grpAvailable);

		for (i in 0...9) {
			var note:FlxSprite = new FlxSprite(posX - 70, 0);
			note.frames = Paths.getSparrowAtlas('NOTE_assets');
			for (j in 0...9) {
				note.animation.addByPrefix(ClientPrefs.noteOption[j], ClientPrefs.noteOption[j] + '0');
			}
			note.animation.play(ClientPrefs.noteOrder[i]);
			note.y += (75 * i);
			note.antialiasing = ClientPrefs.globalAntialiasing;
			SET_WIDTH = note.width;
			note.setGraphicSize(Std.int(SET_WIDTH * 0.5));
			note.ID = i;
			note.alpha = 0.5;
			grpNotes.add(note);

			var noteLetter:FlxText = new FlxText(posX + 175, 55 + (75 * i), 0, ClientPrefs.noteOrder[i], 32);
			noteLetter.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			noteLetter.ID = i;
			noteLetter.alpha = 0.5;
			grpLetters.add(noteLetter);

			var noteOption:FlxText = new FlxText(posX + 610, 55 + (75 * i), 0, ClientPrefs.noteOption[i], 32);
			noteOption.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			noteOption.ID = i;
			noteOption.alpha = 0.5;
			grpAvailable.add(noteOption);
		}
		hsvText = new Alphabet(0, -75, "Note letter         New letter", false, false, 0, 0.65);
		add(hsvText);
		hsvText.x += 355;

		resetText = new Alphabet(0, 600, 'Press "R" to reset', false, false, 0, 0.65);
		add(resetText);
		resetText.x += 500;

		state = 'toSelectNote';

		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				canSelectLetter = true;
			});

		changeNote();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);


		if (controls.UI_UP_P) {
			if (state == 'toSelectNote')
				changeNote(-1);
			else if (state == 'toSelectNewLetter')
				changeLetter(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_DOWN_P) {
			if (state == 'toSelectNote')
				changeNote(1);
			else if (state == 'toSelectNewLetter')
				changeLetter(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.ACCEPT) {
			if (state == 'toSelectNewLetter') {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				ClientPrefs.noteOrder[curSelected] = ClientPrefs.noteOption[curSelectedLetter];
				state = 'toSelectNote';
				canSelectLetter = false;
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						canSelectLetter = true;
					});
				changeNote();
			}
			if (canSelectLetter && state == 'toSelectNote') {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeLetter();
				state = 'toSelectNewLetter';
			}
		}
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (state == 'toSelectNewLetter') {
				state = 'toSelectNote';
				changeNote();
			} else if (state == 'toSelectNote') {
				trace('exiting menu');
				close();
				FlxTween.color(OptionsState.menuBG,1, OptionsState.menuBG.color, FlxColor.fromString("0x74c2c1"));
			}
		}

		grpNotes.forEach(function(spr:FlxSprite) {
			for (i in 0...9) {
				if (spr.ID == i)
					spr.animation.play(ClientPrefs.noteOrder[i]);
			}
		});

		grpLetters.forEach(function(txt:FlxText) {
			for (i in 0...9) {
				if (txt.ID == i)
					txt.text = ClientPrefs.noteOrder[i];
			}
		});

		if (FlxG.keys.justPressed.R) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (i in 0...9)
				ClientPrefs.noteOrder[i] = ClientPrefs.noteOption[i];
		}
	}

	function changeNote(change:Int = 0) {
		curSelected += change;

		if (curSelected > 8)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 8;

		grpNotes.forEach(function(spr:FlxSprite) {
			if (spr.ID == curSelected) {
				spr.alpha = 1;
				FlxTween.tween(spr, {x: (posX - 70) + 50}, 0.2, {ease: FlxEase.quadOut});
			}
			else {
				spr.alpha = 0.5;
				FlxTween.tween(spr, {x: (posX - 70)}, 0.2, {ease: FlxEase.quadOut});
			}
		});

		grpLetters.forEach(function(txt:FlxText) {
			if (txt.ID == curSelected)
				txt.alpha = 1;
			else
				txt.alpha = 0.5;
		});

		grpAvailable.forEach(function(txt:FlxText) {
			txt.alpha = 0.5;
		});
	}

	function changeLetter(change:Int = 0) {
		curSelectedLetter += change;

		if (curSelectedLetter > 8)
			curSelectedLetter = 0;
		if (curSelectedLetter < 0)
			curSelectedLetter = 8;

		grpNotes.forEach(function(spr:FlxSprite) {
			if (spr.ID != curSelected) {
				spr.alpha = 0;
			}
		});

		grpLetters.forEach(function(txt:FlxText) {
			if (txt.ID == curSelected)
				txt.alpha = 0.5;
			else
				txt.alpha = 0;
		});

		grpAvailable.forEach(function(txt:FlxText) {
			if (txt.ID == curSelectedLetter)
				txt.alpha = 1;
			else
				txt.alpha = 0.5;
		});
	}
}