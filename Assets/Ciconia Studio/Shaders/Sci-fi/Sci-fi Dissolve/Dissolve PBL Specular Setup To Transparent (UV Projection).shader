Shader "Ciconia Studio/Effects/Sci-Fi/Dissolve/Specular Setup/Dissolve To Transparent (UV Projection)" {
    Properties {
        [Space(15)][Header(Main Maps)]
        [Space(10)]_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _DesaturateAlbedo ("Desaturate", Range(0, 1)) = 0
        [Space(25)]_SpecColor ("Specular Color", Color) = (1,1,1,1)
        _SpecGlossMap ("Specular map(Gloss A)", 2D) = "white" {}
        _SpecularIntensity ("Specular Intensity", Range(0, 2)) = 0.2
        _FresnelStrength ("Fresnel Strength", Range(0, 8)) = 0
        _Glossiness ("Glossiness", Range(0, 2)) = 1
        _Ambientlight ("Ambient light", Range(0, 8)) = 0
        [Space(25)]_BumpMap ("Normal map", 2D) = "bump" {}
        _NormalIntensity ("Normal Intensity", Range(0, 2)) = 1
        [Space(25)]_OcclusionMap ("Ambient Occlusion map", 2D) = "white" {}
        _AoIntensity ("Ao Intensity", Range(0, 2)) = 1
        [Space(25)]_EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _EmissionMap ("Emission map", 2D) = "white" {}
        _EmissiveIntensity ("Emissive Intensity", Range(0, 2)) = 1

        [Space(15)][Header(Dissolve Properties)]
        [Space(10)][MaterialToggle] _Invertmask ("Invert mask", Float ) = 0
        _DetailMask ("Dissolve Mask (UV Projection)", 2D) = "white" {}
        [Space(10)]_MaskAmount ("Mask Amount", Float ) = 1
        _Contrast ("Contrast", Float ) = 1
        [Space(15)]_EdgeColor ("Edge Color", Color) = (1,0.1882353,0,1)
        _EdgeIntensity ("Edge Intensity", Range(0, 1)) = 0.15
        [Space(25)]_Distortionmap ("Distortion map", 2D) = "white" {}
        [Space(10)]_DistortionAmount ("Distortion Amount", Range(0, 4)) = 0.5
        _Multiplicator ("Multiplicator", Float ) = 1
        _Speed ("Speed", Range(0, 1)) = 0.1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _SpecGlossMap; uniform float4 _SpecGlossMap_ST;
            uniform float _SpecularIntensity;
            uniform float _Glossiness;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _NormalIntensity;
            uniform float _Ambientlight;
            uniform sampler2D _OcclusionMap; uniform float4 _OcclusionMap_ST;
            uniform float _FresnelStrength;
            uniform float _AoIntensity;
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float4 _EmissionColor;
            uniform float _EmissiveIntensity;
            uniform float _DesaturateAlbedo;
            uniform float _Contrast;
            uniform float _MaskAmount;
            uniform fixed _Invertmask;
            uniform sampler2D _DetailMask; uniform float4 _DetailMask_ST;
            uniform float4 _EdgeColor;
            uniform float _DistortionAmount;
            uniform sampler2D _Distortionmap; uniform float4 _Distortionmap_ST;
            uniform float _EdgeIntensity;
            uniform float _Multiplicator;
            uniform float _Speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD10;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 Normalmap = lerp(float3(0,0,1),_BumpMap_var.rgb,_NormalIntensity);
                float3 normalLocal = Normalmap;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _DetailMask_var = tex2D(_DetailMask,TRANSFORM_TEX(i.uv0, _DetailMask)); // X Axis FrontBack
                float node_3462 = 0.0;
                float node_6202 = (1.0+(-1*_Contrast));
                float3 node_8230 = saturate(((_MaskAmount*2.0+-1.0)+(node_6202 + ( (lerp( _DetailMask_var.rgb, (1.0 - _DetailMask_var.rgb), _Invertmask ) - node_3462) * (_Contrast - node_6202) ) / (1.0 - node_3462))));
                float3 Mask = node_8230;
                float AlphaClip = Mask.r;
                clip(AlphaClip - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _SpecGlossMap_var = tex2D(_SpecGlossMap,TRANSFORM_TEX(i.uv0, _SpecGlossMap));
                float Glossiness = (_SpecGlossMap_var.a*_Glossiness);
                float gloss = Glossiness;
                float perceptualRoughness = 1.0 - Glossiness;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float Fresnel = (((0.95*pow(1.0-max(0,dot(normalDirection, viewDirection)),1.0))+0.05)*_FresnelStrength);
                float node_9733 = Fresnel;
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 Specularmap = (_SpecColor.rgb*_SpecGlossMap_var.rgb*_SpecularIntensity);
                float3 specularColor = Specularmap;
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 Diffusemap = (_Color.rgb*lerp(_MainTex_var.rgb,dot(_MainTex_var.rgb,float3(0.3,0.59,0.11)),_DesaturateAlbedo));
                float3 diffuseColor = Diffusemap; // Need this for specular when using metallic
                diffuseColor = EnergyConservationBetweenDiffuseAndSpecular(diffuseColor, specularColor, specularMonochrome);
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular + float3(node_9733,node_9733,node_9733));
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                float Ambientlight = _Ambientlight;
                float node_6535 = Ambientlight;
                indirectDiffuse += float3(node_6535,node_6535,node_6535); // Diffuse Ambient Light
                indirectDiffuse += gi.indirect.diffuse;
                float4 _OcclusionMap_var = tex2D(_OcclusionMap,TRANSFORM_TEX(i.uv0, _OcclusionMap));
                float Aomap = saturate((1.0-(1.0-_OcclusionMap_var.r)*(1.0-lerp(1,0,_AoIntensity))));
                indirectDiffuse *= Aomap; // Diffuse AO
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 node_1497 = _Time;
                float2 node_172 = (i.uv0+(node_1497.g*_Speed)*float2(0,0.1));
                float4 _Burnefect = tex2D(_Distortionmap,TRANSFORM_TEX(node_172, _Distortionmap));
                float2 node_9476 = lerp(i.uv0,float2(_Burnefect.r,_Burnefect.r),(lerp(0,0.1,_DistortionAmount)*_Multiplicator));
                float4 _node_5086 = tex2D(_Distortionmap,TRANSFORM_TEX(node_9476, _Distortionmap));
                float node_3629 = lerp(0.6,1,_EdgeIntensity);
                float node_6164 = 0.0;
                float node_306 = lerp(-10,0,node_3629); // Rang min
                float3 EmissiveColor = saturate((saturate((saturate(( (1.0 - saturate(node_8230)) > 0.5 ? (1.0-(1.0-2.0*((1.0 - saturate(node_8230))-0.5))*(1.0-_EdgeColor.rgb)) : (2.0*(1.0 - saturate(node_8230))*_EdgeColor.rgb) ))/(1.0-_node_5086.rgb)))*(node_306 + ( (pow((1.0 - Mask),lerp(2,0.1,node_3629)) - node_6164) * (lerp(-7,10,node_3629) - node_306) ) / (1.0 - node_6164))));
                float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
                float3 Emissivemap = saturate((EmissiveColor+((_EmissionColor.rgb*_EmissionMap_var.rgb)*_EmissiveIntensity)));
                float3 emissive = Emissivemap;
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _SpecGlossMap; uniform float4 _SpecGlossMap_ST;
            uniform float _SpecularIntensity;
            uniform float _Glossiness;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _NormalIntensity;
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float4 _EmissionColor;
            uniform float _EmissiveIntensity;
            uniform float _DesaturateAlbedo;
            uniform float _Contrast;
            uniform float _MaskAmount;
            uniform fixed _Invertmask;
            uniform sampler2D _DetailMask; uniform float4 _DetailMask_ST;
            uniform float4 _EdgeColor;
            uniform float _DistortionAmount;
            uniform sampler2D _Distortionmap; uniform float4 _Distortionmap_ST;
            uniform float _EdgeIntensity;
            uniform float _Multiplicator;
            uniform float _Speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 Normalmap = lerp(float3(0,0,1),_BumpMap_var.rgb,_NormalIntensity);
                float3 normalLocal = Normalmap;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float4 _DetailMask_var = tex2D(_DetailMask,TRANSFORM_TEX(i.uv0, _DetailMask)); // X Axis FrontBack
                float node_3462 = 0.0;
                float node_6202 = (1.0+(-1*_Contrast));
                float3 node_8230 = saturate(((_MaskAmount*2.0+-1.0)+(node_6202 + ( (lerp( _DetailMask_var.rgb, (1.0 - _DetailMask_var.rgb), _Invertmask ) - node_3462) * (_Contrast - node_6202) ) / (1.0 - node_3462))));
                float3 Mask = node_8230;
                float AlphaClip = Mask.r;
                clip(AlphaClip - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _SpecGlossMap_var = tex2D(_SpecGlossMap,TRANSFORM_TEX(i.uv0, _SpecGlossMap));
                float Glossiness = (_SpecGlossMap_var.a*_Glossiness);
                float gloss = Glossiness;
                float perceptualRoughness = 1.0 - Glossiness;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 Specularmap = (_SpecColor.rgb*_SpecGlossMap_var.rgb*_SpecularIntensity);
                float3 specularColor = Specularmap;
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 Diffusemap = (_Color.rgb*lerp(_MainTex_var.rgb,dot(_MainTex_var.rgb,float3(0.3,0.59,0.11)),_DesaturateAlbedo));
                float3 diffuseColor = Diffusemap; // Need this for specular when using metallic
                diffuseColor = EnergyConservationBetweenDiffuseAndSpecular(diffuseColor, specularColor, specularMonochrome);
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float _Contrast;
            uniform float _MaskAmount;
            uniform fixed _Invertmask;
            uniform sampler2D _DetailMask; uniform float4 _DetailMask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float4 posWorld : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _DetailMask_var = tex2D(_DetailMask,TRANSFORM_TEX(i.uv0, _DetailMask)); // X Axis FrontBack
                float node_3462 = 0.0;
                float node_6202 = (1.0+(-1*_Contrast));
                float3 node_8230 = saturate(((_MaskAmount*2.0+-1.0)+(node_6202 + ( (lerp( _DetailMask_var.rgb, (1.0 - _DetailMask_var.rgb), _Invertmask ) - node_3462) * (_Contrast - node_6202) ) / (1.0 - node_3462))));
                float3 Mask = node_8230;
                float AlphaClip = Mask.r;
                clip(AlphaClip - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _SpecGlossMap; uniform float4 _SpecGlossMap_ST;
            uniform float _SpecularIntensity;
            uniform float _Glossiness;
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float4 _EmissionColor;
            uniform float _EmissiveIntensity;
            uniform float _DesaturateAlbedo;
            uniform float _Contrast;
            uniform float _MaskAmount;
            uniform fixed _Invertmask;
            uniform sampler2D _DetailMask; uniform float4 _DetailMask_ST;
            uniform float4 _EdgeColor;
            uniform float _DistortionAmount;
            uniform sampler2D _Distortionmap; uniform float4 _Distortionmap_ST;
            uniform float _EdgeIntensity;
            uniform float _Multiplicator;
            uniform float _Speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : SV_Target {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                float4 node_1497 = _Time;
                float2 node_172 = (i.uv0+(node_1497.g*_Speed)*float2(0,0.1));
                float4 _Burnefect = tex2D(_Distortionmap,TRANSFORM_TEX(node_172, _Distortionmap));
                float2 node_9476 = lerp(i.uv0,float2(_Burnefect.r,_Burnefect.r),(lerp(0,0.1,_DistortionAmount)*_Multiplicator));
                float4 _node_5086 = tex2D(_Distortionmap,TRANSFORM_TEX(node_9476, _Distortionmap));
                float4 _DetailMask_var = tex2D(_DetailMask,TRANSFORM_TEX(i.uv0, _DetailMask)); // X Axis FrontBack
                float node_3462 = 0.0;
                float node_6202 = (1.0+(-1*_Contrast));
                float3 node_8230 = saturate(((_MaskAmount*2.0+-1.0)+(node_6202 + ( (lerp( _DetailMask_var.rgb, (1.0 - _DetailMask_var.rgb), _Invertmask ) - node_3462) * (_Contrast - node_6202) ) / (1.0 - node_3462))));
                float3 Mask = node_8230;
                float node_3629 = lerp(0.6,1,_EdgeIntensity);
                float node_6164 = 0.0;
                float node_306 = lerp(-10,0,node_3629); // Rang min
                float3 EmissiveColor = saturate((saturate((saturate(( (1.0 - saturate(node_8230)) > 0.5 ? (1.0-(1.0-2.0*((1.0 - saturate(node_8230))-0.5))*(1.0-_EdgeColor.rgb)) : (2.0*(1.0 - saturate(node_8230))*_EdgeColor.rgb) ))/(1.0-_node_5086.rgb)))*(node_306 + ( (pow((1.0 - Mask),lerp(2,0.1,node_3629)) - node_6164) * (lerp(-7,10,node_3629) - node_306) ) / (1.0 - node_6164))));
                float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
                float3 Emissivemap = saturate((EmissiveColor+((_EmissionColor.rgb*_EmissionMap_var.rgb)*_EmissiveIntensity)));
                o.Emission = Emissivemap;
                
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 Diffusemap = (_Color.rgb*lerp(_MainTex_var.rgb,dot(_MainTex_var.rgb,float3(0.3,0.59,0.11)),_DesaturateAlbedo));
                float3 diffColor = Diffusemap;
                float4 _SpecGlossMap_var = tex2D(_SpecGlossMap,TRANSFORM_TEX(i.uv0, _SpecGlossMap));
                float3 Specularmap = (_SpecColor.rgb*_SpecGlossMap_var.rgb*_SpecularIntensity);
                float3 specColor = Specularmap;
                float specularMonochrome = max(max(specColor.r, specColor.g),specColor.b);
                diffColor *= (1.0-specularMonochrome);
                float Glossiness = (_SpecGlossMap_var.a*_Glossiness);
                float roughness = 1.0 - Glossiness;
                o.Albedo = diffColor + specColor * roughness * roughness * 0.5;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
