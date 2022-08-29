package;

import flash.system.System;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;

class ChangePlayerSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<HealthIcon> = [];

    
	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['---[ Misc ]---','based on chart','---[ Playable ]---','sally', 'sally - old', 'sally - floombo', 'bf - derpmanzero', 'riolu bf', 'bf - old', 'bf - og fnf', '---[ Story ]---', 'vaporeon', 'jolteon', 'flareon', 'umbreon', 'glaceon', 'sylveon', 'sillyvon', 'potassium', 'sunshine', 'speedy', 'black', 'espeon', 'leafeon', 'eeeee based', 'polyeon', 'espurr'];
    var iconItems:Array<String> = ['','face','','bf','bf-kindaold','bf','realbf','riolubf3d','realbf','realbf','','vaporeon', 'jolteon', 'flareon', 'umbreon', 'glaceon', 'sylveon', 'sillyvon', 'potassium', 'sunshine', 'speedy', 'black', 'espeon', 'leafeon', 'eeeee', 'polyeon', 'espurr'];
	var curSelected:Int = 0;

	public static var transCamera:FlxCamera;

    public function new(x:Float, y:Float)
	{
		super();

		menuItems = menuItemsOG;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		
		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);

			if (iconItems[i] != ''){
            var icon:HealthIcon = new HealthIcon(iconItems[i]);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);}else iconArray.push(null);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    override function update(elapsed:Float)
        {
    
            super.update(elapsed);
    
            var upP = controls.UI_UP_P;
            var downP = controls.UI_DOWN_P;
            var accepted = controls.ACCEPT;

            for (i in 0...iconArray.length)
            {
				if (iconArray[i] != null){
                	iconArray[i].alpha = 0.6;
				}
            }

			if (iconArray[curSelected] != null){
            	iconArray[curSelected].alpha = 1;
    		}

            if (upP)
            {
                changeSelection(-1);
            }
            if (downP)
            {
                changeSelection(1);
            }
    
            if (accepted)
            {
    			var daSelected:String = menuItems[curSelected];
                switch (daSelected)
                {
					case "based on chart":
                        PlayState.freeplayChar = false;
                        FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
                        close();
                    case "sally":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "bf";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "sally - old":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "RIPEEVEELOL";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "sally - floombo":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "sallyFloombo";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "bf - derpmanzero":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "bf-car";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "riolu bf":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "riolubf3d";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "bf - old":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "oldbf-car";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "bf - og fnf":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "RIPBFLOL";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();

					case "vaporeon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "vaporeon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "jolteon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "jolteon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "flareon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "flareon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "umbreon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "umbreon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "glaceon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "glaceon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "sylveon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "sylveon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "sillyvon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "silyvon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "potassium":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "potassium";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "sunshine":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "sunshine";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "speedy":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "speedy";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "black":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "black";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                    case "espeon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "espeon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "leafeon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "leafeon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "eeeee based":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "eeeee";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "polyeon":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "polyeon";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
					case "espurr":
                        PlayState.freeplayChar = true;
                        PlayState.selectedBF = "espurr";
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
                        close();
                }
            }
        }

    override function destroy()
	{
		super.destroy();
	}

    function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

    function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}