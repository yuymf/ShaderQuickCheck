using UnityEngine;
using System.Collections;

public class FogWithDepthTexture : PostEffectsBase
{
    public Shader fogWithDepthTextureShader;
    private Material fogWithDepthTextureMaterial = null;

    public Material material
    {
        get
        {
            fogWithDepthTextureMaterial = CheckShaderAndCreateMaterial(fogWithDepthTextureShader, fogWithDepthTextureMaterial);
            return fogWithDepthTextureMaterial;
        }
    }
	// Get the Camera info: Fov、aspect..
    private Camera myCamera;
	public Camera camera {
		get {
			if (myCamera == null) {
				myCamera = GetComponent<Camera>();
			}
			return myCamera;
		}
	}
	// Get the corner: right、left、up、down
	private Transform myCameraTransform;
	public Transform cameraTransform {
		get {
			if (myCameraTransform == null) {
				myCameraTransform = camera.transform;
			}

			return myCameraTransform;
		}
	}

	[Range(0.0f, 3.0f)]
	public float fogDensity = 1.0f;

	public Color fogColor = Color.white;
	public float fogStart = 0.0f;
	public float fogEnd = 2.0f;
	
	void OnEnable() {
		camera.depthTextureMode |= DepthTextureMode.Depth;
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
		if (material != null) {
			float fov = camera.fieldOfView;
			float near = camera.nearClipPlane;
			float aspect = camera.aspect;

			float halfHeight = near * Mathf.Tan(0.5f * fov * Mathf.Deg2Rad);
			Vector3 toTop = cameraTransform.up * halfHeight;
			Vector3 toRight = cameraTransform.right * halfHeight * aspect;

			Vector3 TL = cameraTransform.forward + toTop - toRight;
			Vector3 TR = cameraTransform.forward + toTop + toRight;
			Vector3 BL = cameraTransform.forward - toTop - toRight;
			Vector3 BR = cameraTransform.forward - toTop + toRight;

			float scale = TL.magnitude / near;

			TL.Normalize();
			TR.Normalize();
			BL.Normalize();
			BR.Normalize();
			TL = TL * scale;
			TR = TR * scale;
			BL = BL * scale;
			BR = BR * scale;

			Matrix4x4 frustumCorners = Matrix4x4.identity;
			frustumCorners.SetRow(0, BL);
			frustumCorners.SetRow(1, BR);
			frustumCorners.SetRow(2, TR);
			frustumCorners.SetRow(3, TL);

			material.SetMatrix("_FrustumCornersRay", frustumCorners);
			material.SetFloat("_FogDensity", fogDensity);
			material.SetColor("_FogColor", fogColor);
			material.SetFloat("_FogStart", fogStart);
			material.SetFloat("_FogEnd", fogEnd);

			Graphics.Blit (src, dest, material);
        } else
        {
            Graphics.Blit(src, dest);
        }
    }  
}