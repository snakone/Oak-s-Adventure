shader_type canvas_item;

render_mode light_only;

uniform int hFrames = 1;
uniform int vFrames = 1; 

group_uniforms Displacement;
uniform bool enableMovement = true;
uniform int displacementPixels = 1;

uniform float timeGap : hint_range(0.0, 1.0, 0.01) = 0.4;

uniform float speed = 1.25;
uniform float leftSideRelationTime : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float rightSideRelationTime : hint_range(0.0, 1.0, 0.01) = 0.3;

group_uniforms Color;
uniform vec3 color: source_color = vec3(1.0);
uniform float colorMix: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

float ShiftPixels(float uvX, float normalizedUvX, float shift) {
	if (normalizedUvX <= 0.5) {
		uvX -= shift * step(mod((TIME + timeGap) * speed, 1.0), leftSideRelationTime);
	}
	else {
		uvX -= shift * step(mod(TIME * speed, 1.0), rightSideRelationTime);
	}

	return uvX;
}

void vertex(){
	switch (VERTEX_ID){
		case 0:
			VERTEX.x -= float(displacementPixels);
			break;
		case 1:
			VERTEX.x -= float(displacementPixels);
			break;
		case 2:
			VERTEX.x += float(displacementPixels);
			break;
		case 3:
			VERTEX.x += float(displacementPixels);
			break;
	}
}

vec2 AdjustUvToNewSize(vec2 originalUV, float texturePixelSizeX, vec2 numberFrames, float frameX) {
	float relation = (1.0 + 2.0 * texturePixelSizeX * float(displacementPixels) * numberFrames.x);
	vec2 uv = originalUV;
	uv.x *= relation;
	uv.x -= float(displacementPixels) * texturePixelSizeX * (1.0 + frameX * numberFrames.x / 2.0);
	return uv;
}

void fragment() {
	vec2 numberFrames = vec2(float(hFrames), float(vFrames));
	vec2 normalizedUv = mod(UV * numberFrames, vec2(1.0));
	float frameX = floor(UV.x * numberFrames.x);

	vec2 uv = AdjustUvToNewSize(UV, TEXTURE_PIXEL_SIZE.x, numberFrames, frameX);

	if (enableMovement) {
		uv.x = ShiftPixels(uv.x, normalizedUv.x, TEXTURE_PIXEL_SIZE.x * float(displacementPixels));
	}

	if (uv.x <= frameX * 1.0 / numberFrames.x || uv.x >= 1.0 / numberFrames.x * (frameX + 1.0)) {
		discard;
	}

	COLOR = texture(TEXTURE, uv);
	COLOR.rgb = mix(COLOR.rgb, color, colorMix);
	COLOR.a *= alpha;
}