package states;

import flixel.addons.display.FlxBackdrop;

class GalleryState extends MusicBeatState
{
	private var group_sprites:FlxTypedGroup<FlxSprite>;
	private var sprite_array:Array<String> = [
		// Anamnesis
		'anamnesis/IMG_04152',
		'anamnesis/1593_sin_titulo_20240223001910',
		'anamnesis/IMG_1631',
		'anamnesis/original concept',
		'anamnesis/spry bg',
		'anamnesis/yezler bg',
		'anamnesis/image-198',
		'anamnesis/IMG_0463',
		'anamnesis/image-124',
		// Tricky
		'tricky concept',
		// Gabe
		'gabe/gabe_concept',
		'gabe/demoman grunt',
	];

	private function process_image(image:FlxSprite, res:Float)
	{
		var scale_resolution:Array<Float> = [(res / image.width), (res / image.height)];
		var scale:Float = Math.max(scale_resolution[0], scale_resolution[1]);
		image.scale.set(scale, scale);
		return scale_resolution;
	}
	
	var sprite_x_pos_ughugh:Float = 100;
	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		if (!FlxG.mouse.visible) FlxG.mouse.visible = true;		
		for (i in 1...5) sprite_array.push('chaser/chaser_' + i); // Chaser

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('cats!!!!!!!/badarse'));
		bg.velocity.set(80, 80);
		bg.scrollFactor.set();
		bg.scale.set(0.9, 0.9);
		bg.alpha = 0.6;
		add(bg);
		
		group_sprites = new FlxTypedGroup<FlxSprite>();
		add(group_sprites);
		for (path in sprite_array) {
			var sprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/gallery_menu/' + path));
			process_image(sprite, 400);
			trace(process_image(sprite, 400));
			sprite.x = sprite_x_pos_ughugh;
			sprite_x_pos_ughugh += 900;
			sprite.antialiasing = ClientPrefs.data.antialiasing;
			sprite.updateHitbox();
			sprite.screenCenter(Y);
			group_sprites.add(sprite);
		};

		var uuugh:FlxText = new FlxText(0, 10, FlxG.width, "THIS MENU WAS A PAIN IN THE ASS TO CODE, SO IT LOOKS LIKE SHIT!!!!!", 0);
		uuugh.scrollFactor.set();
		uuugh.setFormat("assets/fonts/impact.ttf", 20, FlxColor.WHITE, CENTER);
		uuugh.screenCenter(X);
		add(uuugh);

		var scrollwheel:FlxText = new FlxText(0, FlxG.height - 50, FlxG.width, "USE YOUR MOUSE WHEEL TO SCROLL HORIZONTALLY!!!!!", 0);
		scrollwheel.scrollFactor.set();
		scrollwheel.setFormat("assets/fonts/impact.ttf", 25, FlxColor.WHITE, CENTER);
		scrollwheel.screenCenter(X);
		add(scrollwheel);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.visible) {
			if (FlxG.mouse.wheel != 0 && sprite_array.length > 1)
				for (i in 0 ... group_sprites.length)
					group_sprites.members[i].x = group_sprites.members[i].x + ((1 * FlxG.mouse.wheel) * 30);

			if (controls.BACK) {
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}
		
		super.update(elapsed);
	}
}
