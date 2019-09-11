using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawSnowTrack : MonoBehaviour
{
    public Shader SnowTrailDrawShader;
    public Texture BrushTexture;
    public Transform Transform;

    private RenderTexture _TrailMap;
    private Material _SnowMaterial;
    private Material _TrailMaterial;
    private int _LayerMask;
    public Camera _TrailRenderCamera;

    [Range(0,100)]
    public float BrushSize;
    [Range(0,10)]
    public float BrushStrength;

    private void Start()
    {
        _LayerMask = LayerMask.GetMask("Ground");

        _TrailMaterial = new Material(SnowTrailDrawShader);
        _TrailMaterial.SetVector("_Color", Color.red);
        BrushSize = _TrailMaterial.GetFloat("_Size");
        BrushStrength = _TrailMaterial.GetFloat("_Strength");

        _SnowMaterial = gameObject.GetComponent<Renderer>().material;
        _TrailMap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat)
        {
            useMipMap = true
        };
        _TrailMaterial.SetTexture("_BrushTexture", BrushTexture);

        _SnowMaterial.SetTexture("_TrailMap", _TrailMap);
        Graphics.Blit(_SnowMaterial.GetTexture("_HeightMap"), _TrailMap);

        //_TrailRenderCamera.targetTexture = _TrailMap;
    }


    //private void Update()
    //{
    //    if (Physics.Raycast(Transform.position, Vector3.down, out RaycastHit info, transform.localScale.x * 0.5f, _LayerMask))
    //    {
    //        _TrailMaterial.SetVector("_Coordinate", new Vector4(info.textureCoord.x, info.textureCoord.y, 0, 0));

    //        RenderTexture temp = RenderTexture.GetTemporary(_TrailMap.width, _TrailMap.height, 0, RenderTextureFormat.ARGBFloat);
    //        Graphics.Blit(_TrailMap, temp);
    //        Graphics.Blit(temp, _TrailMap, _TrailMaterial);
    //        RenderTexture.ReleaseTemporary(temp);

    //        _TrailMaterial.SetFloat("_Size", BrushSize);
    //        _TrailMaterial.SetFloat("_Strength", BrushStrength);
    //    }
    //}

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, 256, 256), _TrailMap, ScaleMode.ScaleToFit, false, 1);
    }

}
