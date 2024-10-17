package states.stages;

class Anamnesis extends BaseStage
{
	override function create()
	{
		var bg:BGSprite = new BGSprite('IMG_1183', 0, 0, 1, 1);
		bg.scale.set(0.75, 0.75);
		bg.screenCenter(XY);
		add(bg);
	}
}