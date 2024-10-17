package states;

import flixel.addons.display.FlxBackdrop;
import backend.Song;

class DifficultyState extends MusicBeatState
{
	var grp_difficulty:FlxTypedGroup<FlxText>;
	var grp_diff_sprites:FlxTypedGroup<FlxSprite>;
	var difficulty_stuff:Array<Array<String>> = [
		['easy',		'Would be called wasteful'],
		['normal',		'Soldier'],
		['hard',		'War machine'],
		['veteran',		'True protagonist'],
		['impossible',	'Unhinged bone crusher'],
	];

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		FlxG.mouse.visible = true;

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('cats!!!!!!!/badarse'));
		bg.velocity.set(80, 80);
		bg.scale.set(0.9, 0.9);
		bg.alpha = 0.6;
		add(bg);
		
		grp_difficulty = new FlxTypedGroup<FlxText>();
		add(grp_difficulty);
		for (i in 0...difficulty_stuff.length) {
			var diff_text:FlxText = new FlxText(100, (i * 100) + 100, 0, difficulty_stuff[i][1], 0);
			diff_text.setFormat(Paths.font("Wood Block CG Regular.otf"), 50, FlxColor.WHITE, LEFT);
			diff_text.alpha = 0.5;
			diff_text.ID = i;
			diff_text.updateHitbox();
			grp_difficulty.add(diff_text);
		};

		grp_diff_sprites = new FlxTypedGroup<FlxSprite>();
		add(grp_diff_sprites);
		for (i in 0...(difficulty_stuff.length - 1)) {
			var icon_sprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/difficulty_menu/' + difficulty_stuff[i][0]));
			icon_sprite.scale.set(0.2, 0.2);
			icon_sprite.screenCenter(XY);
			icon_sprite.x += 300;
			icon_sprite.antialiasing = ClientPrefs.data.antialiasing;
			icon_sprite.ID = i;
			icon_sprite.visible = false;
			grp_diff_sprites.add(icon_sprite);
		};

		var scrollwheel:FlxText = new FlxText(0, 10, FlxG.width, "EASY AND NORMAL DIFFCULTY DO NOT WORK!!!!!", 0);
		scrollwheel.scrollFactor.set();
		scrollwheel.setFormat("assets/fonts/impact.ttf", 25, FlxColor.WHITE, CENTER);
		scrollwheel.screenCenter(X);
		add(scrollwheel);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if(FlxG.mouse.visible)
		{
			for (text in grp_difficulty.members) {
				var hovered_text:FlxText = cast(text, FlxText);
				if (hovered_text.overlapsPoint(FlxG.mouse.getWorldPosition())) {
					if (hovered_text.alpha != 1) {
						hovered_text.alpha = 1;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						trace(difficulty_stuff[hovered_text.ID][0]);
						if (difficulty_stuff[hovered_text.ID][0] != "impossible")
							grp_diff_sprites.members[hovered_text.ID].visible = true;
					}
					if (FlxG.mouse.justPressed) {
						FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
						FlxG.mouse.visible = false;
						
						PlayState.isStoryMode = true;
						PlayState.storyWeek = 0;
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;

						var diffic = difficulty_stuff[hovered_text.ID][0];
						if (diffic != null || diffic != 'normal') 
							diffic = '-${difficulty_stuff[hovered_text.ID][0]}';
						else
							diffic = '';

						PlayState.storyDifficulty = hovered_text.ID;
						PlayState.SONG = Song.loadFromJson('anamnesis$diffic', 'anamnesis');

						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
							});
					}
				} else {
					if (hovered_text.alpha != 0.5) hovered_text.alpha = 0.5;
					if (difficulty_stuff[hovered_text.ID][0] != "impossible") grp_diff_sprites.members[hovered_text.ID].visible = false;
				}
			}

			if (controls.BACK) {
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}
		
		super.update(elapsed);
	}
}
