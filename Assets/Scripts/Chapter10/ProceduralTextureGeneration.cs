using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode] //支持脚本在 Edit Mode（编辑模式）下运行
public class ProceduralTextureGeneration : MonoBehaviour
{
    //-------------【声明变量】---------------
    public Material m_material = null;    //声明材质变量
	private Texture2D m_generateTexture = null; //声明纹理变量
    

    #region Marerial properties
        //【纹理大小】---------------------
        [SerializeField , SetPropertyAttribute("textureWidth")]      //SetProperty是一个插件，在面板上修改属性时任然可以执行set函数
        private int m_textureWidth = 512;
        public int textureWidth {
            get {
                return m_textureWidth;      //获取纹理大小
            }
            set {
                m_textureWidth = value;     //设置纹理大小
                _UpdateMaterial();          //更新纹理
            }
        }
        //【背景颜色】---------------------
        [SerializeField  , SetProperty("backgroundColor")]    
        private Color m_backgroundColor = Color.white;
        public Color backgroundColor {
            get {
                return m_backgroundColor;   //获取背景颜色
            }
            set {
                m_backgroundColor = value;  //设置背景颜色
                _UpdateMaterial();          //更新纹理
            }
        }
        //【圆点颜色】---------------------
        [SerializeField , SetPropertyAttribute("circleColor")]
        private Color m_circleColor = Color.white;
        public Color circleColor {
            get {
                return m_circleColor;       //获取圆点颜色
            }
            set {
                m_circleColor = value;      //设置圆点颜色
                _UpdateMaterial();          //更新纹理
            }
        }
        //【模糊因子】---------------------
        [SerializeField , SetProperty("blurFactor")]
        private float m_blurFactor = 2.0f;
        public float blurFactor {
            get {
                return m_blurFactor;        //获取模糊因子
            }
            private set {
                m_blurFactor = value;       //设置模糊因子
                _UpdateMaterial();          //更新纹理
            }
        }
    #endregion

    //--------------【定义函数】---------------
    //【函数：更新材质】
    private void _UpdateMaterial()  {
        if (m_material != null) {                                   //如果材质不为空
            m_generateTexture = _GenerateProceduralTexture();       //更新纹理
            m_material.SetTexture("_MainTex" , m_generateTexture);  //将纹理赋予到材质中名为_MainTex的纹理属性
        }
    }
    //【函数：混合颜色】
    private Color _MixColor(Color color0, Color color1, float mixFactor) {
    Color mixColor = Color.white;
    mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
    mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
    mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
    mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
    return mixColor;
	}

    //【函数：更新纹理】
    private Texture2D  _GenerateProceduralTexture() {
        Texture2D proceduralTexture = new Texture2D(textureWidth , textureWidth);   //新建一个长宽都为textureWidth的纹理
        //【定义圆与圆的间距】
        float circleInterval = textureWidth / 4.0f;     //圆的间距为纹理的1/4
        //【定义圆的半径】
        float radius = textureWidth / 10.0f;            //圆的半径为纹理的1/10
        //【定义模糊系数】
        float edgeBlur = 1.0f / blurFactor;             //模糊系数与模糊因子成反比

        for (int w = 0; w < textureWidth; w++) {        //横循环每个像素
            for (int h = 0; h < textureWidth; h++) {    //纵循环每个像素
                //【使用背景颜色进行初始化】
                Color pixel = backgroundColor;
                //【依次画9个圆】
                for (int i = 0; i < 3; i++) {           
                    for(int j =0; j < 3; j++) {
                        //【计算当前绘制的圆心位置:每格一个间距存在一个圆心】
                        Vector2 circleCenter = new Vector2(circleInterval * (i + 1), circleInterval * (j + 1));    
                        //【计算当前像素与圆心的距离：用Distance函数】
                        float dist = Vector2.Distance(new Vector2(w , h), circleCenter) - radius;
                        //【模糊圆的边界,用库函数Mathf.SmoothStep】
                        Color color = _MixColor(circleColor , new Color(pixel.r , pixel.g , pixel.b , 0.0f) , Mathf.SmoothStep(0f , 1.0f , dist * edgeBlur));
                        //【与之前颜色进行混合】
                        pixel = _MixColor(pixel , color , color.a);
                    }
                }
                proceduralTexture.SetPixel(w , h , pixel);  //更新每个像素点的颜色
            }
        }
        proceduralTexture.Apply();      //应用纹理
        return proceduralTexture;       //返回纹理
    }
	//-----------【Start】----------------
	void Start()
    {
       if (m_material == null) {
           Renderer m_renderer = gameObject.GetComponent<Renderer>();   //获取物体的Renderer组件
           if (m_renderer == null) {                                    //如果物体没有Renderer组件
               Debug.LogWarning("无法找到renderer");                     //输出Waringing日志
               return;
           }
           m_material = m_renderer.sharedMaterial;                      //将Renderer组件赋予空材质
       }
       _UpdateMaterial();                                               //更新材质
    }
}