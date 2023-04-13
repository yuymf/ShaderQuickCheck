using UnityEngine;
using System.Collections;

public class EdgeDetect : PostEffectsBase
{
    public Shader edgeDectectShader;
    private Material edgeDectectMaterial;

    public Material material
    {
        get
        {
            edgeDectectMaterial = CheckShaderAndCreateMaterial(edgeDectectShader, edgeDectectMaterial);
            return edgeDectectMaterial;
        }
    }

	[Range(0.0f, 1.0f)]
	public float edgesOnly = 0.0f;

	public Color edgeColor = Color.black;
	
	public Color backgroundColor = Color.white; 

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
			material.SetFloat("_EdgeOnly", edgesOnly);
			material.SetColor("_EdgeColor", edgeColor);
			material.SetColor("_BackgroundColor", backgroundColor);

            Graphics.Blit(src, dest, material);
        } else
        {
            Graphics.Blit(src, dest);
        }
    }  
}