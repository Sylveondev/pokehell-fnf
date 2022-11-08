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

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Dynamic> = [];

	var rotCamHudInd:Int = 0;

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menus/menu'+ FlxG.random.int(0, 5) +'Desat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		trace("finding mod shit");
		if (FileSystem.exists(Paths.mods())) {
			trace("mods folder");
			if (FileSystem.exists(Paths.modFolders("data/credits.txt"))){
				trace("credit file");
				var firstarray:Array<String> = CoolUtil.coolTextFile(Paths.modFolders("data/credits.txt"));
				trace("found credit shit");
				
				for(i in firstarray){
					var arr:Array<String> = i.split("::");
					trace(arr);
					creditsStuff.push(arr);
				}
			}
		}
		
		#end
		var pisspoop = [ //Name - Icon name - Description - Link - BG Color
		['Pokehell Devs'],
		['SylveonDev',		'sylveondev',		'Development lead.',					'https://www.youtube.com/channel/UC8wo8sY38N-wyZDtit2psjg',	'0xFFFF9EFD'],
		['Spongey',		'spongey',		'Composer and programming.',					'https://twitter.com/spongebob7989b',	'0xFFEDB96F'],
		#if DEVBUILD ['You!',		'ifunny',		'Thank you for being a beta tester for the mod!',					'https://discord.gg/efE9c9AkWy',	'0xFFEDB96F'], #end
		['Discord',		'discord',		'The pokehell discord.',					'https://discord.gg/efE9c9AkWy',	'0xFF5865F2'],
		[''],
		['Pokehell Contributors'],
		['Your name here..',		'ifunny',		'Anyone can contribute to the mod with their content. You can submit your content for the mod in our discord server. See you there!',					'https://discord.gg/efE9c9AkWy',	'0xFFEDB96F'],
		['Floombo',		'floombo',		'Composer for rematch week.',					'https://www.youtube.com/c/Floombo',	'0xFF505050'],
		['LeviXD',		'levi',		'Remastered bf and sally\'s icons.',					'https://github.com/LEVIXDDLMAO',	'0xFF000000'],
		['SlimSlam',		'mai',		'Created the eeveelution squad week.',					'https://www.youtube.com/channel/UCvEubu0Jnl4RXm_K8fBMsZA',	'0xFFFFDD33'],
		['DerpManZero',		'derpy',		'Remastered bf.',					'https://www.youtube.com/channel/UC4eVH3-p_QxvxtjcvB1gafQ',	'0xFFBBBBBB'],
		['Mewo',		'fuck',		'Improved SylveonDev\'s remastered sprites.',					'https://google.com',	'0xFFFFFFFF'],
		['Greek BS',		'bs',		'Charted most of the eeveelution squad weeks.',					'https://www.youtube.com/channel/UCbl9PNfiCm6A3jFdGU72umw',	'0xFFFFDD33'],
		['EV-0',		'evzero',		'Made the es comic.',					'https://www.deviantart.com/ev-zero',	'0xFFDD891A'],
		['Featuring'],
		['theautistic1',		'theautistic1',		'Appears in crossover.',					'https://www.youtube.com/channel/UCsaDDC8XJpRFH_98YnOnEkQ',	'0xFFE7A753'],
		['nickplaysgaming',		'nickplaysgaming',		'Appears in crossover.',					'https://www.deviantart.com/nickplaysgaming',	'0xFFC77305'],
		['FNF Renderite',		'renderite',		'Appears in crossover, as well as their dwp soundfonts.',					'https://www.youtube.com/channel/UC8tEOrvXcZNZvsEba8pzoHA',	'0xFF4FE24A'],
		['Pokemon Nature 3000',		'nature',		'Appears in crossover.',					'https://www.youtube.com/channel/UCKEhr6-fPDtpIpZ18svvI0g',	'0xFFA34D89'],
		['EV-0',		'evzero',		'Appears in crossover.',					'https://www.deviantart.com/ev-zero',	'0xFFDD891A'],
		['LeafyTheFoliage',		'leafy',		'Appears in Bling Blunkin. Made Vee Funkin.',					'https://www.youtube.com/channel/UCC7dyJYQeDUH6MxqJvw-05Q',	'0xFF73C781'],
		[''],
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',	'0xFFFFDD33'],
		['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',		'0xFFC30085'],
		[''],
		['Engine Contributors'],
		['shubs',				'shubs',			'New Input System Programmer',						'https://twitter.com/yoshubs',			'0xFF4494E6'],
		['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',						'https://twitter.com/polybiusproxy',	'0xFFE01F32'],
		['gedehari',			'gedehari',			'Chart Editor\'s Sound Waveform base',				'https://twitter.com/gedehari',			'0xFFFF9300'],
		['Keoiki',				'keoiki',			'Note Splash Animations',							'https://twitter.com/Keoiki_',			'0xFFFFFFFF'],
		['SandPlanet',			'sandplanet',		'Mascot\'s Owner\nMain Supporter of the Engine',		'https://twitter.com/SandPlanetNG',	'0xFFD10616'],
		['bubba',				'bubba',		'Guest Composer for "Hot Dilf"',	'https://www.youtube.com/channel/UCxQTnLmv0OAS63yzk9pVfaw',	'0xFF61536A'],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	'0xFFF73838'],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	'0xFFFFBB1B'],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			'0xFF53E52C'],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		'0xFF6475F3']
	];
		
		
				for(i in pisspoop){
					creditsStuff.push(i);
				}
			
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = Std.parseInt(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		rotCamHudInd ++;
		for (i in 0...iconArray.length) {
			iconArray[i].angle = Math.sin(rotCamHudInd / 100 * 1) * 15;
			/* Don't uncomment this or there'll be a lot of lag in the console.
				trace(iconArray[i].angle);
			*/
		}
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  Std.parseInt(creditsStuff[curSelected][4]);
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
