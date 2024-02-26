shader_type canvas_item;

uniform float hFrames = 1.0; //Number of horizontal frames in the Texture
uniform int vFrames = 1; //Number of vertical frames in the Texture

group_uniforms Displacement;
uniform bool enableMovement = true;
uniform float displacementPixels = 1.0; // Number of pixels to displace

uniform float timeGap : hint_range(0.0, 1.0, 0.01) = 0.4; // Time in seconds that Left side movement will wait to move

uniform float speed = 1.25; // Movement speed
/*
SideRelationTime determines the time ratio spent in each step.
For example, with a value of 0.25, a quarter of the time is spent in the normal position,
and the remaining three-quarters in the shifted position.
*/
uniform float leftSideRelationTime : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float rightSideRelationTime : hint_range(0.0, 1.0, 0.01) = 0.3;

group_uniforms Color;
uniform vec3 color: source_color = vec3(1.0);
uniform float colorMix: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

float ShiftPixels(float uvX, float normalizedUvX, float shift) {
	if (normalizedUvX <= 0.5) {
		//left side
		uvX -= shift * step(mod((TIME + timeGap) * speed, 1.0), leftSideRelationTime);
	}
	else {
		//right side
		uvX -= shift * step(mod(TIME * speed, 1.0), rightSideRelationTime);
	}

	return uvX;
}

// We have to resize the sprite so it is not cut
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
	// relation between the previous size and the new one
	float relation = (1.0 + 2.0 * texturePixelSizeX * float(displacementPixels) * numberFrames.x);
	
	vec2 uv = originalUV;
	
	uv.x *= relation;
	
	// adapt new position to new uv
	//uv.x -= float(displacementPixels) * texturePixelSizeX;
	
	// displaces the pixels depending on the sprite column
	//uv.x -= float(displacementPixels) * frameX * numberFrames.x * texturePixelSizeX / 2.0;
	
	// optimized operation
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

	// discard pixels that are out of the sprite
	if (uv.x <= frameX * 1.0 / numberFrames.x || uv.x >= 1.0 / numberFrames.x * (frameX + 1.0)) {
		discard;
	}

	COLOR = texture(TEXTURE, uv);
	COLOR.rgb = mix(COLOR.rgb, color, colorMix);
	COLOR.a *= alpha;
}