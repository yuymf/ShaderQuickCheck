# ShaderQuickCheck

### *Intro*

> This is a shader checkhouse, as well as a Unity project with multiple test scenes, materials, and shaders. You can click on the effects hyperlink under contents to find the CG code of the main shader, which can be modified to GLSL, HLSL, and Vulkan GLSL using chatgpt to add to the project. Or load a Unity project to find C#, materials, and model usage. Thanks to Shader for our essential book resources. At the moment I am gradually expanding into more complex effects.
>

***Test Platform***: **Unity2021**

***Shader***: **CG**...

### ***Contents***

- [Basic](Assets/Shader/C5_OriginShader.shader)
- [逐顶点兰伯特漫反射](Assets/Shader/C6_DiffuseVertex.shader)
- [逐像素兰伯特漫反射](Assets/Shader/C6_DiffuseFragment.shader)
- [逐像素半兰伯特漫反射](Assets/Shader/C6_HalfLambert.shader)
- [逐顶点高光反射](Assets/Shader/C6_SpecularVertex.shader)
- [逐像素高光反射](Assets/Shader/C6_SpecularFragment.shader)
- [Blinn-Phone纹理](Assets/Shader/C6_Blinn-Phone.shader)
- [NormalMap: tangentspace](Assets/Shader/C7_NormalTangnentTexture.shader)
- [NormalMap: world space](Assets/Shader/C7_NormalWorldTexture.shader)
- [RampTexture](Assets/Shader/C7_RampTexture.shader)
- [MaskTexture](Assets/Shader/C7_MaskTexture.shader)
- [透明度测试](Assets/Shader/C8_AlphaTest.shader)
- [透明混合](Assets/Shader/C8_AlphaBlend.shader)
- [透明混合zwrite](Assets/Shader/C8_AlphaBlendZWrite.shader)
- [双面透明混合](Assets/Shader/C8_AlphaBlendBothSide.shader)
- [前向渲染](Assets/Shader/C9_ForwardRendering.shader)
- [阴影](Assets/Shader/C9_Shadow.shader)
- [CubeMap](Assets/Scripts/Chapter10/RenderToCubemap.cs)
- [反射](Assets/Shader/C10_Reflection.shader)
- [折射](Assets/Shader/C10_Refraction.shader)
- [Fresnel反射](Assets/Shader/C10_Fresnel.shader)
- [镜面效果](Assets/Shader/C10_Mirror.shader)
- [玻璃效果](Assets/Shader/C10_GlassRefraction.shader)
- [程序纹理](Assets/Scripts/Chapter10/ProceduralTextureGeneration.c)
- [序列帧动画](Assets/Shader/C11_ImageSequenceAnimation.shader)
- [滚动背景](Assets/Shader/C11_ScrollingBackground.shader)
- [流动河流](Assets/Shader/C11_Water.shader)
- [广告牌效应](Assets/Shader/C11_Billboard.shader)
- [亮度、饱和度、对比度](Assets/Shader/C12_BrightSaturateContrast.shader)
- [边缘检测](Assets/Shader/C12_EdgeDetect.shader)
- [高斯模糊](Assets/Shader/C12_GaussianBlur.shader)
- [Bloom](Assets/Shader/C12_Bloom.shader)
- [运动模糊](Assets/Shader/C12_MotionBlur.shader)
- [运动模糊(深图)](Assets/Shader/C13_MotionBlurWithDepthTexture.shader)
- [全局雾效](Assets/Shader/C13_FogWithDepthTexture.shader)
- [卡通风格](Assets/Shader/C14_ToonShading.shader)
- [素描风格](Assets/Shader/C14_Hatching.shader)
- [消融效果](Assets/Shader/C15_Dissolve.shader)
- [水波效果](Assets/Shader/C15_WaterWave.shader)
- [非均匀运动雾](Assets/Shader/C15_FogWithNoise.shader)
- [表面着色器(泥土)](Assets/Shader/C17_BumpedDiffuseSurface.shader)
- [自定义表面着色器 (膨胀)](Assets/Shader/C17_NormalExtrusion.shader)
- [基本PBS](Assets/Prefabs/Chapter18)

### *Effect*

#### 基本

<img src="img/image-20230409000849041.png" alt="image-20230409000849041" style="zoom: 33%;" />

#### 逐顶点兰伯特漫反射

背部带锯齿

<img src="img/image-20230409013930798.png" alt="image-20230409013930798" style="zoom: 33%;" />

#### 逐像素兰伯特漫反射

不带锯齿，背光面明暗一致

<img src="img/image-20230409014809403.png" alt="image-20230409014809403" style="zoom: 33%;" />

#### 逐像素半兰伯特漫反射

使背光面也有明暗变化

<img src="img/image-20230409020141012.png" alt="image-20230409020141012" style="zoom: 33%;" />

