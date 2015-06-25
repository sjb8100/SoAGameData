// Uniforms
uniform mat4 unWVP;
uniform mat4 unW;

// Inputs
in vec4 vPosition_TextureType;
in vec4 vTex_Animation_BlendMode;
in vec4 vTextureAtlas_TextureIndex;
in vec4 vTexDims;
in vec3 vColor;
in vec3 vOverlayColor;
in int vFace;

// Outputs
out vec4 fTex;
flat out vec2 fOUV;
flat out vec2 fOverlayOUV;
out vec3 fColor;
out vec3 fOverlayColor;
flat out vec2 fTextureAtlas;
out vec3 fDist;
out vec3 fNormal;
flat out vec4 fTexDims;
flat out float fMultBlendFactor;
flat out float fAddBlendFactor;
flat out float fAlphaBlendFactor;

vec3 NORM_LOOKUP[6] = vec3[6](
	vec3(-1.0, 0.0, 0.0),
	vec3(1.0, 0.0, 0.0),
	vec3(0.0, -1.0, 0.0),
	vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, -1.0),
    vec3(0.0, 0.0, 1.0)
);

void main(){
    
    vec3 vertexPosition = vPosition_TextureType.xyz / 7.0;

    fDist = -vec3(unW * vec4(vertexPosition, 1));
    
	gl_Position =  unWVP * vec4(vertexPosition, 1.0);
	
    //base OUV
	fOUV[0] = mod((vTextureAtlas_TextureIndex[2]), 16.0)/16.0;
	fOUV[1] = ((floor((vTextureAtlas_TextureIndex[2])/16.0))/16.0);
    
    //overlay OUV
    fOverlayOUV[0] = mod((vTextureAtlas_TextureIndex[3]), 16.0)/16.0;
	fOverlayOUV[1] = ((floor((vTextureAtlas_TextureIndex[3])/16.0))/16.0);
    
	fTex = vTex_Animation_BlendMode.xyxy / vTexDims;
    
    fTexDims = vTexDims;
    
    fNormal = NORM_LOOKUP[vFace];
    
	fTextureAtlas = vTextureAtlas_TextureIndex.xy;
	
    //add 0.1 in case we lose precision
    int blendMode = int(vTex_Animation_BlendMode[3] + 0.1);
    fAlphaBlendFactor = float(blendMode & 0x3);
    fAddBlendFactor = float(((blendMode & 0xc) >> 2) - 1);
    fMultBlendFactor = float(blendMode >> 4);

	fColor = vColor;
    fOverlayColor = vOverlayColor;
}