package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		switch(char){
			case 'bf-car':
				if(isOldIcon = !isOldIcon) changeIcon('bf-old');
				else changeIcon('realbf');
			default:
				if(isOldIcon = !isOldIcon) changeIcon('bf-kindaold');
				else changeIcon('bf');
		}
		
	}

	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			var winningIcon:Bool;

			//This is for determining if the icon has a winning icon
			//We'll floor the icon sizes so abnormally sized icons will not fail the algorithm and cause problems. 
			loadGraphic(file);
			switch(Math.floor(width) / Math.floor(height)){
				case 3:
					trace('Winning icon enabled for '+char);
					winningIcon = true;
				default:
					winningIcon = false;
			}
			//Actually load it now
			loadGraphic(file, true, 150, 150);
			animation.add(char, winningIcon ? [0, 1, 2] : [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	public function getCharacter():String {
		return char;
	}
}
