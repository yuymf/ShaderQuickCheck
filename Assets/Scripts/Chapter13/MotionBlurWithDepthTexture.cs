using UnityEngine;
using System.Collections;

public class MotionBlurWithDepthTexture : PostEffectsBase
{
    public Shader motionBlurWithDepthTextureShader;
    private Material motionBlurWithDepthTextureMaterial = null;

    public Material material
    {
        get
        {
            motionBlurWithDepthTextureMaterial = CheckShaderAndCreateMaterial(motionBlurWithDepthTextureShader, motionBlurWithDepthTextureMaterial);
            return motionBlurWithDepthTextureMaterial;
        }
    }

    private Camera myCamera;
	public Camera camera {
		get {
			if (myCamera == null) {
				myCamera = GetComponent<Camera>();
			}
			return myCamera;
		}
	}

	[Range(0.0f, 1.0f)]
	public float blurSize = 0.5f;

	private Matrix4x4 previousViewProjectionMatrix;
	
	void OnEnable() {
		camera.depthTextureMode |= DepthTextureMode.Depth;
        // P * V
		previousViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
		if (material != null) {
			material.SetFloat("_BlurSize", blurSize);

			material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
			Matrix4x4 currentViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
			Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;
			material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
			previousViewProjectionMatrix = currentViewProjectionMatrix;

			Graphics.Blit (src, dest, material);
        } else
        {
            Graphics.Blit(src, dest);
        }
    }  
}