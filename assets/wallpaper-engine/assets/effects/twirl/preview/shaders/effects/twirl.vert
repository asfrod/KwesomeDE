
uniform mat4 g_ModelViewProjectionMatrix;
uniform vec4 g_Texture1Resolution;

attribute vec3 a_Position;
attribute vec2 a_TexCoord;

varying vec2 v_TexCoord;

#if MASK == 1
varying vec2 v_TexCoordMask;
#endif

void main() {

	gl_Position = mul(vec4(a_Position, 1.0), g_ModelViewProjectionMatrix);
	
	v_TexCoord.xy = a_TexCoord.xy;
	
#if MASK == 1
	v_TexCoordMask = vec2(a_TexCoord.x * g_Texture1Resolution.z / g_Texture1Resolution.x,
						a_TexCoord.y * g_Texture1Resolution.w / g_Texture1Resolution.y);
#endif
}
