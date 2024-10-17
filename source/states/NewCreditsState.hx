package states;

import objects.AttachedSprite;
import flixel.addons.display.FlxBackdrop;

class NewCreditsState extends MusicBeatState
{
	private var grpOptions:FlxTypedGroup<FlxText>;
	private var creditsStuff:Array<Array<String>> = [
		['Graphic',		'Lead Director and Artist',					 'https://x.com/graphicthereal'],
		['Blackhammer',		'Orignal Director and Artist (Formerly)',					 'https://x.com/BlackHammer_0'],
		['Spry',		'Lead Artist',					 'https://x.com/sprycomm'],
		['Heavy Bruh',		'Lead Programmer, Charter, and SFX Designer',					 'https://x.com/HeaviestBruh'],
		['L3AFY',		'Moral support I think?',					 ''],
		['DJ 3XIT',		'Charter',					 'https://x.com/spr1n6tr4p26845'],
		['Cursive',		'Charter',					 'https://www.youtube.com/channel/UCs9NTm6TkVcuN0xPaCDgqyg'],
		['Wellwoven',		'Lead Animator',					 'https://x.com/selloutstreame1'],
		['Bruhdreams',		'Artist and Animator',					 'https://x.com/BruhDream1'],
		['Myening',		'Artist (Formerly)',					 'https://twitter.com/Myening34'],
		['Grim Dang',		'Artist',					 'https://twitter.com/GRIMDANG'],
		['Alex G',		'Artist',					 'https://x.com/starman7261'],
		['Yezler',		'Artist (Formerly)',					 'https://twitter.com/yezler1'],
		['Kitsu99',		'Artist',					 ''],
		['Mr Whippa78',		'Artist',					 'https://x.com/Mrwhippa78'],
		['MID',		'Artist',					 'https://twitter.com/MIDGUYY_'],
		['IKAT',		'Artist',					 'https://twitter.com/IKAT1724'],
		['FreezyGaming',		'Artist',					 'https://twitter.com/FFreeze76'],
		['Noichi',		'Musician',					 'https://twitter.com/Noichi_yt'],
		['26B',		'Musician',					 'https://twitter.com/A_Dude_76'],
		['Aerozity',		'Musician',					 'https://twitter.com/IamAerozity'],
		['SombruhL',		'Musician',					 'https://twitter.com/SombruhL'],
	];

	var descText:FlxText;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;

		if (!FlxG.mouse.visible)
			FlxG.mouse.visible = true;

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('cats!!!!!!!/badarse'));
		bg.velocity.set(80, 80);
		bg.scrollFactor.set();
		bg.scale.set(0.9, 0.9);
		bg.alpha = 0.6;
		add(bg);

		var text_bg:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width / 2) - 200, Std.int(FlxG.height * 2), FlxColor.BLACK);
		text_bg.scrollFactor.set();
		text_bg.screenCenter(XY);
		text_bg.alpha = 0.5;
		add(text_bg);
		
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...creditsStuff.length) {
			var optionText:FlxText = new FlxText(0, (i * 100) + 100, 0, creditsStuff[i][0], 0);
			optionText.setFormat(Paths.font("Wood Block CG Regular.otf"), 50, FlxColor.WHITE, CENTER);
			optionText.scrollFactor.set();
			optionText.ID = i;
			optionText.screenCenter(X);
			optionText.updateHitbox();
			grpOptions.add(optionText);
		};

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 0, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		var scrollwheel:FlxText = new FlxText(0, 10, FlxG.width, "USE YOUR MOUSE WHEEL TO SCROLL VERTICALLY!!!!!", 0);
		scrollwheel.scrollFactor.set();
		scrollwheel.setFormat("assets/fonts/impact.ttf", 20, FlxColor.WHITE, CENTER);
		scrollwheel.screenCenter(X);
		add(scrollwheel);

		super.create();
	}

	var quitting:Bool = false;
	override function update(elapsed:Float)
	{
		if(!quitting)
		{
			for (text in grpOptions.members) {
				var hovered_text:FlxText = cast(text, FlxText);
				if (hovered_text.overlapsPoint(FlxG.mouse.getWorldPosition())) {
					if (hovered_text.color != FlxColor.RED) {
						hovered_text.color = FlxColor.RED;
						FlxG.sound.play(Paths.sound('scrollMenu'));

						descText.text = creditsStuff[hovered_text.ID][1];
						descText.x = (FlxG.width / 2) - (descText.width / 2);
						descBox.setGraphicSize(Std.int(descText.width + 35), Std.int(descText.height + 25));
						descBox.updateHitbox();
					}
					if (FlxG.mouse.justPressed)
						CoolUtil.browserLoad(creditsStuff[hovered_text.ID][2]);
				} else
					if (hovered_text.color != FlxColor.WHITE)
						hovered_text.color = FlxColor.WHITE;
			}

			if (FlxG.mouse.wheel != 0 && creditsStuff.length > 1)
				for (i in 0 ... grpOptions.length)
					grpOptions.members[i].y = grpOptions.members[i].y + ((1 * FlxG.mouse.wheel) * 30);

			if (controls.BACK) {
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		super.update(elapsed);
	}
}
