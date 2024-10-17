package states;

import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import openfl.utils.Assets as OpenFlAssets;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import flixel.util.FlxGradient;

import states.StoryMenuState;
import states.MainMenuState;

#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideoSprite;
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;

	override public function create():Void
	{
		Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		Highscore.load();

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
				FlxG.fullscreen = FlxG.save.data.fullscreen;

			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var video_sprite:FlxVideoSprite;
	function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		#if sys
		if(!FileSystem.exists(Paths.video(name)))
		#else
		if(!OpenFlAssets.exists(Paths.video(name)))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			return;
		}
	
		video_sprite = new FlxVideoSprite();
		video_sprite.scrollFactor.set(1, 1);
		video_sprite.play(Paths.video(name));
		add(video_sprite);
		video_sprite.bitmap.onEndReached.add(function()
		{
			skipIntro();
			if (video_sprite != null)
				video_sprite.destroy();
		});
		#else
		FlxG.log.warn('Platform not supported!');
		return;
		#end
	}

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('wrequiem'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.bpm = 120;
		persistentUpdate = true;

		var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height + 50, [0x0, FlxColor.RED]);
		gradient.antialiasing = ClientPrefs.data.antialiasing;
		gradient.alpha = 0.6;
		FlxTween.tween(gradient, {alpha: 0.4}, (Conductor.crochet / 125), {type: PINGPONG, ease: FlxEase.sineInOut});
		add(gradient);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/title_menu/logo'));
		logo.scale.set(0.3, 0.3);
		logo.screenCenter(XY);
		logo.y += 20;
		logo.antialiasing = ClientPrefs.data.antialiasing;
		add(logo);
		FlxTween.tween(logo, {y: logo.y - 20}, (Conductor.crochet / 125), {type: PINGPONG, ease: FlxEase.sineInOut});

		var enter_txt:FlxText = new FlxText(0, 630, FlxG.width, "PRESS ENTER TO BEGIN", 12);
		enter_txt.scrollFactor.set();
		enter_txt.setFormat("assets/fonts/impact.ttf", 60, FlxColor.RED, CENTER);
		enter_txt.screenCenter(X);
		add(enter_txt);

		credGroup = new FlxGroup();
		add(credGroup);

		startVideo('NGIntro');

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		if (initialized)
			skipIntro();
		else
			initialized = true;

		Paths.clearUnusedMemory();
	}

	var transitioning:Bool = false;
	override function update(elapsed:Float)
	{
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * (Conductor.crochet / 500)));

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				pressedEnter = true;
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (initialized && !transitioning && skippedIntro && pressedEnter)
		{
			FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			transitioning = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new MainMenuState());
				closedState = true;
			});
		}

		if (initialized && pressedEnter && !skippedIntro && video_sprite != null) {
			skipIntro();
			video_sprite.destroy();
		}

		super.update(elapsed);
	}
	
	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 4 == 0)
			FlxG.camera.zoom += 0.04;
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(credGroup);
			FlxG.camera.flash(FlxColor.WHITE, 4);
			skippedIntro = true;
		}
	}
}
