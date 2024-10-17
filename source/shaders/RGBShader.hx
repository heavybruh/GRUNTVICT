package shaders;

import flixel.system.FlxAssets.FlxShader;

class RGBShader extends FlxShader
{
    @:glFragmentSource('
    //#version 130
    #pragma header

    uniform float amount = 0.0;
    
    void main(void)
    {
        vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(amount / 1000.0, 0.0));
        vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(0.0, 0.0));
        vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(amount / 1000.0, 0.0));
        vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
        toUse.r = col1.r;
        toUse.g = col2.g;
        toUse.b = col3.b;
    
        gl_FragColor = toUse;
    }')

	public function new():Void
	{
		// :3
        super();
	}
}