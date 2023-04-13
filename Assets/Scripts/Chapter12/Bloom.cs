using UnityEngine;
using System.Collections;

public class Bloom : PostEffectsBase
{
    public Shader bloomShader;
    private Material bloomMaterial = null;

    public Material material
    {
        get
        {
            bloomMaterial = CheckShaderAndCreateMaterial(bloomShader, bloomMaterial);
            return bloomMaterial;
        }
    }

	// Blur iterations - larger number means more blur.
	[Range(0, 4)]
	public int iterations = 3;
	
	// Blur spread for each iteration - larger value means more blur
	[Range(0.2f, 3.0f)]
	public float blurSpread = 0.6f;
	
	[Range(1, 8)]
	public int downSample = 2; 

    [Range(0.0f, 4.0f)]
    public float luminanceThreshold = 0.6f;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_LuminanceThreshold", luminanceThreshold);
            // sample:
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;

            // 1.src->buffer0: store the lumin part
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;
            Graphics.Blit(src, buffer0, material, 0);

            for (int i = 0; i < iterations; ++i)
            {
			    material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                
                // 2.buffer0->buffer1: vertical
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;

                // 3.buffer0->buffer1: horizontal
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 2);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            // 4.buffer0->materialTexture: the blured lumintexture
            material.SetTexture("_Bloom", buffer0);
            // 5.src->dest: blend
            Graphics.Blit(src, dest, material, 3);
            RenderTexture.ReleaseTemporary(buffer0);
        } else
        {
            Graphics.Blit(src, dest);
        }
    }  
}