#### 逐顶点高光反射

<img src="img/image-20230409033626618.png" alt="image-20230409033626618" style="zoom: 33%;" />

#### 逐像素高光反射

<img src="img/image-20230409033657342.png" alt="image-20230409033657342" style="zoom: 33%;" />

#### Blinn-Phone纹理

<img src="img/image-20230409170836727.png" alt="image-20230409170836727" style="zoom:33%;" />

#### NormalMap: tangent space&world space

<img src="img/image-20230410100050386.png" alt="image-20230410100050386" style="zoom:33%;" />

<img src="img/image-20230410102527142.png" alt="image-20230410102527142" style="zoom: 33%;" />

#### RampTexture

<img src="img/image-20230410105206646.png" alt="image-20230410105206646" style="zoom:33%;" />

#### MaskTexture

<img src="img/image-20230410110839568.png" alt="image-20230410110839568" style="zoom:33%;" />

#### 透明度测试

<img src="img/image-20230410114556370.png" alt="image-20230410114556370" style="zoom:33%;" />

#### 透明混合

<img src="img/image-20230410173741179.png" alt="image-20230410173741179" style="zoom: 33%;" />

#### 透明混合zwrite

<img src="img/image-20230410185005973.png" alt="image-20230410185005973" style="zoom:33%;" />

#### 双面透明混合

<img src="img/image-20230410185859804.png" alt="image-20230410185859804" style="zoom:33%;" />

#### 前向渲染

<img src="img/image-20230410200806911.png" alt="image-20230410200806911" style="zoom:33%;" />

#### 阴影

<img src="img/image-20230410204806751.png" alt="image-20230410204806751" style="zoom:33%;" />

#### CubeMap

<img src="img/image-20230410211410058.png" alt="image-20230410211410058" style="zoom:33%;" />

#### 反射

<img src="img/image-20230410221538443.png" alt="image-20230410221538443" style="zoom: 50%;" />

#### 折射

<img src="img/image-20230410225759745.png" alt="image-20230410225759745" style="zoom:50%;" />

#### Fresnel反射

<img src="img/image-20230410225730184.png" alt="image-20230410225730184" style="zoom: 50%;" />

#### 镜面效果

<img src="img/image-20230410234317404.png" alt="image-20230410234317404" style="zoom:50%;" />

#### 玻璃效果

<img src="img/image-20230411003542993.png" alt="image-20230411003542993" style="zoom: 67%;" />

#### 程序纹理

<img src="img/image-20230411095808076.png" alt="image-20230411095808076" style="zoom:50%;" />

脚本类名要和C#文件名相同

#### 序列帧动画

<img src="img/image-20230411112954722.png" alt="image-20230411112954722" style="zoom:67%;" />

#### 滚动背景

<img src="img/动画.gif" alt="动画" style="zoom: 50%;" />

#### 流动河流

<img src="img/waterWave.gif" alt="waterWave" style="zoom:80%;" />

#### 广告牌效应

![billBoard](img/billBoard.gif)

OnRenderImage、gpu.built

#### 亮度、饱和度、对比度

<img src="img/BriSatCon.gif" alt="BriSatCon" style="zoom:80%;" />

#### 边缘检测

<img src="img/EdgeDetect.gif" alt="EdgeDetect" style="zoom:80%;" />

#### 高斯模糊

<img src="img/GaussianBlur.gif" alt="GaussianBlur" style="zoom:80%;" />

#### Bloom

<img src="img/Bloom.gif" alt="Bloom" style="zoom:80%;" />

#### 运动模糊

<img src="img/MotionBlur.gif" alt="MotionBlur" style="zoom: 67%;" />

#### 运动模糊（深度图）

<img src="img/MotionBlurWDT.gif" alt="MotionBlurWDT" style="zoom:67%;" />

#### 全局雾效

<img src="img/image-20230414234939100.png" alt="image-20230414234939100" style="zoom: 80%;" />

#### 卡通风格

![image-20230415223317865](img/image-20230415223317865.png)

#### 素描风格

![image-20230415233223887](img/image-20230415233223887.png)

#### 消融效果

![Dissolve](img/Dissolve.gif)

#### 水波效果

![WaterWave](img/WaterWave-1681652726851.gif)

#### 非均匀运动雾

<img src="img/FogNoise.gif" alt="FogNoise" style="zoom: 67%;" />

#### 表面着色器（泥土）

<img src="img/image-20230417184234793.png" alt="image-20230417184234793" style="zoom:67%;" />

#### 自定义表面着色器（膨胀）

<img src="img/image-20230417204315111.png" alt="image-20230417204315111" style="zoom:67%;" />

#### 基本PBS

<img src="img/image-20230417215736796.png" alt="image-20230417215736796" style="zoom: 67%;" />

### ***TODO***

More Effects, HLSL&OpenGL Refactor
