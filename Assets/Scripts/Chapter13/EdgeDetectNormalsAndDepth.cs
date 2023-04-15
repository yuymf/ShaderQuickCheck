using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
public class EdgeDetectNormalsAndDepth : PostEffectsBase
{
    public Shader bianyuanShader;
    private Material bianyuanMaterial;
 
    public Material material
    {
        get
        {
            bianyuanMaterial = CheckShaderAndCreateMaterial(bianyuanShader, bianyuanMaterial);
            return bianyuanMaterial;
        }
    }
 
    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;
    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;
    
    //使用深度法线纹理时使用的采样距离
    public float sampleDistance = 1.0f;
 
    //灵敏度
    public float sensitivityDepth = 1.0f;
    public float sensitivityNormals = 1.0f;
 
    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }
 
    //在所有不透明物体被渲染完后调用
    [ImageEffectOpaque]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(material != null)
        {
            material.SetFloat("_EdgeOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);
            material.SetFloat("_SampleDistance", sampleDistance);
            material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth,0.0f,0.0f));
 
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
 
 
 
 
 
 
}
