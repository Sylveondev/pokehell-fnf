// Stolen from Yoshi Engine, frick yoy
package shaders;

import flixel.system.FlxAssets.FlxShader;

class ColorShader extends FlxFixedShader {
    @:glFragmentSource('
        
        #pragma header

        uniform float r;
        uniform float g;
        uniform float b;
        uniform float addR;
        uniform float addG;
        uniform float addB;
        uniform bool enabled;

        void main() {
            if (enabled) {
                
                vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

                var r = (color.r * r) + addR;
                if (r < 0.0) r = 0.0;
                if (r > 1.0) r = 1.0;
                
                var g = (color.g * g) + addG;
                if (g < 0.0) g = 0.0;
                if (g > 1.0) g = 1.0;
                
                var b = (color.b * b) + addB;
                if (b < 0.0) b = 0.0;
                if (b > 1.0) b = 1.0;

                gl_FragColor = vec4(r, g, b, color.a);
            } else {
                gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
            }
        }
    ')
    public function new(r:Int, g:Int, b:Int, addR:Int, addG:Int, addB:Int) {
        super();
        setColors(r, g, b, addR, addG, addB);
    }

    public function setColors(r:Int, g:Int, b:Int, addR:Int, addG:Int, addB:Int) {
        this.r.value = [r / 255];
        this.g.value = [g / 255];
        this.b.value = [b / 255];
        this.addR.value = [addR / 255];
        this.addG.value = [addG / 255];
        this.addB.value = [addB / 255];
    }
}