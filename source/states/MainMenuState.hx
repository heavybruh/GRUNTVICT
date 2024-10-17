package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import flixel.addons.display.FlxBackdrop;

class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxText>;

	var optionShit:Array<String> = [
		// 'story_mode',
		'play',
		'gallery',
		'credits',
		'options'
	];

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if (!FlxG.mouse.visible)
			FlxG.mouse.visible = true;

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('cats!!!!!!!/badarse'));
		bg.velocity.set(80, 80);
		bg.scrollFactor.set();
		bg.scale.set(0.9, 0.9);
		bg.alpha = 0.6;
		add(bg);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);
		for (i in 0...optionShit.length) {
			var menuItem:FlxText = new FlxText(0, (i * 100) + 200, 0, optionShit[i], 0);
			menuItem.setFormat(Paths.font("Wood Block CG Regular.otf"), 50, FlxColor.WHITE, CENTER);
			menuItem.scrollFactor.set();
			menuItem.alpha = 0.5;
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		};

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			for (text in menuItems.members) {
				var hovered_text:FlxText = cast(text, FlxText);
				if (hovered_text.overlapsPoint(FlxG.mouse.getWorldPosition())) {
					if (hovered_text.alpha != 1) {
						hovered_text.alpha = 1;
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if (FlxG.mouse.justPressed)
						go_to_state(hovered_text.text);
				} else {
					if (hovered_text.alpha != 0.5)
						hovered_text.alpha = 0.5;
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function go_to_state(state:String)
	{
		FlxG.mouse.visible = false;
		selectedSomethin = true;

		switch (state) {
			case 'play':
				MusicBeatState.switchState(new DifficultyState());
			case 'gallery':
				MusicBeatState.switchState(new GalleryState());
			case 'credits':
				MusicBeatState.switchState(new NewCreditsState());
			case 'options':
				MusicBeatState.switchState(new OptionsState());
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null)
				{
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
					PlayState.stageUI = 'normal';
				}
		}
	}
}
